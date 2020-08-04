//
//	MapView.swift
// 	WeatherApp
//

import UIKit
import MapKit

class MapView: UIView {
    
    @IBOutlet private weak var mkMapView: MKMapView!
    private let regionInMeters = 1000.0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func centeringMap(around coordinate: CLLocationCoordinate2D) {
        mkMapView.setRegion(MKCoordinateRegion(center: coordinate,
                                               latitudinalMeters: regionInMeters,
                                               longitudinalMeters: regionInMeters), animated: true)
    }
    
    func addAnnotationOnMap(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinate
        centeringMap(around: coordinate)
        mkMapView.addAnnotation(annotation)
        mkMapView.selectAnnotation(annotation, animated: true)
    }
}

