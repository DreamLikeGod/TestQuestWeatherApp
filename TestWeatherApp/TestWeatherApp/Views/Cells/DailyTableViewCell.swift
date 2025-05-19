//
//  DailyTableViewCell.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 15.05.2025.
//

import UIKit

private extension CGFloat {
    static let dateLabelSize: CGFloat = 16
    static let labelSize: CGFloat = 20
    static let conditionChanceSize: CGFloat = 8
    static let scaleFactor: CGFloat = 0.5
    static let stackSpacing: CGFloat = 5
    
    static let imageSize: CGFloat = 24
    
    static let itemsHorizontalOffset: CGFloat = 10
    static let itemsVerticalOffset: CGFloat = 15
    static let stackVerticalOffset: CGFloat = 5
}

class DailyTableViewCell: UITableViewCell {
    static var identifier: String { "\(Self.self)" }
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .dateLabelSize, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .scaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var conditionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .stackSpacing
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var conditionChanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: .conditionChanceSize, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .scaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var minimumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .labelSize, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .scaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var maximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: .labelSize, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .scaleFactor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        conditionImageView.image = nil
        conditionChanceLabel.text = nil
        minimumTemperatureLabel.text = nil
        maximumTemperatureLabel.text = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addSubviews()
        setupConstraints()
    }
    
    public func configureDailyCell(_ model: ForecastDay) {
        dateLabel.text = createDateLabel(from: model.date)
        minimumTemperatureLabel.text = "\(Int(model.day.mintemp))°"
        maximumTemperatureLabel.text = "\(Int(model.day.maxtemp))°"
        
        conditionImageView.loadImage(model.day.condition.icon)
        if let text = createChanceLabel(from: (model.day.rain, model.day.snow)) {
            conditionChanceLabel.text = text
        } else {
            conditionStack.removeArrangedSubview(conditionChanceLabel)
        }
    }

}
private extension DailyTableViewCell {
    func addSubviews() {
        conditionStack.addArrangedSubview(conditionImageView)
        conditionStack.addArrangedSubview(conditionChanceLabel)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(conditionStack)
        contentView.addSubview(minimumTemperatureLabel)
        contentView.addSubview(maximumTemperatureLabel)
        contentView.backgroundColor = .clear
        contentView.createBlurEffect(with: .regular)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            minimumTemperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            minimumTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .itemsVerticalOffset),
            minimumTemperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.itemsVerticalOffset),
            
            maximumTemperatureLabel.centerYAnchor.constraint(equalTo: minimumTemperatureLabel.centerYAnchor),
            maximumTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.itemsHorizontalOffset),
            
            dateLabel.centerYAnchor.constraint(equalTo: minimumTemperatureLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .itemsHorizontalOffset),
            
            conditionImageView.widthAnchor.constraint(equalToConstant: .imageSize),
            conditionImageView.heightAnchor.constraint(equalToConstant: .imageSize),
            
            conditionStack.trailingAnchor.constraint(equalTo: minimumTemperatureLabel.leadingAnchor, constant: -.itemsHorizontalOffset),
            conditionStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .stackVerticalOffset),
            conditionStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.stackVerticalOffset)
        ])
    }
    
    func createDateLabel(from dateString: String) -> String {
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let nowDateString = formatter.string(from: nowDate)
        if nowDateString == dateString {
            return "Сегодня"
        }
        let date = formatter.date(from: dateString)!
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    func createChanceLabel(from tuple: (rain: Int, snow: Int)) -> String? {
        if tuple.rain > 20 && tuple.snow > 20 {
            let text = tuple.rain > tuple.snow ? "\(tuple.rain)" : "\(tuple.snow)"
            return text + " %"
        } else if tuple.rain > 20 {
            return "\(tuple.rain) %"
        } else if tuple.snow > 20 {
            return "\(tuple.snow) %"
        }
        return nil
    }
}
