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
            return "location services disabled".localized()
        case .locationUnavailable:
            return "location unavailable".localized()
        case .locationUndefined:
            return "location undefined".localized()
        }
    }
}
