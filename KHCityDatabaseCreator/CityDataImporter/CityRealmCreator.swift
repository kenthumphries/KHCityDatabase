//
//  KHCityRealmCreator.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 11/01/2016.
//  Copyright © 2016 HumpBot. All rights reserved.
//

import Foundation
import RealmSwift

class KHCityRealmCreator {
    
    let citiesFileName = "cities5000"
    let admin1FileName = "admin1CodesASCII"
    let databaseName = "KHCityDatabase"
    
    func generatePopulatedRealmDatabase() throws -> String {
        
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.path = NSURL.fileURLWithPath(config.path!)
            .URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("\(databaseName).realm")
            .path
        
        // Remove file if it already exists
        if NSFileManager.defaultManager().fileExistsAtPath(config.path!) {
            try NSFileManager.defaultManager().removeItemAtPath(config.path!)
        }
        
        let realm = try Realm(configuration: config)
        
        let locations = try CityFileParser(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: NSBundle.mainBundle()).parseCities()
        
        try realm.write({ () -> Void in
            for location in locations {
                realm.add(location)
            }
        })
        
        var compactedPath = realm.path
        let url = NSURL(fileURLWithPath: realm.path)
        if let databaseDir = url.URLByDeletingLastPathComponent?.path {
            compactedPath = databaseDir + "/" + "\(databaseName)-compacted.realm"
            
            // Remove file if it already exists
            if NSFileManager.defaultManager().fileExistsAtPath(compactedPath) {
                try NSFileManager.defaultManager().removeItemAtPath(compactedPath)
            }
            
            try realm.writeCopyToPath(compactedPath)
        }
        
        return compactedPath
    }

}
