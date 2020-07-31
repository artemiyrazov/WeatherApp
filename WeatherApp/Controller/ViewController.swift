//
//	ViewController.swift
// 	WeatherApp
//

import UIKit

class ViewController: UIViewController {
    
    private let networkService = NetworkService()
    private let coreDataService = CoreDataService.shared
    private var futureForecasts: [Forecast] = []
    private var todayForecast: Forecast?
    private var mainView: MainView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.setUpTableViewDelegate(self)
        mainView.setUpTableViewDataSource(self)
        getDailyForecast()
    }
    
    private func getDailyForecast() {
        let forecasts = coreDataService.fetchForecasts().map { cachedForecast -> Forecast in
            return Forecast(temperature: Int(cachedForecast.temperature),
                            date: cachedForecast.date!,
                            description: cachedForecast.weatherDescription!,
                            weatherType: WeatherType(rawValue: cachedForecast.weatherType!)!)
        }
        presentNewForecasts(forecasts)
        
        if InternetConnectionService.isConnectedToNetwork() {
            loadDailyForecastFromServer()
        }
    }
    
    private func loadDailyForecastFromServer() {
        
        networkService.dailyForecastRequest(latitude: FakeRegion.latitude, longitude: FakeRegion.longitude) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let forecasts):
                DispatchQueue.main.async {
                    self.presentNewForecasts(forecasts)
                    self.coreDataService.updateForecastsInStorage(withNew: forecasts)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func presentNewForecasts (_ forecasts: [Forecast]) {
        guard !forecasts.isEmpty else { return }
        todayForecast = forecasts[0]
        futureForecasts = Array(forecasts.dropFirst())
        refreshViews()
    }
    
    private func refreshViews() {
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

