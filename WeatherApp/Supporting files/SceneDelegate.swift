//
//	SceneDelegate.swift
// 	WeatherApp
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundForecastFetch()
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard
            let splitViewController = window?.rootViewController as? SplitViewController,
            let navigationController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = navigationController.viewControllers.first as? ForecastViewController,
            let detailViewController = splitViewController.viewControllers.last as? MapViewController
            else { fatalError() }
        
        masterViewController.mapPresenterDelegate = detailViewController
    }
}
