//
//    Region.swift
//     WeatherApp
//

import Foundation

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
    
    static let fakeLocation = Location(name: "Cupertino".localized(), latitude: 37.322621, longitude: -122.031945)
}
