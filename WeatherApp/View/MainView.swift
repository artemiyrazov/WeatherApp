//
//	View.swift
// 	WeatherApp
//

import UIKit

class MainView: UIView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    func configure (date: String, region: String, temperature: Int, description: String, systemImageName: String) {
        dateLabel.text = "today \(date)"
        regionLabel.text = region
        temperatureLabel.text = "\(temperature)ºC"
        weatherDescriptionLabel.text = description
        weatherIconImageView.image = UIImage(systemName: systemImageName)
    }
}
