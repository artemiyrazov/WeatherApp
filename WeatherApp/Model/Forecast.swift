//
//	WeatherData.swift
// 	WeatherApp
//

import Foundation

struct Forecast {
    private let timestamp: Int
    private let weatherArray: [Weather]
    let temperature: Double
    var dateString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, d"
        return dateFormatter.string(from: date)
    }
    var weather: Weather {
        weatherArray[0]
    }
}

extension Forecast: Decodable {
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temp
        case weather
    }
    
    enum TemparatureCodingKeys: String, CodingKey {
        case temparature = "day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Int.self, forKey: .timestamp)
        weatherArray = try container.decode([Weather].self, forKey: .weather)
        
        // Nested container with temperature
        let temperatureContainer = try container.nestedContainer(keyedBy: TemparatureCodingKeys.self, forKey: .temp)
        temperature = try temperatureContainer.decode(Double.self, forKey: .temparature)
    }
}

enum WeatherType: String, Decodable {
    case Thunderstorm
    case Drizzle
    case Rain
    case Snow
    case Atmosphere
    case Clear
    case Clouds
    
    var systemImageName: String {
        switch self {
        case .Thunderstorm:
            return "cloud.bolt.rain"
        case .Drizzle:
            return "cloud.drizzle"
        case .Rain:
            return "cloud.rain"
        case .Snow:
            return "cloud.snow"
        case .Atmosphere:
            return "cloud.fog"
        case .Clear:
            return "sun.max"
        case .Clouds:
            return "cloud"
        }
    }
}

struct DailyForecastResponse: Decodable {
    let forecastArray: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case forecastArray = "daily"
    }
}

struct Weather: Decodable {
    let description: String
    let weatherType: WeatherType
    
    enum CodingKeys: String, CodingKey {
        case description
        case weatherType = "main"
    }
}
