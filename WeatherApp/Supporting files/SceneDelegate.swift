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
        
        // Bug fix for iOS 14 beta (Storybards don't support classic UISplitViewController style for now)
        if #available(iOS 14.0, *) {
            if let oldSVC = self.window?.rootViewController as? UISplitViewController {
                let newSVC = SplitViewController() // style will be undefined (classic)
                newSVC.viewControllers = oldSVC.viewControllers
                self.window?.rootViewController = newSVC
            }
        }
        
        
        guard
            let splitViewController = window?.rootViewController as? SplitViewController,
            let navigationController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = navigationController.viewControllers.first as? ForecastViewController,
            let detailNavigationViewController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = detailNavigationViewController.viewControllers.first as? MapViewController
        else { fatalError() }
        
        masterViewController.mapPresenterDelegate = detailViewController
    }
}
