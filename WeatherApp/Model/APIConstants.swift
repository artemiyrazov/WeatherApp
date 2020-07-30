//
//	APIConstants.swift
// 	WeatherApp
//

import Foundation

enum TemperatureUnits: String {
    // Include nothing in request for Kelvin units
    case celsius = "metric"
    case fahrenheit = "imperial"
}

enum ForecastReportType: String {
    case current
    case minutely
    case hourly
    case daily
}

enum OpenWeatherAPIConstants {
    static let APIKey = "13dc246a7290f4b3221209cd010dd554"
    static let getWeatherUrl = "https://api.openweathermap.org/data/2.5/onecall"
}

enum FakeRegion {
    static let name = "Saint-Petersburg"
    static let latitude = 59.939095
    static let longitude = 30.315868
}
