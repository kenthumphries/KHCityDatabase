//
//  Location.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 18/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation
import RealmSwift

public class City : Object {
    
    public dynamic var cityNameEnglish : String = ""
    public dynamic var timeZoneEnglish : String = ""
    public dynamic var countryCode : String = ""
    public dynamic var countryNameEnglish : String = ""
    public dynamic var admin1Code  : String = ""
    public dynamic var admin1NameEnglish : String = ""
    public dynamic var admin2Code : String = ""
    public dynamic var population : Int = 0
    
    public convenience init(cityNameEnglish: String,
        timeZoneEnglish: String,
        countryCode: String,
        countryNameEnglish: String,
        admin1Code: String,
        admin1NameEnglish: String,
        admin2Code: String,
        population: Int) {
            
            self.init()

            self.cityNameEnglish = cityNameEnglish
            self.timeZoneEnglish = timeZoneEnglish
            self.countryCode = countryCode
            self.countryNameEnglish = countryNameEnglish
            self.admin1Code = admin1Code
            self.admin1NameEnglish = admin1NameEnglish
            self.admin2Code = admin2Code
            self.population = population
    }
    
    override public var hash : Int {
        var hash = self.cityNameEnglish.hash
        hash ^= self.timeZoneEnglish.hash
        hash ^= self.countryCode.hash
        hash ^= self.countryNameEnglish.hash
        hash ^= self.admin1Code.hash
        hash ^= self.admin1NameEnglish.hash
        hash ^= self.admin2Code.hash
        hash ^= self.population.hashValue
        return hash
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let other = object as? City else {
            // Break quickly in case other Location is nil, or wrong type
            return false
        }

        return self.isEqualToLocation(other)
    }

    func isEqualToLocation(other : City?) -> Bool {
        
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
        return isEqual
    }
    
    override public var description: String {
        return "\(cityNameEnglish), \(admin1NameEnglish), \(countryCode) (\(population))"
    }
}