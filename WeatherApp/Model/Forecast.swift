//
//	WeatherData.swift
// 	WeatherApp
//

import Foundation

struct Forecast {
    let temperature: Int
    let date: Date
    let description: String
    let weatherType: WeatherType

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, d"
        return dateFormatter.string(from: date)
    }
}

struct DailyForecastResponse: Decodable {
    let forecastArray: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case forecastArray = "daily"
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
    
    enum WeatherCodingKeys: String, CodingKey {
        case description
        case weatherType = "main"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timestamp = try container.decode(Int.self, forKey: .timestamp)
        date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        // Nested container with weather
        var weatherArrayContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let weatherContainer = try weatherArrayContainer.nestedContainer(keyedBy: WeatherCodingKeys.self)
        description = try weatherContainer.decode(String.self, forKey: .description)
        weatherType = try weatherContainer.decode(WeatherType.self, forKey: .weatherType)
                
        // Nested container with temperature
        let temperatureContainer = try container.nestedContainer(keyedBy: TemparatureCodingKeys.self, forKey: .temp)
        temperature = try  Int(temperatureContainer.decode(Double.self, forKey: .temparature))
    }
}

enum WeatherType: String, Decodable {
    case Thunderstorm, Drizzle, Rain, Snow, Atmosphere, Clear, Clouds
    
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
