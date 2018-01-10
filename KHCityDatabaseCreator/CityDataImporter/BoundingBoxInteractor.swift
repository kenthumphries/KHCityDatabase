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
    
    func boundingBox(forLocationIdentifier locationIdentifier: String, in realm: Realm) -> BoundingBox {
        let boundingBoxes = realm.objects(BoundingBox.self)
        let identifierPredicate = NSPredicate(format: "%K == %@", "locationIdentifier", locationIdentifier)
        if let existing = boundingBoxes.filter(identifierPredicate).first {
            return existing
        }
        
        let new = BoundingBox(locationIdentifier: locationIdentifier)
        realm.add(new)
        return new
    }
}
