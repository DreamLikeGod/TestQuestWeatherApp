//
//  CurrentWeather.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

struct Weather: Decodable {
    let location: Location
    let current: WeatherData
    let forecast: Forecast?
    
    enum CodingKeys: String, CodingKey {
        case location
        case current
        case forecast
    }
}
