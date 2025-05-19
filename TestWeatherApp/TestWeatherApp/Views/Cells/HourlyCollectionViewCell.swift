//
//  HourlyCollectionViewCell.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 15.05.2025.
//

import UIKit

private extension CGFloat {
    static let timeLabelSize: CGFloat = 14
    static let tempLabelSize: CGFloat = 18
    
    static let iconSize: CGFloat = 30
    static let stackSpacing: CGFloat = 5
}

class HourlyCollectionViewCell: UICollectionViewCell {
    static var identifier: String { "\(Self.self)" }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .timeLabelSize, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .tempLabelSize, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = .stackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timeLabel.text = nil
        tempLabel.text = nil
        iconImageView.image = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addViews()
        setupViews()
    }
    public func configure(with hour: Hour) {
        let timeString = hour.time
        timeLabel.text = checkingCurrentTime(with: timeString)
        tempLabel.text = "\(Int(hour.temp))°"
        
        iconImageView.loadImage(hour.condition.icon)
    }
}

private extension HourlyCollectionViewCell {
    func addViews() {
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(tempLabel)
        
        contentView.addSubview(stackView)
    }
    func setupViews() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: .iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: .iconSize)
        ])
    }
    func checkingCurrentTime(with stringDate: String) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH"
        guard let separatedString = stringDate.components(separatedBy: ":").first else { return " " }
        let currentDate = dateFormatter.string(from: date)
        if separatedString == currentDate {
            return "Сейчас"
        }
        
        return separatedString.components(separatedBy: " ").last ?? " "
    }
}
