//
//	ViewController.swift
// 	WeatherApp
//

import UIKit

class ViewController: UIViewController {
    
    let networkService = NetworkService()
    var forecasts: [Forecast] = []
    var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        loadDailyForecast()
    }
    
    func loadDailyForecast() {
        networkService.dailyForecastRequest(latitude: FakeRegion.latitude, longitude: FakeRegion.longitude) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let forecasts):
                self.forecasts = forecasts
                DispatchQueue.main.async {
                    self.refreshViews()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshViews() {
        let todayForecast = forecasts[0]
        mainView.configure(date: todayForecast.dateString,
                           region: FakeRegion.name,
                           temperature: Int(todayForecast.temperature),
                           description: todayForecast.weather.description,
                           systemImageName: todayForecast.weather.weatherType.systemImageName)
        mainView.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The first item is shown outside the table
        forecasts.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CellReuseID) as? TableViewCell else {
            return UITableViewCell()
        }
        let forecast = forecasts[indexPath.row + 1]
        cell.configure(date: forecast.dateString,
                       systemImageName: forecast.weather.weatherType.systemImageName,
                       temperature: Int(forecast.temperature))
        return cell
    }
}

