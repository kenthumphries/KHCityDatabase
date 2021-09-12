//
//  CityViewViewModel.swift
//  KHCityViewer
//
//  Created by Kent Humphries on 12/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import Foundation
import KHCityDatabase
import Combine

class CityViewViewModel: ObservableObject {
    @Published var cities: [City] = [] {
        willSet {
            print("Updating cities to: \(newValue.count)")
        }
    }
    
    private var cancellable: AnyCancellable?
    
    init(cityPublisher: AnyPublisher<[City], Never> = CityStorage.shared.cities.eraseToAnyPublisher()) {
        cancellable = cityPublisher.sink { cities in
            self.cities = cities
            print("Updating cities")
        }
    }
}
