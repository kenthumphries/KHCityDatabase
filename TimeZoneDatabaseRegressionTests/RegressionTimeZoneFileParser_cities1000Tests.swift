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


class RegressionTimeZoneFileParser_cities1000Tests: XCTestCase {

    var testBundle : NSBundle?
    
    override func setUp() {
        super.setUp()
        
        testBundle = NSBundle(forClass: self.dynamicType)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Initialiser tests

    func testInit_valid_cities1000() {
        self.measureBlock() {
            let parser = try? self.timeZoneFileParser()
            XCTAssertTrue(parser?.citiesFileContents?.characters.count > 0, "default citiesFile should be read with non-empty value")
            XCTAssertTrue(parser?.admin1FileContents?.characters.count > 0, "default admin1File should be read with non-empty value")
        }
    }

    func testParseLocations_valid_cities1000() {
        let parser = try? self.timeZoneFileParser()
        self.measureBlock { () -> Void in
            let locations = parser?.parseLocations()
            XCTAssertEqual(locations?.count, 81608, "72081 cities should be parsed from cities1000 file")
        }
    }

    // MARK: - Utilities
    
    func timeZoneFileParser() throws -> TimeZoneFileParser {
            
            let parser = try TimeZoneFileParser(citiesFileName: "cities1000", admin1FileName: "admin1CodesASCII", inBundle: testBundle!)
            return parser
    }
}
