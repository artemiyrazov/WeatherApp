//
//	UIViewControllerExtension.swift
// 	WeatherApp
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
