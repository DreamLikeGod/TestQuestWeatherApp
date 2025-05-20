//
//  LocationManager.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 15.05.2025.
//

import CoreLocation

final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private var updateHandler: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    
    init(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        super.init()
        locationManager.delegate = self
        self.updateHandler = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
        self.updateHandler = nil
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationSafe = locations.last else {
            self.updateHandler?(.failure(LocationError.noLocationData))
            return
        }
        locationManager.stopUpdatingLocation()
        self.updateHandler?(.success(locationSafe.coordinate))
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined, .denied, .restricted:
            updateHandler?(.failure(LocationError.noLocationData))
        @unknown default:
            fatalError()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("\(error.localizedDescription)")
    }
}

enum LocationError: String, Error {
    case noLocationData = "Can't get location data!"
}
