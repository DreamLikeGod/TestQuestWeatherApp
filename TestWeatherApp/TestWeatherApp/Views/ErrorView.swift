//
//  ErrorView.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 15.05.2025.
//

import UIKit

private extension CGFloat {
    static let fontSize: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    
    static let stackSpacing: CGFloat = 20
    static let stackVerticalOffset: CGFloat = 20
    static let stackHorizontalOffset: CGFloat = 20
}

class ErrorView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .fontSize, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: .fontSize, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var retryAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = .cornerRadius
        backgroundColor = .secondarySystemBackground
        
        let stackView = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stackView.axis = .vertical
        stackView.spacing = .stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .stackVerticalOffset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .stackHorizontalOffset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.stackHorizontalOffset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.stackVerticalOffset)
        ])
        
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    func configure(message: String, retryAction: @escaping () -> Void) {
        messageLabel.text = message
        self.retryAction = retryAction
    }
    
    @objc private func retryButtonTapped() {
        retryAction?()
    }
}
