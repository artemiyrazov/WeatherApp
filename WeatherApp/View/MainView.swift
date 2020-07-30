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
    
    func updateView (date: String, region: String, temperature: Int, description: String, systemImageName: String) {
        
        dateLabel.text = "today \(date)"
        regionLabel.text = region
        temperatureLabel.text = "\(temperature)ºC"
        weatherDescriptionLabel.text = description
        weatherIconImageView.image = UIImage(systemName: systemImageName)
        
        tableView.reloadData()
    }
    
    func setUpTableViewDataSource (_ controller: UITableViewDataSource) {
        tableView.dataSource = controller
    }
    
    func setUpTableViewDelegate (_ controller: UITableViewDelegate) {
        tableView.delegate = controller
    }
}
