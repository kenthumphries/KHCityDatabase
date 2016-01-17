//
//  TimeZoneQuery.swift
//  TimeZoneDatabase
//
//  Created by Kent Humphries on 2/01/2016.
//  Copyright © 2016 HumpBot. All rights reserved.
//

import Foundation

public protocol TimeZoneQuery {
    func locationsMatchingCityNameEnglish(cityNameEnglish : String) -> CityLocations
}