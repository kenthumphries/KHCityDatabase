//
//  BoundingBox.swift
//  KHCityDatabaseCreator
//
//  Created by Kent Humphries on 10/1/18.
//  Copyright © 2018 KentHumphries. All rights reserved.
//

import Foundation
import RealmSwift

open class BoundingBox: Object {
    
    @objc open dynamic var locationIdentifier : String = ""
    open let contained = List<City>()
    
    public convenience init(locationIdentifier: String) {
        self.init()
        self.locationIdentifier = locationIdentifier
    }
}
