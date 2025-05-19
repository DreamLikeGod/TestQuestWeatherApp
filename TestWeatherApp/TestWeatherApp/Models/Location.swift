//
//  Location.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

struct Location: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    enum CodingKeys: CodingKey {
        case name
        case country
        case lat
        case lon
    }
}
