//
//	ViewController.swift
// 	WeatherApp
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    private let networkService = NetworkService()
    private let locationService = LocationService()
    private let coreDataService = CoreDataService.shared
    private var futureForecasts: [Forecast] = []
    private var todayForecast: Forecast?
    private var mainView: MainView!
    
    private var currentLocation: Location! {
        didSet {
            mainView.showRegion(with: currentLocation.name)
            loadDailyForecastFromServer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.tableViewDelegate = self
        mainView.tableViewDataSource = self
        locationService.locationManagerDelegate = self
        loadDailyForecastFromStorage()
    }
    
    private func loadDailyForecastFromStorage() {
        let forecastsFromDevice = coreDataService.fetchForecasts().map { cachedForecast -> Forecast in
            return Forecast(temperature: Int(cachedForecast.temperature),
                            date: cachedForecast.date!,
                            description: cachedForecast.weatherDescription!,
                            weatherType: WeatherType(rawValue: cachedForecast.weatherType!)!)
        }
        updateForecasts(forecastsFromDevice)
    }
    
    private func updateForecasts(_ forecasts: [Forecast]) {
        guard !forecasts.isEmpty else { return }
        todayForecast = forecasts[0]
        futureForecasts = Array(forecasts.dropFirst())
        refreshViews()
    }
    
    private func loadDailyForecastFromServer() {
        guard InternetConnectionService.isConnectedToNetwork() else {
            showAlert(title: "Internet connection error".localized(),
                      message: "Check your internet connection and try again".localized(),
                      actionTitle: "OK")
            return
        }
        
        networkService.dailyForecastRequest(latitude: currentLocation.latitude,
                                            longitude: currentLocation.longitude) { [weak self] response in
            guard let self = self else { return }
            switch response {
                
            case .success(let forecasts):
                DispatchQueue.main.async {
                    self.updateForecasts(forecasts)
                    self.coreDataService.updateForecastsInStorage(withNew: forecasts)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Invalid server response".localized(),
                                   message: error.localizedDescription,
                                   actionTitle: "OK")
                }
            }
        }
    }
    
    private func refreshViews() {
        guard let todayForecast = todayForecast else { return }
        mainView.showForecast(date: todayForecast.dateString,
                              temperature: todayForecast.temperature,
                              description: todayForecast.description,
                              systemImageName: todayForecast.weatherType.systemImageName)
    }
}



extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
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

extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        do {
            try locationService.locationAvailability()
        } catch let error as LocationRequestError {
            showAlert(title: "location availability error".localized(),
                      message: error.localizedDescription,
                      actionTitle: "OK")
            currentLocation = Location.fakeLocation
        } catch {
            showAlert(title: "error".localized(),
                      message: "some undefined error".localized(),
                      actionTitle: "OK")
            currentLocation = Location.fakeLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        locationService.geocodeLocation(from: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let location):
                self.currentLocation = location
            case .failure(let error):
                self.showAlert(title: "location availability error".localized(), message: error.localizedDescription, actionTitle: "OK")
                self.currentLocation = Location.fakeLocation
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "location availability error".localized(), message: "some undefined error".localized(), actionTitle: "OK")
    }
}
