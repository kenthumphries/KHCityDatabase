//
//  BoundingBoxInteractorTests.swift
//  KHCityDatabaseCreatorTests
//
//  Created by Kent Humphries on 10/1/18.
//  Copyright © 2018 KentHumphries. All rights reserved.
//

import XCTest
@testable import KHCityDatabaseCreator
import CoreLocation

class BoundingBoxInteractorTests: XCTestCase {
    
    let interactor = BoundingBoxInteractor()
    var city = City()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test locationIdentifier(for:)
    // MARK: Test degrees
    func testLocationIdentifierForZeroLatZeroLong() {
        city.latitude = 0.0
        city.longitude = 0.0
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+000.00", id)
    }

    func testLocationIdentifierForMaxLatMaxLong() {
        city.latitude = 90
        city.longitude = 180
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+090.00_+180.00", id)
    }

    func testLocationIdentifierForMinLatMinLong() {
        city.latitude = -90
        city.longitude = -180
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("-090.00_-180.00", id)
    }

    func testLocationIdentifierForPositiveLatNegativeLong() {
        city.latitude = 74
        city.longitude = -100
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+074.00_-100.00", id)
    }

    func testLocationIdentifierForNegativeLatPositiveLong() {
        city.latitude = -13
        city.longitude = 158
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("-013.00_+158.00", id)
    }

    // MARK: Test Minutes
    
    func testLocationIdentifierForNegativeLatMinuteGreaterThanHalf() {
        city.latitude = -1.80
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("-001.50_+000.00", id)
    }
    
    func testLocationIdentifierForNegativeLatMinuteLessThanHalf() {
        city.latitude = -1.20
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("-001.00_+000.00", id)
    }

    func testLocationIdentifierForPositiveLatMinuteGreaterThanHalf() {
        city.latitude = 89.99
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+089.50_+000.00", id)
    }
    
    func testLocationIdentifierForPositiveLatMinuteLessThanHalf() {
        city.latitude = 1.20
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+001.00_+000.00", id)
    }

    
    func testLocationIdentifierForNegativeLongMinuteGreaterThanHalf() {
        city.longitude = -7.99
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_-007.50", id)
    }

    func testLocationIdentifierForNegativeLongMinuteLessThanHalf() {
        city.longitude = -7.01
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_-007.00", id)
    }

    func testLocationIdentifierForPositiveLongMinuteGreaterThanHalf() {
        city.longitude = 8.60
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+008.50", id)
    }
    
    func testLocationIdentifierForPositiveLongMinuteLessThanHalf() {
        city.longitude = 179.15
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+179.00", id)
    }
    
    func testLocationIdentifierForLongMinutesJustAboveZero() {
        city.longitude = 1.000001
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+001.00", id)
    }

    func testLocationIdentifierForLongMinutesJustBelowZero() {
        city.longitude = 1.999999
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+001.50", id)
    }
    
    func testLocationIdentifierForLongMinutesJustAboveHalf() {
        city.longitude = 1.500001
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+001.50", id)
    }


    func testLocationIdentifierForLongMinutesJustBelowHalf() {
        city.longitude = 1.499999
        
        let id = interactor.locationIdentifier(for: city)
        
        XCTAssertEqual("+000.00_+001.00", id)
    }

}
