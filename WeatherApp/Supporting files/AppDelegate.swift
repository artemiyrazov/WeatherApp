//
//	AppDelegate.swift
// 	WeatherApp
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let appRefreshTaskId = "com.artemiy.updateForecastInStorage"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: appRefreshTaskId, using: nil) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        return true
    }
    
    // MARK: - Setup background task
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        guard let lastLocation = Location() else { return }
        
        NetworkService().dailyForecastRequest(latitude: lastLocation.latitude,
                                              longitude: lastLocation.longitude) { response in
            switch response {
            case .success(let forecasts):
                CoreDataService.shared.updateForecastsInStorage(withNew: forecasts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleBackgroundForecastFetch() {
        let task = BGAppRefreshTaskRequest(identifier: appRefreshTaskId)
        task.earliestBeginDate = nil
        do {
            try BGTaskScheduler.shared.submit(task)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
