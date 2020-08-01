//
//	Error.swift
// 	WeatherApp
//

import Foundation

enum ForecastRequestError: String, Error {
    case invalidJSON = "JSON parsing error"
    case invalidResponse = "Network request error"
}

enum LocationRequestError: Error {
    case locationServicesDisabled
    case locationUnavailable
    case locationUndefined
    
    var localizedDescription: String {
        switch self {
        case .locationServicesDisabled:
            return "Location services disabled.\nTurn on Settings - Privacy - Location services"
        case .locationUnavailable:
            return "Location unavailable.\nTurn on Settings - Weather - Location"
        case .locationUndefined:
            return "Location undefined. Try again later"
        }
    }
}
