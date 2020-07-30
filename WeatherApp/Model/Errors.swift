//
//	Error.swift
// 	WeatherApp
//

import Foundation

enum ForecastRequestError: String, Error {
    case invalidJSON = "JSON parsing error"
    case invalidResponse = "Network request error"
}
