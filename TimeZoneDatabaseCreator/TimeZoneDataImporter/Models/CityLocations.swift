//
//  CityLocations.swift
//  TimeZoneDatabase
//
//  Created by Kent Humphries on 18/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation

extension CityLocations: TimeZoneQuery {
    public func locationsMatchingCityNameEnglish(cityNameEnglish : String) -> CityLocations {
        return self.filterByCity(cityNameEnglish)
    }
}

public class CityLocations: NSObject {

    public override init() {
        super.init()
    }
    
    // MARK: Subscripting
    subscript(city: String) -> [Location]? {
        get {
            return self.cityLocations[city]
        }
        set(newValue) {
            assert(cityLocationIsValidForCity(city, locations: newValue))
            self.cityLocations[city] = newValue
        }
    }
    
    // MARK: Variables
    private var cityLocations = [String : [Location]]()
    
    var cities : [String] {
        return Array(cityLocations.keys)
    }
    
    // MARK: Add Locations
    public func appendLocations(locations: [Location]) {
        for location in locations {
            self.appendLocation(location)
        }
    }
    
    public func appendLocation(location: Location) {
        if var locations = cityLocations[location.cityNameEnglish] {
            locations.append(location)
        }
        else {
            var locations = [Location]()
            locations.append(location)
            self.cityLocations[location.cityNameEnglish] = locations
        }
    }
    
    // MARK: Retrieve Locations
    func filterByCity(city: String) -> CityLocations {
        let matchingCityNames = Array(self.cityLocations.keys).filter { (string : String) -> Bool in
            return string.rangeOfString(city, options: .CaseInsensitiveSearch) != nil
        }
        
        let matchingCityLocations = CityLocations()
        for cityName in matchingCityNames {
            if let locations = self.cityLocations[cityName] {
                matchingCityLocations[cityName] = locations
            }
        }
        return matchingCityLocations
    }
    
    // MARK: Utilties
    private func cityLocationIsValidForCity(city : String, locations : [Location]?) -> Bool {
        if let locations = locations {
            for location in locations {
                if !location.cityNameEnglish.isEqual(city) {
                    return false
                }
            }
        }
        return true
    }
    
}
