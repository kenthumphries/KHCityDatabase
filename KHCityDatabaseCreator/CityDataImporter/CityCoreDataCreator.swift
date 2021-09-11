//
//  CityCoreDataCreator.swift
//  KHCityDatabaseCreator
//
//  Created by Kent Humphries on 11/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import Foundation
import AppKit

class KHCityCoreDataCreator {
    
    let citiesFileName = "cities5000"
    let admin1FileName = "admin1CodesASCII"
    let databaseName = "KHCityDatabase"

    func generatePopulatedCoreData() throws -> URL {
        
        let appDelegate = NSApp.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext

        // Create the URL for the new file and ensure it's removed
//        let fileURL = try getFileURL(config)
//        try removeFileAtURL(fileURL)
        
        // Create the new Realm using the config
//        config.fileURL = fileURL
//        config.objectTypes = [City.self]
//        let realm = try populateNewRealm(config, citiesFileName: citiesFileName, admin1FileName: admin1FileName)
        
        let fileURL = try populateNewDatabase(viewContext, citiesFileName: citiesFileName, admin1FileName: admin1FileName)

        return fileURL
    }
    
    func populateNewDatabase(_ viewContext : NSManagedObjectContext, citiesFileName : String, admin1FileName : String) throws -> URL {
        let parser = try CityFileParser(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: Bundle.main)
        let locations = parser.parseCities(context: viewContext)
        
        print("Parsed \(locations.count) locations")
        
        let appDelegate = NSApp.delegate as! AppDelegate

        appDelegate.saveContext()
        
        return NSPersistentContainer.defaultDirectoryURL()
    }


    func removeFileAtURL(_ url : URL) throws {
        let filePath = url.path
        if FileManager.default.fileExists(atPath: filePath) {
            try FileManager.default.removeItem(atPath: filePath)
        }
    }
}
