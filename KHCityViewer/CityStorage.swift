//
//  CityStorage.swift
//  KHCityViewer
//
//  Created by Kent Humphries on 12/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import Foundation
import CoreData
import KHCityDatabase
import Combine

class CityStorage: NSObject, ObservableObject {
    var cities = CurrentValueSubject<[City], Never>([])
    private let cityFetchController: NSFetchedResultsController<City>
    private let databaseFetcher: KHCityDatabaseFetcher
    
    static let shared: CityStorage = CityStorage()
    
    private override init() {
        databaseFetcher = KHCityDatabaseFetcher()
        cityFetchController = NSFetchedResultsController(fetchRequest: City.createFetchRequest(), managedObjectContext: databaseFetcher.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        cityFetchController.delegate = self
        
        do {
            try cityFetchController.performFetch()
            cities.value = cityFetchController.fetchedObjects ?? []
        } catch  {
            print("Error: Could not fetch objects")
        }
    }
}

extension CityStorage: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let cities = controller.fetchedObjects as? [City] else { return }
        print("Context has changed, reloading cities")
        self.cities.value = cities
    }
}
