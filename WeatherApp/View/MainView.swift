//
//	View.swift
// 	WeatherApp
//

import UIKit

class MainView: UIView {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    var tableViewDelegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = tableViewDelegate
        }
    }
    
    var tableViewDataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
        }
    }
    
    func showForecast (date: String, temperature: Int, description: String, systemImageName: String) {
        dateLabel.text = "today".localized() + ", " + date
        temperatureLabel.text = "\(temperature)ºC"
        weatherDescriptionLabel.text = description
        weatherIconImageView.image = UIImage(systemName: systemImageName)
        
        tableView.reloadData()
    }
    
    func showRegion(with regionName: String) {
        regionLabel.text = regionName
    }
}
