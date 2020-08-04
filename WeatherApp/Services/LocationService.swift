//
//	LocationService.swift
// 	WeatherApp
//

import Foundation
import CoreLocation

class LocationService {
    
    private let locationManager = CLLocationManager()
    var locationManagerDelegate: CLLocationManagerDelegate? {
        didSet {
            locationManager.delegate = locationManagerDelegate
        }
    }
    
    func geocodeLocation (from location: CLLocation, completion: @escaping(Result<Location, LocationRequestError>) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first,
                let name = placemark.locality,
                error == nil else {
                    completion(.failure(.locationUndefined))
                    return
            }
            completion(.success(Location(name: name,
                                         latitude: location.coordinate.latitude,
                                         longitude: location.coordinate.longitude)))
        }
    }
    
    func locationAvailability() throws {
        guard CLLocationManager.locationServicesEnabled() else { throw LocationRequestError.locationServicesDisabled }
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            throw LocationRequestError.locationUnavailable
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestLocation()
            break
        }
    }
}
