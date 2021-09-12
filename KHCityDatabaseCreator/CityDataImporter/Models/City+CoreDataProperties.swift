//
//  City+CoreDataProperties.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 12/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \City.cityNamePreferred, ascending: true)]
        return request
    }

    @NSManaged public var admin1Code: String?
    @NSManaged public var admin1NamePreferred: String?
    @NSManaged public var admin2Code: String?
    @NSManaged public var cityNameAlternates: String?
    @NSManaged public var cityNameASCII: String
    @NSManaged public var cityNamePreferred: String
    @NSManaged public var countryCode: String
    @NSManaged public var countryNamePreferred: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var population: Int64
    @NSManaged public var timeZone: String
    @NSManaged public var uniqueDescription: String?

}
