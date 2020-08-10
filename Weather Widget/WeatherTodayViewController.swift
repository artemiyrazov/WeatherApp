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
        
        guard let cachedForecast = coreDataSerivce.fetchForecasts().first,
            let location = Location() else { return }
        
        let forecast = Forecast(temperature: Int(cachedForecast.temperature),
                                date: cachedForecast.date!,
                                description: cachedForecast.weatherDescription!,
                                weatherType: WeatherType(rawValue: cachedForecast.weatherType!)!)
        
        weatherTodayView.showForecast(regionName: location.name,
                                      description: forecast.description,
                                      temperature: forecast.temperature,
                                      systemImageName: forecast.weatherType.systemImageName)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(.newData)
    }
    
}
