//
//	CoreDataService.swift
// 	WeatherApp
//

import Foundation
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: GroupedPersistentContainer = {
        let container = GroupedPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func removeAllForecasts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CachedForecast.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try mainContext.execute(batchDeleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveForecastToDevice(forecast: Forecast) {
        
        let cachedForecastObject = CachedForecast(context: mainContext)
        
        cachedForecastObject.temperature = Int16(forecast.temperature)
        cachedForecastObject.date = forecast.date
        cachedForecastObject.weatherType = forecast.weatherType.rawValue
        cachedForecastObject.weatherDescription = forecast.description
        
        saveContext()
    }
    
    func updateForecastsInStorage(withNew forecasts: [Forecast]) {
        removeAllForecasts()
        forecasts.forEach { saveForecastToDevice(forecast: $0) }
    }
    
    func fetchForecasts () -> [CachedForecast] {
        let fetchRequest: NSFetchRequest<CachedForecast> = CachedForecast.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: #keyPath(CachedForecast.date), ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        
        var cachedForecasts: [CachedForecast] = []
        do {
            cachedForecasts = try mainContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return cachedForecasts
    }

}
