//
//	WeatherTodayView.swift
// 	Weather Widget
//

import UIKit

class WeatherTodayView: UIView {
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func showForecast(regionName: String, description: String, temperature: Int, systemImageName: String) {
        self.regionLabel.text = regionName
        self.descriptionLabel.text = description
        self.temperatureLabel.text = "\(temperature)ºC"
        self.weatherImageView.image = UIImage(systemName: systemImageName)
    }
    
}
