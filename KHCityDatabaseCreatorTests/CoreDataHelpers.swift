//
//  CoreDataHelpers.swift
//  KHCityDatabaseCreatorTests
//
//  Created by Kent Humphries on 12/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import CoreData
import KHCityDatabaseCreator
import XCTest

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
}

private extension Array {
  subscript(safely index: Index) -> Element? {
    if self.indices.contains(index) {
      return self[index]
    } else {
      return nil
    }
  }
}

func XCTAssertEqual(
    _ lhs: [City], // the cities under test
    cities rhs: [City], // the reference cities
    file: StaticString = #file, // the file the function is called from
    line: UInt = #line // the line the function is called from
) {
    for index in 0..<max(lhs.count, rhs.count) {
        let left = lhs[safely: index]
        let right = rhs[safely: index]
        
        XCTAssertEqual(left, city: right, "Element #\(index): ", file: file, line: line)
    }
    
}

private func XCTAssertEqual(
    _ lhs: City?, // the city under test
    city rhs: City?, // the reference city
    _ message: String? = nil,
    file: StaticString = #file, // the file the function is called from
    line: UInt = #line // the line the function is called from
) {
    let prefix = message ?? ""
    XCTAssertEqual(lhs?.cityNamePreferred, rhs?.cityNamePreferred,
                   "\(prefix)City.cityNamePreferred mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.cityNameASCII, rhs?.cityNameASCII,
                   "\(prefix)City.cityNameASCII mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.cityNameAlternates, rhs?.cityNameAlternates,
                   "\(prefix)City.cityNameAlternates mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.timeZone, rhs?.timeZone,
                   "\(prefix)City.timeZone mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.countryCode, rhs?.countryCode,
                   "\(prefix)City.countryCode mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.countryNamePreferred, rhs?.countryNamePreferred,
                   "\(prefix)City.countryNamePreferred mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.admin1Code, rhs?.admin1Code,
                   "\(prefix)City.admin1Code mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.admin1NamePreferred, rhs?.admin1NamePreferred,
                   "\(prefix)City.admin1NamePreferred mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.admin2Code, rhs?.admin2Code,
                   "\(prefix)City.admin2Code mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.population, rhs?.population,
                   "\(prefix)City.population mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.latitude, rhs?.latitude,
                   "\(prefix)City.latitude mismatch", file: file, line: line)
    XCTAssertEqual(lhs?.longitude, rhs?.longitude,
                   "\(prefix)City.longitude mismatch", file: file, line: line)
}


func createCity(context: NSManagedObjectContext,
                cityNamePreferred : String? = "Viénna",
                cityNameASCII : String? = "Vienna",
                cityNameAlternates : String? = "Wiendog, Warum",
                timeZone : String? = "Vienna/Europe",
                countryCode : String? = "AT",
                countryNamePreferred : String? = "Austria",
                admin1Code : String? = "09",
                admin1NamePreferred : String? = "Viennese",
                admin2Code : String? = "123",
                population : Int64? = 1500000,
                latitude : CLLocationDegrees? = 48.20,
                longitude : CLLocationDegrees? = 16.37) -> City {
    let entity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
    
    entity.cityNamePreferred = cityNamePreferred!
    entity.cityNameASCII = cityNameASCII!
    entity.cityNameAlternates = cityNameAlternates!
    entity.timeZone = timeZone!
    entity.countryCode = countryCode!
    entity.countryNamePreferred = countryNamePreferred!
    entity.admin1Code = admin1Code!
    entity.admin1NamePreferred = admin1NamePreferred!
    entity.admin2Code = admin2Code!
    entity.population = population!
    entity.latitude = latitude!
    entity.longitude = longitude!
    
    return entity
}

