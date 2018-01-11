//
//  BoundingBoxTests.swift
//  KHCityDatabaseCreatorTests
//
//  Created by Kent Humphries on 10/1/18.
//  Copyright © 2018 KentHumphries. All rights reserved.
//

import XCTest
@testable import KHCityDatabaseCreator
import CoreLocation

class BoundingBoxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test width
    func testWidthIsHalfDegree() {
        XCTAssertEqual(BoundingBox.width, 0.5)
    }
    
    // MARK: - Test locationIdentifier(for:)
    // MARK: Test degrees
    func testLocationIdentifierForZeroLatZeroLong() {
        let location = CLLocationCoordinate2DMake(0.0, 0.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+000.00", id)
    }

    func testLocationIdentifierForMaxLatMaxLong() {
        let location = CLLocationCoordinate2DMake(90.0, 180.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+090.00_+180.00", id)
    }

    func testLocationIdentifierForMinLatMinLong() {
        let location = CLLocationCoordinate2DMake(-90.0, -180.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("-090.00_-180.00", id)
    }

    func testLocationIdentifierForPositiveLatNegativeLong() {
        let location = CLLocationCoordinate2DMake(74.0, -100.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+074.00_-100.00", id)
    }

    func testLocationIdentifierForNegativeLatPositiveLong() {
        let location = CLLocationCoordinate2DMake(-13.0, 158.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("-013.00_+158.00", id)
    }

    // MARK: Test Minutes
    
    func testLocationIdentifierForNegativeLatMinuteGreaterThanHalf() {
        let location = CLLocationCoordinate2DMake(-1.80, 0.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("-002.00_+000.00", id)
    }
    
    func testLocationIdentifierForNegativeLatMinuteLessThanHalf() {
        let location = CLLocationCoordinate2DMake(-1.20, 0.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("-001.50_+000.00", id)
    }

    func testLocationIdentifierForPositiveLatMinuteGreaterThanHalf() {
        let location = CLLocationCoordinate2DMake(89.99, 0.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+089.50_+000.00", id)
    }
    
    func testLocationIdentifierForPositiveLatMinuteLessThanHalf() {
        let location = CLLocationCoordinate2DMake(1.20, 0.0)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+001.00_+000.00", id)
    }

    
    func testLocationIdentifierForNegativeLongMinuteGreaterThanHalf() {
        let location = CLLocationCoordinate2DMake(0.0, -7.99)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_-008.00", id)
    }

    func testLocationIdentifierForNegativeLongMinuteLessThanHalf() {
        let location = CLLocationCoordinate2DMake(0.0, -7.01)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_-007.50", id)
    }

    func testLocationIdentifierForPositiveLongMinuteGreaterThanHalf() {
        let location = CLLocationCoordinate2DMake(0.0, 8.60)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+008.50", id)
    }
    
    func testLocationIdentifierForPositiveLongMinuteLessThanHalf() {
        let location = CLLocationCoordinate2DMake(0.0, 179.15)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+179.00", id)
    }
    
    func testLocationIdentifierForLongMinutesJustAboveZero() {
        let location = CLLocationCoordinate2DMake(0.0, 1.000001)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+001.00", id)
    }

    func testLocationIdentifierForLongMinutesJustBelowZero() {
        let location = CLLocationCoordinate2DMake(0.0, 1.999999)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+001.50", id)
    }
    
    func testLocationIdentifierForLongMinutesJustAboveHalf() {
        let location = CLLocationCoordinate2DMake(0.0, 1.500001)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+001.50", id)
    }

    func testLocationIdentifierForLongMinutesJustBelowHalf() {
        let location = CLLocationCoordinate2DMake(0.0, 1.499999)
        
        let id = BoundingBox.locationIdentifier(for: location)
        
        XCTAssertEqual("+000.00_+001.00", id)
    }

    // MARK: - Test location(forLocationIdentifier:)
    func tetLocationForEmptyString() {
        let location = BoundingBox.location(forLocationIdentifier: "")
        
        XCTAssertFalse(CLLocationCoordinate2DIsValid(location))
    }
    
    func testLocationForValidLatitudeInvalidLongitude() {
        let location = BoundingBox.location(forLocationIdentifier: "+000.00_-abc.de")
        
        XCTAssertFalse(CLLocationCoordinate2DIsValid(location))
    }

    func testLocationForInvalidLatitudeValidLongitude() {
        let location = BoundingBox.location(forLocationIdentifier: "-abc.de_+000.00")
        
        XCTAssertFalse(CLLocationCoordinate2DIsValid(location))
    }
    
    func testLocationForImpossibleLatitudeValidLongitude() {
        let location = BoundingBox.location(forLocationIdentifier: "-091.00_+000.00")
        
        XCTAssertFalse(CLLocationCoordinate2DIsValid(location))
    }

    func testLocationForValidLatitudeImpossibleLongitude() {
        let location = BoundingBox.location(forLocationIdentifier: "+000.00_+200.00")
        
        XCTAssertFalse(CLLocationCoordinate2DIsValid(location))
    }

    func testLocationForPositivePaddedLatitudeZeroLongitude() {
        let locationIdentifier = "+001.23_+000.00"
        
        let location = BoundingBox.location(forLocationIdentifier: locationIdentifier)
        
        XCTAssertEqual(location.latitude, 1.23)
        XCTAssertEqual(location.longitude, 0.0)
    }
    
    func testLocationForNegativePaddedLatitudeZeroLongitude() {
        let locationIdentifier = "-080.00_+000.00"
        
        let location = BoundingBox.location(forLocationIdentifier: locationIdentifier)
        
        XCTAssertEqual(location.latitude, -80.0)
        XCTAssertEqual(location.longitude, 0.0)
    }

    func testLocationForZeroLatitudeNegativePaddedLongitude() {
        let locationIdentifier = "+000.00_-009.34"
        
        let location = BoundingBox.location(forLocationIdentifier: locationIdentifier)
        
        XCTAssertEqual(location.latitude, 0.0)
        XCTAssertEqual(location.longitude, -9.34)
    }
    
    func testLocationForZeroLatitudePositiveUnpaddedLongitude() {
        let locationIdentifier = "+000.00_+175.43"
        
        let location = BoundingBox.location(forLocationIdentifier: locationIdentifier)
        
        XCTAssertEqual(location.latitude, 0.0)
        XCTAssertEqual(location.longitude, 175.43)
    }

    
    
}
