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
        try realm.writeCopy(toFile:compactedFileURL)

        return compactedFileURL
    }
    
    func getFileURL(_ config : Realm.Configuration) throws -> URL {
        // Use the default directory, but replace the filename with databaseName
        guard let fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(databaseName).realm") else {
                throw CityRealmCreatorError.invalidFileURL
        }
        
        return fileURL
    }
    
    func getCompactedFileURL(_ fileURL : URL) throws -> URL {
        let baseURL : URL
        // Create a temporary directory using timestamp
        do {
            baseURL = try FileManager().url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: fileURL, create: true)
        }
        catch {
            throw CityRealmCreatorError.invalidFileURL
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'_'HH-mm-ss-Z"
        let timestamp = formatter.string(from: Date()).replacingOccurrences(of: "+", with: "t")
        let directoryURL = baseURL.appendingPathComponent(timestamp)
        
        do {
            try _ = FileManager().createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        catch {
            throw CityRealmCreatorError.invalidFileURL
        }

        let compactedFileURL = directoryURL.appendingPathComponent("\(databaseName)-compacted.realm")
        return compactedFileURL
    }
    
    func removeFileAtURL(_ url : URL) throws {
        let filePath = url.path
        if FileManager.default.fileExists(atPath: filePath) {
            try FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    func populateNewRealm(_ config : Realm.Configuration, citiesFileName : String, admin1FileName : String) throws -> Realm {
        // Create a new realm, import files and write to disk
        let realm = try Realm(configuration: config)
        
        let locations = try CityFileParser(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: Bundle.main).parseCities()
        
        try realm.write({ () -> Void in
            for location in locations {
                realm.add(location)
            }
        })
        
        try realm.write {
            let interactor = BoundingBoxInteractor()
            for location in locations {
                let boundingBox = interactor.boundingBox(forLocationIdentifier: location.locationIdentifier, in: realm)
                boundingBox.contained.append(location)
            }
        }
        
        return realm
    }

}
