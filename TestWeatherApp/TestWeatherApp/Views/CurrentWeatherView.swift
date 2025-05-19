//
//  CurrentWeatherView.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

import UIKit

private extension CGFloat {
    static let cityLabelSize: CGFloat = 20
    static let temperatureLabelSize: CGFloat = 30
    static let weatherDescriptionLabelSize: CGFloat = 17
    static let feelsLikeLabelSize: CGFloat = 12
    
    static let detailHeight: CGFloat = 60
    static let detailSpacing: CGFloat = 10
    static let detailIconSize: CGFloat = 20
    static let detailTitleLabelSize: CGFloat = 12
    static let detailValueLabelSize: CGFloat = 16
    static let detailVerticalOffset: CGFloat = 5
    
    static let conditionImageViewSize: CGFloat = 60
    static let horizontalOffset: CGFloat = 20
    static let verticalOffset: CGFloat = 10
    static let detailsTopOffset: CGFloat = 20
    
    static let labelScaleFactor: CGFloat = 0.5
}

class CurrentWeatherView: UIView {

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .cityLabelSize, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .labelScaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .temperatureLabelSize, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .labelScaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: .weatherDescriptionLabelSize, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .labelScaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .feelsLikeLabelSize, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .labelScaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = .detailSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addViews()
        setupViews()
    }
    
    public func configureCurrentWeather(_ model: Weather) {
        cityLabel.text = model.location.name
        temperatureLabel.text = "\(Int(model.current.temp))°"
        conditionImageView.loadImage(model.current.condition.icon)
        weatherDescriptionLabel.text = model.current.condition.text
        feelsLikeLabel.text = "Ощущается как: \(Int(model.current.feels))°"
        
        let windView = createDetailView(title: "Ветер", value: "\(model.current.wind)", icon: "wind")
        let humidityView = createDetailView(title: "Влажность", value: "\(model.current.humidity)", icon: "humidity")
        let uvView = createDetailView(title: "UV Индекс", value: "\(model.current.uv)", icon: "sun.max")
        
        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        detailsStack.addArrangedSubview(windView)
        detailsStack.addArrangedSubview(humidityView)
        detailsStack.addArrangedSubview(uvView)
    }
    
}

private extension CurrentWeatherView {
    func addViews() {
        addSubview(cityLabel)
        addSubview(temperatureLabel)
        addSubview(conditionImageView)
        addSubview(weatherDescriptionLabel)
        addSubview(feelsLikeLabel)
        addSubview(detailsStack)
    }
    func setupViews() {
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: .verticalOffset),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .horizontalOffset),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.horizontalOffset),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: .verticalOffset),
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .horizontalOffset),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.horizontalOffset),
            
            conditionImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: .verticalOffset),
            conditionImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            conditionImageView.widthAnchor.constraint(equalToConstant: .conditionImageViewSize),
            conditionImageView.heightAnchor.constraint(equalToConstant: .conditionImageViewSize),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: conditionImageView.bottomAnchor, constant: .verticalOffset),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .horizontalOffset),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.horizontalOffset),
            
            feelsLikeLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: .verticalOffset),
            feelsLikeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .horizontalOffset),
            feelsLikeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.horizontalOffset),
            
            detailsStack.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: .detailsTopOffset),
            detailsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .horizontalOffset),
            detailsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.horizontalOffset),
            detailsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.verticalOffset),
            detailsStack.heightAnchor.constraint(equalToConstant: .detailHeight)
        ])
    }
    func createDetailView(title: String, value: String, icon: String) -> UIView {
        let view = UIView()
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: .detailTitleLabelSize, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = .labelScaleFactor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: .detailValueLabelSize, weight: .semibold)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: .detailIconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: .detailIconSize),
            
            valueLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .detailVerticalOffset),
            valueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: .detailVerticalOffset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}
