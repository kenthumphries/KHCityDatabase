//
//  Location.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 18/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

open class City : Object {
    
    open dynamic var cityNameEnglish : String = ""
    open dynamic var timeZoneEnglish : String = ""
    open dynamic var countryCode : String = ""
    open dynamic var countryNameEnglish : String = ""
    open dynamic var admin1Code  : String?
    open dynamic var admin1NameEnglish : String?
    open dynamic var admin2Code : String?
    open dynamic var population : Int = 0
    open dynamic var latitude : CLLocationDegrees = 0.0
    open dynamic var longitude : CLLocationDegrees = 0.0
    
    open var position : CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    public convenience init(cityNameEnglish: String,
        timeZoneEnglish: String,
        countryCode: String,
        countryNameEnglish: String,
        admin1Code: String?,
        admin1NameEnglish: String?,
        admin2Code: String?,
        population: Int,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees) {
            
            self.init()

            self.cityNameEnglish = cityNameEnglish
            self.timeZoneEnglish = timeZoneEnglish
            self.countryCode = countryCode
            self.countryNameEnglish = countryNameEnglish
            self.admin1Code = admin1Code
            self.admin1NameEnglish = admin1NameEnglish
            self.admin2Code = admin2Code
            self.population = population
            self.latitude = latitude
            self.longitude = longitude
    }
    
    override open var hash : Int {
        var hash = self.cityNameEnglish.hash
        hash ^= self.timeZoneEnglish.hash
        hash ^= self.countryCode.hash
        hash ^= self.countryNameEnglish.hash
        hash ^= nonEmptyHash(self.admin1Code) // Optional - handle empty case
        hash ^= nonEmptyHash(self.admin1NameEnglish) // Optional - handle empty case
        hash ^= nonEmptyHash(self.admin2Code) // Optional - handle empty case
        hash ^= self.population.hashValue
        hash ^= self.latitude.hashValue
        hash ^= self.longitude.hashValue
        return hash
    }
    
    func nonEmptyHash(_ value : String?) -> Int {
        if let value = value {
            return value.hash
        } else {
            return 0
        }
    }
    
    override open func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? City else {
            // Break quickly in case other Location is nil, or wrong type
            return false
        }

        return self.isEqualToLocation(other)
    }

    func isEqualToLocation(_ other : City?) -> Bool {
        
        guard let other = other else {
            // Break quickly in case other Location is nil
            return false
        }
        
        guard self.hashValue == other.hashValue else {
            // Break quickly in case other hash does not match
            return false
        }
        
        var isEqual = self.cityNameEnglish == other.cityNameEnglish
        isEqual = isEqual && self.timeZoneEnglish == other.timeZoneEnglish
        isEqual = isEqual && self.countryCode == other.countryCode
        isEqual = isEqual && self.countryNameEnglish == other.countryNameEnglish
        isEqual = isEqual && self.admin1Code == other.admin1Code
        isEqual = isEqual && self.admin1NameEnglish == other.admin1NameEnglish
        isEqual = isEqual && self.admin2Code == other.admin2Code
        isEqual = isEqual && self.population == other.population
        isEqual = isEqual && self.latitude == other.latitude
        isEqual = isEqual && self.longitude == other.longitude
        return isEqual
    }
    
    override open var description: String {
        return "\(cityNameEnglish), \(String(describing: admin1NameEnglish)), \(countryCode) (\(population))"
    }
}
