//
//	ViewController.swift
// 	WeatherApp
//

import UIKit
<<<<<<< HEAD

class ViewController: UIViewController {
    
    private let networkService = NetworkService()
    private let coreDataService = CoreDataService.shared
    private var futureForecasts: [Forecast] = []
    private var todayForecast: Forecast?
    private var mainView: MainView!
=======
import CoreLocation

class ForecastViewController: UIViewController {
    
    private let locationService = LocationService()
    private let networkService = NetworkService()
    private var forecasts: [Forecast] = []
    private var mainView: MainView!
    private var currentLocation: Location! {
        didSet {
            mainView.showRegion(with: currentLocation.name)
            loadForecastFromServer()
        }
    }
>>>>>>> develop
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.setUpTableViewDelegate(self)
        mainView.setUpTableViewDataSource(self)
<<<<<<< HEAD
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
=======
        locationService.locationManagerDelegate = self
    }
    
    private func getLocalDailyForecast() {
        do {
            try locationService.locationAvailability()
        } catch let error as LocationRequestError {
            showAlert(title: "location availability error".localized(), message: error.localizedDescription, actionTitle: "OK")
            currentLocation = Location.fakeLocation
        } catch {
            showAlert(title: "error".localized(), message: "some undefined error".localized(), actionTitle: "OK")
            currentLocation = Location.fakeLocation
        }
    }
    
    private func loadForecastFromServer() {
        networkService.dailyForecastRequest(latitude: currentLocation.latitude,
                                            longitude: currentLocation.longitude) { [weak self] response in
>>>>>>> develop
            guard let self = self else { return }
            
            switch response {
            case .success(let forecasts):
<<<<<<< HEAD
                DispatchQueue.main.async {
                    self.presentNewForecasts(forecasts)
                    self.coreDataService.updateForecastsInStorage(withNew: forecasts)
=======
                self.forecasts = forecasts
                DispatchQueue.main.async {
                    self.refreshViews()
>>>>>>> develop
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
<<<<<<< HEAD
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
=======
    private func refreshViews() {
        let todayForecast = forecasts[0]
        mainView.showForecast (date: todayForecast.dateString,
                             temperature: Int(todayForecast.temperature),
                             description: todayForecast.weather.description,
                             systemImageName: todayForecast.weather.weatherType.systemImageName)
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
>>>>>>> develop
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
<<<<<<< HEAD
        futureForecasts.count
=======
        // The first item is shown outside the table
        forecasts.count - 1
>>>>>>> develop
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.CellReuseID) as? TableViewCell else {
            return UITableViewCell()
        }
<<<<<<< HEAD
        let forecast = futureForecasts[indexPath.row]
        cell.configure(date: forecast.dateString,
                       systemImageName: forecast.weatherType.systemImageName,
                       temperature: forecast.temperature)
=======
        let forecast = forecasts[indexPath.row + 1]
        cell.configure(date: forecast.dateString,
                       systemImageName: forecast.weather.weatherType.systemImageName,
                       temperature: Int(forecast.temperature))
>>>>>>> develop
        return cell
    }
}

<<<<<<< HEAD
=======
extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocalDailyForecast()
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
        print(error.localizedDescription)
    }
}
>>>>>>> develop
