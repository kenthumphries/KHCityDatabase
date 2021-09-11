//
//  KHCityDatabaseFetcher.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 11/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import Foundation
import CoreData

class KHCityDatabaseFetcher {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let modelName = "CityDatabase"
        guard let modelDir = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "momd") else { fatalError() }
        guard let mom = NSManagedObjectModel(contentsOf: modelDir) else { fatalError() }

        let container = NSPersistentContainer(name: modelName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func cities() throws -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        return try persistentContainer.viewContext.fetch(fetchRequest)
    }
}
