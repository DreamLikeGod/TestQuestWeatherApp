//
//  DailyWeatherView.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

import UIKit

private extension CGFloat {
    static let cornerRadius: CGFloat = 12
    
    static let tableViewVerticalOffset: CGFloat = 5
    
    static let separatorHorizontalInsets: CGFloat = 10
    static let separatorVerticalInsets: CGFloat = 0
}

class DailyWeatherView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBlue
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: .separatorVerticalInsets, left: .separatorHorizontalInsets, bottom: .separatorVerticalInsets, right: .separatorHorizontalInsets)
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var dailyWeather: [ForecastDay] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureDailyView(_ model: [ForecastDay]) {
        self.dailyWeather = model
        self.tableView.reloadData()
    }
}

private extension DailyWeatherView {
    func setupView() {
        backgroundColor = .clear
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: .tableViewVerticalOffset),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.tableViewVerticalOffset),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        layer.cornerRadius = .cornerRadius
        tableView.layer.cornerRadius = .cornerRadius
    }
}

extension DailyWeatherView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
        cell.configureDailyCell(dailyWeather[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Прогноз погоды на 7 дней"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
