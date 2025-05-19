//
//  Current.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

struct WeatherData: Decodable {
    let temp: Double
    let condition: Condition
    let wind: Double
    let humidity: Int
    let feels: Double
    let uv: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case condition
        case wind = "wind_kph"
        case humidity
        case feels = "feelslike_c"
        case uv
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
    
    enum CodingKeys: CodingKey {
        case text
        case icon
    }
}
