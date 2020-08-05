//
//	MapViewController.swift
// 	WeatherApp
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var location: Location!
    var forecast: Forecast!
    
    private var mapView: MapView!
    
    override func viewDidLoad() {
        
        mapView = view as? MapView
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotationOnMap(coordinate, title: "\(Int(forecast.temperature))ºC",
            subtitle: forecast.description,
            annotationImageName: forecast.weatherType.systemImageName)
    }
}
