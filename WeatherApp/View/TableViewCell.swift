//
//	TableViewCell.swift
// 	WeatherApp
//

import UIKit

class TableViewCell: UITableViewCell {
    static let CellReuseID = "Cell"
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    func configure(date: String, systemImageName: String, temperature: Int) {
        dateLabel.text = date
        weatherIconImageView.image = UIImage(systemName: systemImageName)
        temperatureLabel.text = "\(temperature)ºC"
    }
}
