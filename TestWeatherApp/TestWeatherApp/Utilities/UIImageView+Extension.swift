//
//  UIImageView+Extension.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

import UIKit

extension UIImageView {
    
    func loadImage(_ urlString: String) {
        WeatherManager.shared.downloadIcon(with: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.image = UIImage(data: data)
                case .failure(let error):
                    self.image = UIImage(systemName: "xmark.app")
                    print("Error fetching icon: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
