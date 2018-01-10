//
//  BoundingBoxInteractor.swift
//  KHCityDatabaseCreator
//
//  Created by Kent Humphries on 10/1/18.
//  Copyright © 2018 KentHumphries. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class BoundingBoxInteractor: NSObject {
    
    /// Returns the boundingBox locationIdentifier for this coordinate
    ///
    /// - Parameter location: The coordinate to place inside a bounding box
    /// - Returns: Identifier of format "SAAABB_TCCCDD" where:
    ///    - S = positive or negative latitude (ie east or west)
    ///    - AAA = latitude degrees (padded to 3 digits)
    ///    - BB  = latitude minutes (padded to 2 digits and rounded to nearest 0.50)
    ///    - CCC = longitude degrees (padded to 3 digits)
    ///    - DD  = longitude minutes (padded to 2 digits and rounded to nearest 0.50)
    func locationIdentifier(for location: City) -> String {
        let latitudeDegrees = paddedAndRoundedDegrees(degrees: location.latitude)
        let latitudeMinutes = roundedMinutes(degrees: location.latitude)

        let longitudeDegrees = paddedAndRoundedDegrees(degrees: location.longitude)
        let longitudeMinutes = roundedMinutes(degrees: location.longitude)

        return "\(latitudeDegrees).\(latitudeMinutes)_\(longitudeDegrees).\(longitudeMinutes)"
    }
    
    fileprivate func paddedAndRoundedDegrees(degrees: CLLocationDegrees) -> String {
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
    
    fileprivate func roundedMinutes(degrees: CLLocationDegrees) -> String {
        let roundedDegrees = Int(degrees.rounded(.towardZero))
        let minutes = degrees - Double(roundedDegrees)
        var roundedMinutes = "00"
        if  minutes >= 0.5 || minutes <= -0.5 {
            roundedMinutes = "50"
        }
        return roundedMinutes
    }
    
    func boundingBox(forLocationIdentifier locationIdentifier: String, in realm: Realm) -> BoundingBox {
        if let existing = realm.object(ofType: BoundingBox.self, forPrimaryKey: locationIdentifier) {
            return existing
        }
        
        return BoundingBox(locationIdentifier: locationIdentifier)
    }
}
