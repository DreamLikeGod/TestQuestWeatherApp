//
//  WeatherViewController.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var currentWeather: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var hourlyWeather: HourlyWeatherView = {
        let view = HourlyWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dailyWeather: DailyWeatherView = {
        let view = DailyWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            fetchWeather()
        }
    }
    
    private let weatherManager = WeatherManager.shared
    private var locationManager: LocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoading()
        locationManager = LocationManager(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    self?.currentLocation = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
                case .success(let coordinates):
                    self?.currentLocation = coordinates
                }
            }
        })
    }
    
}

private extension WeatherViewController {
    func addSubviews() {
        view.addSubview(contentView)
        contentView.addSubview(currentWeather)
        contentView.addSubview(hourlyWeather)
        contentView.addSubview(dailyWeather)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            currentWeather.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            currentWeather.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentWeather.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            hourlyWeather.topAnchor.constraint(equalTo: currentWeather.bottomAnchor, constant: 20),
            hourlyWeather.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hourlyWeather.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourlyWeather.heightAnchor.constraint(equalToConstant: 120),
            
            dailyWeather.topAnchor.constraint(equalTo: hourlyWeather.bottomAnchor, constant: 20),
            dailyWeather.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dailyWeather.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dailyWeather.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        
    }
    func viewSetup() {
        view.backgroundColor = .clear
        view.createGradient(with: .topRightToBottomLeft, and: [UIColor.systemCyan.cgColor, UIColor.systemBlue.cgColor])
        
        addSubviews()
        setupConstraints()
    }
    func showLoading() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        contentView.isHidden = true
        errorView.isHidden = true
    }
    func showError(with message: String, retryAction: @escaping () -> Void) {
        loadingIndicator.stopAnimating()
        contentView.isHidden = true
        errorView.isHidden = false
        errorView.configure(message: message, retryAction: retryAction)
    }
    func showWeather() {
        loadingIndicator.stopAnimating()
        contentView.isHidden = false
        errorView.isHidden = true
    }
    func fetchWeather() {
        guard let location = self.currentLocation else { return }
        weatherManager.fetchCurrentWeather(in: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.showError(with: error.localizedDescription) {
                        self?.fetchWeather()
                    }
                case .success(let data):
                    self?.currentWeather.configureCurrentWeather(data)
                    self?.showWeather()
                }
            }
        }
        weatherManager.fetchForecastWeather(in: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.showError(with: error.localizedDescription) {
                        self?.fetchWeather()
                    }
                case .success(let data):
                    if let hoursData = self?.configureHourData(with: data) {
                        self?.hourlyWeather.configureHourlyView(hoursData)
                        self?.dailyWeather.configureDailyView(data)
                        self?.showWeather()
                    } else {
                        self?.showError(with: "Configure hourly data failed") {
                            self?.fetchWeather()
                        }
                    }
                }
            }
        }
    }
    func configureHourData(with weatherData: [ForecastDay]) -> [Hour] {
        if !weatherData.isEmpty {
            let currentHour = Calendar.current.component(.hour, from: Date())
            let todayHours = weatherData[0].hour.filter { hour in
                let hourString = hour.time.components(separatedBy: " ").last ?? ""
                let hourValue = Int(hourString.components(separatedBy: ":").first ?? "0") ?? 0
                return hourValue >= currentHour
            }
            
            let tomorrowHours = weatherData.count >= 1 ? weatherData[1].hour : []
            let allHours = todayHours + tomorrowHours
            return allHours
        }
        return []
    }
}
