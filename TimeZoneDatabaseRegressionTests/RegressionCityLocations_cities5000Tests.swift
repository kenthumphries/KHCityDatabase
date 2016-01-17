//
//  OurTimeRegressionTests.swift
//  OurTimeRegressionTests
//
//  Created by Kent Humphries on 8/01/2016.
//  Copyright © 2016 HumpBot. All rights reserved.
//

import XCTest
@testable import TimeZoneDatabase
import RealmSwift

class RegressionCityLocations_cities5000Tests: XCTestCase {
    
    var testBundle : NSBundle?
    
    override func setUp() {
        super.setUp()
        
        testBundle = NSBundle(forClass: self.dynamicType)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - appendLocation tests

    func testAppendLocations_cities5000() {
        let parser = try? self.timeZoneFileParser()
        let locations = parser?.parseLocations()
        self.measureBlock { () -> Void in
            let cityLocations = CityLocations()
            cityLocations.appendLocations(locations!)
            XCTAssertEqual(cityLocations.cities.count, 28446, "28446 cities should be appended from cities5000 file")
        }
    }

    // MARK: - filterByCity tests
    func testFilterByCity_singleLetter_s_cities5000() {
        let parser = try? self.timeZoneFileParser()
        let locations = parser?.parseLocations()
        self.measureBlock { () -> Void in
            let cityLocations = CityLocations()
            cityLocations.appendLocations(locations!)
            let filteredCities = cityLocations.filterByCity("s")
            XCTAssertEqual(filteredCities.cities.count, 11172)
        }
    }

    func testFilterByCity_twoLetters_st_cities5000() {
        let parser = try? self.timeZoneFileParser()
        let locations = parser?.parseLocations()
        self.measureBlock { () -> Void in
            let cityLocations = CityLocations()
            cityLocations.appendLocations(locations!)
            let filteredCities = cityLocations.filterByCity("st")
            XCTAssertEqual(filteredCities.cities.count, 1950)
        }
    }

    // MARK: - Utilities
    
    func timeZoneFileParser() throws -> TimeZoneFileParser {
            
            let parser = try TimeZoneFileParser(citiesFileName: "cities5000", admin1FileName: "admin1CodesASCII", inBundle: testBundle!)
            return parser
    }
}
