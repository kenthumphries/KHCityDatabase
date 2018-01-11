//
//  BoundingBox.swift
//  KHCityDatabaseCreator
//
//  Created by Kent Humphries on 10/1/18.
//  Copyright © 2018 KentHumphries. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

open class BoundingBox: Object {
    
    @objc open dynamic var locationIdentifier : String = ""
    open let contained = List<City>()
    
    public convenience init(locationIdentifier: String) {
        self.init()
        self.locationIdentifier = locationIdentifier
    }
    
    /// Returns a 13 character locationIdentifier for the coordinate given.
    ///
    /// The locationIdentifier first rounds the coordinate down to southWest corner of nearest BoundingBox.
    ///
    /// For example, when BoundingBox.width = 0.5:
    /// - (+0.25, +0.75) rounds back to (+0.00, +0.50)
    /// - (+3.00, +4.99) rounds back to (+3.00, +4.50)
    /// - (-3.23, -0.25) rounds back to (-3.50, -0.50)
    ///
    /// A string is then constructed from this rounded coordinate
    ///
    /// - Parameters:
    ///   - location: coordinate to be rounded and encoded
    /// - Returns: Identifier is of format "SAAA.BB_TCCC.DD" where:
    ///    - S   = positive (+90 = north) or negative (-90 = south) latitude (
    ///    - AAA = latitude degrees (padded to 3 digits)
    ///    - BB  = latitude minutes (padded to 2 digits, rounded to nearest BoundingBox.width)
    ///    - T   = positive (+180 = east) or negative (-180 = west) longitude
    ///    - CCC = longitude degrees (padded to 3 digits)
    ///    - DD  = longitude minutes (padded to 2 digits, rounded to nearest BoundingBox.width)
    open static func locationIdentifier(for location: CLLocationCoordinate2D) -> String {
        let latitudeDegrees = paddedAndRoundedDegrees(degrees: location.latitude)
        
        let longitudeDegrees = paddedAndRoundedDegrees(degrees: location.longitude)
        
        return "\(latitudeDegrees)_\(longitudeDegrees)"
    }

    fileprivate static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.format = "000.00"
        formatter.positivePrefix = "+"
        return formatter
    }
    
    /// Returns a valid coordinate from a 13 character locationIdentifier
    ///
    /// - Parameter locationIdentifier: 13 character locationIdentifier
    /// - Returns: Coordinate of locationIdentifier
    open static func location(forLocationIdentifier locationIdentifier: String) -> CLLocationCoordinate2D {
        let components = locationIdentifier.split(separator: "_")
        
        if let latitudeString = components.first,
            let longitudeString = components.last,
            let latitude = formatter.number(from: "\(latitudeString)"),
            let longitude = formatter.number(from: "\(longitudeString)") {
            return CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
        }
        
        return kCLLocationCoordinate2DInvalid
    }
    
    /// Width of bounding box in degrees of latitude/longitude
    open static let width = 0.5
    
    fileprivate static func paddedAndRoundedDegrees(degrees: CLLocationDegrees) -> String {
        let widths = degrees / width
        let roundedWidths = widths.rounded(.down)
        let roundedDegrees = roundedWidths * width
        
        guard var string = formatter.string(from: NSNumber(value: roundedDegrees)) else {
            return ""
        }
        
        // Fix zero which isn't shown as positive by formatter
        if string == "000.00" {
            string = "+000.00"
        }
        
        return string
    }
}
