//
//	TodayViewController.swift
// 	Weather Widget
//

import UIKit
import NotificationCenter

class WeatherTodayViewController: UIViewController, NCWidgetProviding {
    
    private let coreDataSerivce = CoreDataService.shared
    private var weatherTodayView: WeatherTodayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTodayView = view as? WeatherTodayView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMainApplication))
        weatherTodayView.addGestureRecognizer(tap)
        
        if let (forecast, location) = getNewWeatherForecast() {
            updateView(with: forecast, location: location)
        }
    }
    
    @objc private func openMainApplication() {
        extensionContext?.open(URL(string: "WeatherApp://")!, completionHandler: nil)
    }
    
    private func getNewWeatherForecast() -> (Forecast, Location)? {
        guard let cachedForecast = CoreDataService.shared.fetchForecasts().first,
            let location = Location() else { return nil }
        
        let forecast = Forecast(temperature: Int(cachedForecast.temperature),
                                date: cachedForecast.date!,
                                description: cachedForecast.weatherDescription!,
                                weatherType: WeatherType(rawValue: cachedForecast.weatherType!)!)
        
        return (forecast, location)
    }
    
    private func updateView(with forecast: Forecast, location: Location) {
        weatherTodayView.showForecast(regionName: location.name,
                                      description: forecast.description,
                                      temperature: forecast.temperature,
                                      systemImageName: forecast.weatherType.systemImageName)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        if let (forecast, location) = getNewWeatherForecast() {
            updateView(with: forecast, location: location)
            completionHandler(.newData)
        } else {
            completionHandler(.failed)
        }
    }
    
}
