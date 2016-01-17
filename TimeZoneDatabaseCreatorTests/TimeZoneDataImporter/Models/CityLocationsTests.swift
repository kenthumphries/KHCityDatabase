//
//  CityLocationsTests.swift
//  TimeZoneDatabase
//
//  Created by Kent Humphries on 20/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import XCTest
@testable import TimeZoneDatabaseCreator

class CityLocationsTests: XCTestCase {
    
    func testAppendLocation() {
        let cityLocations = CityLocations()
        cityLocations.appendLocation(self.locationVienna)
        
        if let locations = cityLocations["Vienna"] {
            XCTAssertEqual(locations, [self.locationVienna])
        } else {
            XCTFail("Could not find locations for locationVienna")
        }
    }

    func testFilterByCity_start() {
        
        self.expectLocations(
            self.cityLocations(self.locationVienna),
            filteredByCity: "Vi",
            willFindCities: { (cities) in
                XCTAssertEqual(cities, ["Vienna"])
            })
    }
    
    func testFilterByCity_middle() {
        
        self.expectLocations(
            self.cityLocations(self.locationVienna),
            filteredByCity: "ien",
            willFindCities: { (cities) in
                XCTAssertEqual(cities, ["Vienna"])
        })
    }
    
    func testFilterByCity_end() {
        
        self.expectLocations(
            self.cityLocations(self.locationVienna),
            filteredByCity: "nna",
            willFindCities: { (cities) in
                XCTAssertEqual(cities, ["Vienna"])
        })
    }
    
    func testFilterByCity_caseInsensitive() {
        
        self.expectLocations(
            self.cityLocations(self.locationVienna),
            filteredByCity: "vIenN",
            willFindCities: { (cities) in
                XCTAssertEqual(cities, ["Vienna"])
        })
    }
    
    func testFilterByCity_spaces_cityWithNoSpaces() {
        
        self.expectLocations(
            self.cityLocations(self.locationVienna),
            filteredByCity: "vIenN",
            willFindCities: { (cities) in
                XCTAssertEqual(cities, ["Vienna"])
        })
    }
    
    func testPerformanceFilterByCity() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: Utility Methods
    
    func expectLocations(cityLocations : CityLocations,
        filteredByCity cityFilter: String,
        willFindCities : (cities : [String]) -> ()) {
            
            let matchingLocations = cityLocations.filterByCity(cityFilter)
            
            willFindCities(cities: matchingLocations.cities)
    }
    
    func cityLocations(location: Location) -> CityLocations {
        let cityLocations = CityLocations()
        cityLocations.appendLocation(location)
        return cityLocations
    }
    
    var locationVienna : Location {
        return Location(cityNameEnglish: "Vienna", timeZoneEnglish: "Vienna/Europe", countryCode: "AT", countryNameEnglish: "Austria", admin1Code: "09", admin1NameEnglish: "Viennese", admin2Code: "900", population: 1500000)
    }
}
