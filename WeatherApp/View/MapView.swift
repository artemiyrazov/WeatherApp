//
//	MapView.swift
// 	WeatherApp
//

import UIKit
import MapKit

class MapView: UIView {
    
    @IBOutlet private weak var mkMapView: MKMapView! {
        didSet {
            mkMapView.delegate = self
        }
    }
    private let annotationIdentifier = "annotationID"
    private var annotationImageName = "thermometer"
    
    func centeringMap(around coordinate: CLLocationCoordinate2D, regionInMeters: CLLocationDistance = 1000) {
        mkMapView.setRegion(MKCoordinateRegion(center: coordinate,
                                               latitudinalMeters: regionInMeters,
                                               longitudinalMeters: regionInMeters), animated: true)
    }
    
    func addAnnotationOnMap(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String, annotationImageName: String) {
        
        self.annotationImageName = annotationImageName
        
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinate
        
        mkMapView.addAnnotation(annotation)
        mkMapView.selectAnnotation(annotation, animated: true)
        centeringMap(around: coordinate)
    }
}

// MARK: - MKMapViewDelegate

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        annotationView?.rightCalloutAccessoryView = UIImageView(image: UIImage(systemName: annotationImageName))
           
        return annotationView
    }
}
