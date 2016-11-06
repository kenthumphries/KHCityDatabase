//
//  KHCityRealmCreator.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 11/01/2016.
//  Copyright © 2016 HumpBot. All rights reserved.
//

import Foundation
import RealmSwift

enum CityRealmCreatorError: Error {
    case invalidFileURL
    case invalidCompactedFileURL
    case invalidPath
}

class KHCityRealmCreator {
    
    let citiesFileName = "cities5000"
    let admin1FileName = "admin1CodesASCII"
    let databaseName = "KHCityDatabase"
    
    func generatePopulatedRealmDatabase() throws -> URL {
        
        var config = Realm.Configuration()
        
        // Create the URL for the new file and ensure it's removed
        let fileURL = try getFileURL(config)
        try removeFileAtURL(fileURL)
        
        // Create the new Realm using the config
        config.fileURL = fileURL
        let realm = try populateNewRealm(config, citiesFileName: citiesFileName, admin1FileName: admin1FileName)
        
        
        // Create the URL for the compacted file and ensure it's removed
        let compactedFileURL = try getCompactedFileURL(fileURL)
        try removeFileAtURL(compactedFileURL)
        
        // Create the compacted Realm
        try realm.writeCopyToURL(compactedFileURL)
        

        return compactedFileURL
    }
    
    func getFileURL(_ config : Realm.Configuration) throws -> URL {
        // Use the default directory, but replace the filename with databaseName
        guard let fileURL = config.fileURL?.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(databaseName).realm") else {
                throw CityRealmCreatorError.invalidFileURL
        }
        
        return fileURL
    }
    
    func getCompactedFileURL(_ fileURL : URL) throws -> URL {
        // Use the default directory, but replace the filename with databaseName & "compacted" label
        guard let compactedFileURL = fileURL.deletingLastPathComponent().appendingPathComponent("\(databaseName)-compacted.realm") else {
            throw CityRealmCreatorError.invalidCompactedFileURL
        }
        
        return compactedFileURL
    }
    
    func removeFileAtURL(_ url : URL) throws {
        guard let filePath = url.path else {
            throw CityRealmCreatorError.invalidPath
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            try FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    func populateNewRealm(_ config : Realm.Configuration, citiesFileName : String, admin1FileName : String) throws -> Realm {
        // Create a new realm, import files and write to disk
        let realm = try Realm(configuration: config)
        
        let locations = try CityFileParser(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: Bundle.mainBundle).parseCities()
        
        try realm.write({ () -> Void in
            for location in locations {
                realm.add(location)
            }
        })
        
        return realm
    }

}
