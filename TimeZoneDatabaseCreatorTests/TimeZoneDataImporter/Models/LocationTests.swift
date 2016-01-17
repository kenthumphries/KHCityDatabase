//
//  LocationTests.swift
//  TimeZoneDatabase
//
//  Created by Kent Humphries on 20/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import XCTest
@testable import TimeZoneDatabaseCreator
import RealmSwift

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    // MARK: var hash : Int
    
    func testHash_same() {
        let location = self.location()
        let other = self.location()
        
        XCTAssertEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_cityNameEnglish() {
        let location = self.location()
        let other = self.location(cityNameEnglish: "Wien")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_timeZoneEnglish() {
        let location = self.location()
        let other = self.location(timeZoneEnglish: "Wien/Europa")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_countryCode() {
        let location = self.location()
        let other = self.location(countryCode: "AU")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_countryName() {
        let location = self.location()
        let other = self.location(countryNameEnglish: "Osterreich")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_admin1Code() {
        let location = self.location()
        let other = self.location(admin1Code: "666")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }
    
    func testHash_differs_admin1Name() {
        let location = self.location()
        let other = self.location(admin1NameEnglish: "Viennetta")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }

    func testHash_differs_admin2Code() {
        let location = self.location()
        let other = self.location(admin2Code: "777")
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }

    func testHash_differs_population() {
        let location = self.location()
        let other = self.location(population: 777)
        
        XCTAssertNotEqual(location.hashValue, other.hashValue)
    }

    // MARK: func isEqualToLocation(other : Location?) -> Bool
    
    func testIsEqualToLocation_same() {
        let location = self.location()
        let other = self.location()
        
        XCTAssertEqual(location, other)
    }

    func testIsEqual_differs_cityNameEnglish() {
        let location = self.location()
        let other = self.location(cityNameEnglish: "Wien")
        
        XCTAssertNotEqual(location, other)
    }

    func testIsEqual_differs_timeZoneEnglish() {
        let location = self.location()
        let other = self.location(timeZoneEnglish: "Wien/Europa")
        
        XCTAssertNotEqual(location, other)
    }

    func testIsEqual_differs_countryCode() {
        let location = self.location()
        let other = self.location(countryCode: "AU")
        
        XCTAssertNotEqual(location, other)
    }
    
    func testIsEqual_differs_countryName() {
        let location = self.location()
        let other = self.location(countryNameEnglish: "Osterreich")
        
        XCTAssertNotEqual(location, other)
    }

    func testIsEqual_differs_admin1Code() {
        let location = self.location()
        let other = self.location(admin1Code: "666")
        
        XCTAssertNotEqual(location, other)
    }

    func testIsEqual_differs_admin1Name() {
        let location = self.location()
        let other = self.location(admin1NameEnglish: "Viennetta")
        
        XCTAssertNotEqual(location, other)
    }

    func testIsEqual_differs_admin2Code() {
        let location = self.location()
        let other = self.location(admin2Code: "777")
        
        XCTAssertNotEqual(location, other)
    }
    
    func testIsEqual_differs_population() {
        let location = self.location()
        let other = self.location(population: 777)
        
        XCTAssertNotEqual(location, other)
    }
    
    // MARK: - Utility methods
    
    func location(cityNameEnglish cityNameEnglish : String? = "Vienna",
        timeZoneEnglish : String? = "Vienna/Europe",
        countryCode : String? = "AT",
        countryNameEnglish : String? = "Austria",
        admin1Code : String? = "09",
        admin1NameEnglish : String? = "Viennese",
        admin2Code : String? = "123",
        population : Int? = 1500000) -> Location {
        return Location(cityNameEnglish: cityNameEnglish!,
            timeZoneEnglish: timeZoneEnglish!,
            countryCode: countryCode!,
            countryNameEnglish: countryNameEnglish!,
            admin1Code: admin1Code!,
            admin1NameEnglish: admin1NameEnglish!,
            admin2Code: admin2Code!,
            population: population!)
    }
}
