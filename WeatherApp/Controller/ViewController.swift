//
//	ViewController.swift
// 	WeatherApp
//

import UIKit

class ViewController: UIViewController {
    
    let networkService = NetworkService()
    var futureForecasts: [Forecast] = []
    var todayForecast: Forecast?
    var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.setUpTableViewDelegate(self)
        mainView.setUpTableViewDataSource(self)
        loadDailyForecast()
    }
    
    func loadDailyForecast() {
        networkService.dailyForecastRequest(latitude: FakeRegion.latitude, longitude: FakeRegion.longitude) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let forecasts):
                guard !forecasts.isEmpty else { return }
                self.todayForecast = forecasts[0]
                self.futureForecasts = Array(forecasts.dropFirst())
                DispatchQueue.main.async {
                    self.refreshViews()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshViews() {
        guard let todayForecast = todayForecast else { return }
        mainView.updateView (date: todayForecast.dateString,
                           region: FakeRegion.name,
                           temperature: todayForecast.temperature,
                           description: todayForecast.description,
                           systemImageName: todayForecast.weatherType.systemImageName)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        futureForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CellReuseID) as? TableViewCell else {
            return UITableViewCell()
        }
        let forecast = futureForecasts[indexPath.row]
        cell.configure(date: forecast.dateString,
                       systemImageName: forecast.weatherType.systemImageName,
                       temperature: forecast.temperature)
        return cell
    }
}

