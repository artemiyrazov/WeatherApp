//
//	MapViewController.swift
// 	WeatherApp
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var location: Location? {
        didSet {
            guard let location = location else { return }
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.centeringMap(around: coordinate, regionInMeters: 100 * 1000)
            }
    }
    
    var forecast: Forecast? {
        didSet {
            updateView()
        }
    }
    
    private var mapView: MapView!
    
    override func viewDidLoad() {
        mapView = view as? MapView
    }
    
    func updateView () {
        loadViewIfNeeded()
        
        guard let location = location, let forecast = forecast else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotationOnMap(coordinate, title: "\(Int(forecast.temperature))ºC", subtitle: forecast.weather.description, annotationImageName: forecast.weather.weatherType.systemImageName)
    }
}

// MARK: - MapPresenterDelegate

extension MapViewController: MapPresenterDelegate {
    func forecastSelected(_ newForecast: Forecast) {
        forecast = newForecast
    }
    
    func locationUpdated(_ newLocation: Location) {
        location = newLocation
    }
}
