//
//  Forecast.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 14.05.2025.
//

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Decodable {
    let maxtemp: Double
    let mintemp: Double
    let rain: Int
    let snow: Int
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxtemp = "maxtemp_c"
        case mintemp = "mintemp_c"
        case rain = "daily_chance_of_rain"
        case snow = "daily_chance_of_snow"
        case condition
    }
}

struct Hour: Decodable {
    let time: String
    let temp: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case time
        case temp = "temp_c"
        case condition
    }
}
