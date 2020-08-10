//
//	Error.swift
// 	WeatherApp
//

import Foundation

enum ForecastRequestError: String, Error {
    case invalidJSON
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidJSON:
            return "JSON parsing error".localized()
        case .invalidResponse:
            return "Network request error".localized()
        }
    }
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
