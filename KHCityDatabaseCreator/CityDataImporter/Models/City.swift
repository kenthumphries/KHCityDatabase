//
//  City.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 18/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

open class City : Object {
    
    @objc open dynamic var cityNamePreferred : String = ""
    @objc open dynamic var timeZone : String = ""
    @objc open dynamic var countryCode : String = ""
    @objc open dynamic var countryNamePreferred : String = ""
    @objc open dynamic var admin1Code  : String?
    @objc open dynamic var admin1NamePreferred : String?
    @objc open dynamic var admin2Code : String?
    @objc open dynamic var population : Int = 0
    @objc open dynamic var latitude : CLLocationDegrees = 0.0
    @objc open dynamic var longitude : CLLocationDegrees = 0.0
    
    open var position : CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    public convenience init(cityNamePreferred: String,
                            timeZone: String,
                            countryCode: String,
                            countryNamePreferred: String,
                            admin1Code: String?,
                            admin1NamePreferred: String?,
                            admin2Code: String?,
                            population: Int,
                            latitude: CLLocationDegrees,
                            longitude: CLLocationDegrees) {
        
        self.init()
        
        self.cityNamePreferred = cityNamePreferred
        self.timeZone = timeZone
        self.countryCode = countryCode
        self.countryNamePreferred = countryNamePreferred
        self.admin1Code = admin1Code
        self.admin1NamePreferred = admin1NamePreferred
        self.admin2Code = admin2Code
        self.population = population
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override open var hash : Int {
        var hash = self.cityNamePreferred.hash
        hash ^= self.timeZone.hash
        hash ^= self.countryCode.hash
        hash ^= self.countryNamePreferred.hash
        hash ^= nonEmptyHash(self.admin1Code) // Optional - handle empty case
        hash ^= nonEmptyHash(self.admin1NamePreferred) // Optional - handle empty case
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
        
        var isEqual = self.cityNamePreferred == other.cityNamePreferred
        isEqual = isEqual && self.timeZone == other.timeZone
        isEqual = isEqual && self.countryCode == other.countryCode
        isEqual = isEqual && self.countryNamePreferred == other.countryNamePreferred
        isEqual = isEqual && self.admin1Code == other.admin1Code
        isEqual = isEqual && self.admin1NamePreferred == other.admin1NamePreferred
        isEqual = isEqual && self.admin2Code == other.admin2Code
        isEqual = isEqual && self.population == other.population
        isEqual = isEqual && self.latitude == other.latitude
        isEqual = isEqual && self.longitude == other.longitude
        return isEqual
    }
    
    override open var description: String {
        return "\(cityNamePreferred), \(String(describing: admin1NamePreferred)), \(countryCode) (\(population))"
    }
}
