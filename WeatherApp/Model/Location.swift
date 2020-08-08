//
//    Region.swift
//     WeatherApp
//

import Foundation

struct Location: Codable {
    
    static let fakeLocation = Location(name: "Cupertino".localized(), latitude: 37.322621, longitude: -122.031945)

    let name: String
    let latitude: Double
    let longitude: Double
    
    private let keychainKey = "lastUserLocation"

    /// Default initialization
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Failable initialization from Keychain storage
    init?() {
        guard let data = KeychainService.load(key: keychainKey) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(Location.self, from: data)
            self.name = result.name
            self.latitude = result.latitude
            self.longitude = result.longitude
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    func saveToKeychain() -> Bool {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            KeychainService.save(key: keychainKey, value: data)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
