//
//	NetworkService.swift
// 	WeatherApp
//

import Foundation
import CoreLocation

class NetworkService {
    
    func dailyForecastRequest(latitude: Double, longitude: Double,
                             completion: @escaping(Result<[Forecast], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: OpenWeatherAPIConstants.getWeatherUrl)
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "lat", value: String(latitude)))
        queryItems.append(URLQueryItem(name: "lon", value: String(longitude)))
        queryItems.append(URLQueryItem(name: "appid", value: OpenWeatherAPIConstants.APIKey))
        queryItems.append(URLQueryItem(name: "units", value: TemperatureUnits.celsius.rawValue))
        queryItems.append(URLQueryItem(name: "lang", value: NSLocalizedString("language", comment: "")))
        
        let excludedReports: String = "\(ForecastReportType.current),\(ForecastReportType.hourly),\(ForecastReportType.minutely)"
        queryItems.append(URLQueryItem(name: "exclude",
                                       value: excludedReports))
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }        
        
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else {
                completion(.failure(ForecastRequestError.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(DailyForecastResponse.self, from: data) {
                completion(.success(result.forecastArray))
            } else {
                completion(.failure(ForecastRequestError.invalidJSON))
            }
        }.resume()
    }
}
