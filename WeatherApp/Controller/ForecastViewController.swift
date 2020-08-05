//
//	ViewController.swift
// 	WeatherApp
//

import UIKit
import CoreLocation

protocol MapPresenterDelegate: class {
    func forecastSelected(_ newForecast: Forecast)
    func locationUpdated(_ newLocation: Location)
}

class ForecastViewController: UIViewController {
    
    private let mapViewControllerID = "MapVC"
    private let locationService = LocationService()
    private let networkService = NetworkService()
    private var forecasts: [Forecast] = []
    private var mainView: MainView!
    private var currentLocation: Location! {
        didSet {
            mainView.showRegion(with: currentLocation.name)
            mapPresenterDelegate?.locationUpdated(currentLocation)
            loadForecastFromServer()
        }
    }
    var mapPresenterDelegate: MapPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = view as? MainView
        mainView.setUpTableViewDelegate(self)
        mainView.setUpTableViewDataSource(self)
        locationService.locationManagerDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    private func refreshViews() {
        let todayForecast = forecasts[0]
        mainView.showForecast (date: todayForecast.dateString,
                             temperature: Int(todayForecast.temperature),
                             description: todayForecast.weather.description,
                             systemImageName: todayForecast.weather.weatherType.systemImageName)
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard currentLocation != nil else { return }
        mapPresenterDelegate?.forecastSelected(forecasts[indexPath.row + 1])
        if let detailVC = mapPresenterDelegate as? MapViewController {
            splitViewController?.showDetailViewController(detailVC, sender: nil)
        }
    }
}

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
