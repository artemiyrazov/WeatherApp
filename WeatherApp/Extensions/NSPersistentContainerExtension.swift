//
//	NSPersistentContainerExtension.swift
// 	WeatherApp
//

import Foundation
import CoreData

class GroupedPersistentContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.sharingForWeatherApp")!
    }
}
