//
//  WeatherManager.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 15.05.2025.
//

import Foundation
import CoreLocation


enum WeatherAPI {
    case current
    case forecast
    
    var baseUrl: String {
        "https://api.weatherapi.com/v1"
    }
    var endpoint: String {
        switch self {
        case .current:
            return "/current.json"
        case .forecast:
            return "/forecast.json"
        }
    }
    var apiKey: String {
        "fa8b3df74d4042b9aa7135114252304"
    }
    var days: Int {
        7
    }
    var language: String {
        "ru"
    }
}

final class WeatherManager {
    
    static let shared = WeatherManager()
    
    private init() {}
    
    func sendRequest(type: WeatherAPI, with coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Data, Error>) -> Void) {
        let httpString = "\(type.baseUrl)\(type.endpoint)?key=\(type.apiKey)&q=\(coordinates.latitude),\(coordinates.longitude)&lang=\(type.language)"
        var urlString: String
        switch type {
        case .current:
            urlString = httpString
        case .forecast:
            urlString = httpString + "&days=\(type.days)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
    func parseData<T: Decodable>(from data: Data, in type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let json = try? JSONDecoder().decode(type, from: data) else {
            completion(.failure(NetworkError.decodingError))
            return
        }
        completion(.success(json))
    }
    func fetchCurrentWeather(in coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Weather, Error>) -> Void) {
        sendRequest(type: .current, with: coordinates) { [weak self] requestResult in
            switch requestResult {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let data):
                self?.parseData(from: data, in: Weather.self) { parseResult in
                    switch parseResult {
                    case .failure(let parseError):
                        completion(.failure(parseError))
                        return
                    case .success(let info):
                        completion(.success(info))
                    }
                }
            }
        }
    }
    func fetchForecastWeather(in coordinates: CLLocationCoordinate2D, completion: @escaping (Result<[ForecastDay], Error>) -> Void) {
        sendRequest(type: .forecast, with: coordinates) { [weak self] requestResult in
            switch requestResult {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let data):
                self?.parseData(from: data, in: Weather.self) { parseResult in
                    switch parseResult {
                    case .failure(let parseError):
                        completion(.failure(parseError))
                        return
                    case .success(let data):
                        guard let forecast = data.forecast else {
                            completion(.failure(NetworkError.noForeCastData))
                            return
                        }
                        completion(.success(forecast.forecastday))
                    }
                }
            }
        }
    }
    
    func downloadIcon(with url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let iconUrl = URL(string: "https:\(url)") else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: iconUrl) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: String, Error {
    case invalidUrl = "Using unknown URL"
    case noData = "No data returned for API"
    case decodingError = "Can't decode this Data"
    case noForeCastData = "No Forecast Data Found"
}
