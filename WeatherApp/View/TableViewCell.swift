//
//	TableViewCell.swift
// 	WeatherApp
//

import UIKit

class TableViewCell: UITableViewCell {
    static let CellReuseID = "Cell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(date: String, systemImageName: String, temperature: Int) {
        dateLabel.text = date
        weatherIconImageView.image = UIImage(systemName: systemImageName)
        temperatureLabel.text = "\(temperature)ºC"
    }
}
