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
    /// - Parameters:
    ///   - latitude: Latitude to be encoded
    ///   - longitude: Longitude to be encoded
    /// - Returns: Identifier is of format "SAAABB_TCCCDD" where:
    ///    - S = positive or negative latitude (ie east or west)
    ///    - AAA = latitude degrees (padded to 3 digits)
    ///    - BB  = latitude minutes (padded to 2 digits and rounded to nearest 0.50)
    ///    - CCC = longitude degrees (padded to 3 digits)
    ///    - DD  = longitude minutes (padded to 2 digits and rounded to nearest 0.50)
    open static func locationIdentifier(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        let latitudeDegrees = paddedAndRoundedDegrees(degrees: latitude)
        let latitudeMinutes = roundedMinutes(degrees: latitude)
        
        let longitudeDegrees = paddedAndRoundedDegrees(degrees: longitude)
        let longitudeMinutes = roundedMinutes(degrees: longitude)
        
        return "\(latitudeDegrees).\(latitudeMinutes)_\(longitudeDegrees).\(longitudeMinutes)"
    }
    
    fileprivate static func paddedAndRoundedDegrees(degrees: CLLocationDegrees) -> String {
        let roundedDegrees = Int(degrees.rounded(.towardZero))
        if roundedDegrees >= 0 {
            if roundedDegrees < 10 {
                return "+00\(roundedDegrees)"
            } else if roundedDegrees < 100 {
                return "+0\(roundedDegrees)"
            } else {
                return "+\(roundedDegrees)"
            }
        } else {
            let unsignedRoundedDegrees = roundedDegrees.magnitude
            if unsignedRoundedDegrees < 10 {
                return "-00\(unsignedRoundedDegrees)"
            } else if unsignedRoundedDegrees < 100 {
                return "-0\(unsignedRoundedDegrees)"
            } else {
                return "-\(unsignedRoundedDegrees)"
            }
        }
    }
    
    fileprivate static func roundedMinutes(degrees: CLLocationDegrees) -> String {
        let roundedDegrees = Int(degrees.rounded(.towardZero))
        let minutes = degrees - Double(roundedDegrees)
        var roundedMinutes = "00"
        if  minutes >= 0.5 || minutes <= -0.5 {
            roundedMinutes = "50"
        }
        return roundedMinutes
    }
}
