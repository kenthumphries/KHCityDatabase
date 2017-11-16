//
//  KHCityFileParser.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 20/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation
import CoreLocation

public enum CityFileParserError : Error {
    case citiesFileNameNotFound
    case citiesLineUnexpectedNumberOfFields
    case citiesLineAdmin1NameNotFound
    case citiesLineCountryCodeNotRecognised
    case citiesLineMissingRequiredFields
    case admin1FilNameNotFound
    case admin1LineUnexpectedNumberOfFields
    case admin1LineMissingKeysFields
    case admin1LineEmptyFields
}

extension String {
    var nonEmpty : String? {
        return self.count > 0 ? self : nil
    }
}

internal class CityFileParser: NSObject {
    
    let kLineSeparator = "\n"
    let kTabSeparator = "\t"
    let kKeySeparator = "."
    
    fileprivate var bundle : Bundle
    fileprivate(set) var citiesFileContents : String?
    fileprivate(set) var admin1FileContents : String?
    
    init(citiesFileName : String, admin1FileName : String, inBundle bundle : Bundle) throws {
        
        self.bundle = bundle
        
        super.init()
        
        guard citiesFileName.count > 0 else {
            throw CityFileParserError.citiesFileNameNotFound
        }
        guard let citiesPath = bundle.path(forResource: citiesFileName, ofType: "txt") else {
            throw CityFileParserError.citiesFileNameNotFound
        }
        
        guard admin1FileName.count > 0 else {
            throw CityFileParserError.admin1FilNameNotFound
        }
        guard let admin1Path = bundle.path(forResource: admin1FileName, ofType: "txt") else {
            throw CityFileParserError.admin1FilNameNotFound
        }
        
        // Load the files to ensure they exist
        do {
            try citiesFileContents = String(contentsOfFile: citiesPath)
        }
        catch {
            throw CityFileParserError.citiesFileNameNotFound
        }
        
        do {
            try admin1FileContents = String(contentsOfFile: admin1Path)
        }
        catch {
            throw CityFileParserError.admin1FilNameNotFound
        }
    }
    
    // MARK: - parseCities
    // Cannot be in extension as it can't be tested if so (can only test funcs in extensions that return native Swift types, not custom structs like City)
    internal func parseCities() -> [City] {
        return self.parseCities(fromContents: self.citiesFileContents)
    }
    
    func parseCities(fromContents citiesFileContents : String?) -> [City] {
        let admin1Mapping = self.createAdmin1Mapping()
        
        var locations = [City]()
        
        if let citiesLines = citiesFileContents?.components(separatedBy: kLineSeparator) {
            for line in citiesLines {
                let values = line.components(separatedBy: kTabSeparator)
                
                do {
                    let parsedValues = try self.parseCitiesValues(values, admin1Mapping: admin1Mapping)
                    
                    let location = City(cityNamePreferred : parsedValues.cityNamePreferred,
                                        timeZone: parsedValues.timeZone,
                                        countryCode: parsedValues.countryCode,
                                        countryNamePreferred: parsedValues.countryNamePreferred,
                                        admin1Code: parsedValues.admin1Code,
                                        admin1NamePreferred: parsedValues.admin1NamePreferred,
                                        admin2Code: parsedValues.admin2Code,
                                        population: parsedValues.population,
                                        latitude: parsedValues.latitude,
                                        longitude: parsedValues.longitude)
                    locations.append(location)
                } catch let error {
                    print("Caught error: \(error) for line: \(line)")
                }
            }
        }
        return locations
    }
}

extension CityFileParser {
    var kCitiesNumberOfFields : Int { return 19 }
    var kCitiesCityIndex : Int { return 1 }
    var kCitiesLatitudeIndex : Int { return 4 }
    var kCitiesLongitudeIndex : Int { return 5 }
    var kCitiesCountryCodeIndex : Int { return 8 }
    var kCitiesAdmin1CodeIndex : Int { return 10 }
    var kCitiesAdmin2CodeIndex : Int { return 11 }
    var kCitiesPopulationIndex : Int { return 14 }
    var kCitiesTimeZoneIndex : Int { return 17 }
    
    func parseCitiesValues(_ values : [String], admin1Mapping : [String : [String : String]]) throws
        -> (cityNamePreferred : String, timeZone : String, countryCode : String, countryNamePreferred : String, admin1Code : String?, admin1NamePreferred : String?, admin2Code : String?, population : Int, latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
            
            guard values.count == kCitiesNumberOfFields else {
                throw CityFileParserError.citiesLineUnexpectedNumberOfFields
            }
            
            // Non optional fields
            guard let countryCode = values[kCitiesCountryCodeIndex].nonEmpty,
                let timeZone = values[kCitiesTimeZoneIndex].nonEmpty,
                let cityName = values[kCitiesCityIndex].nonEmpty,
                let populationString = values[kCitiesPopulationIndex].nonEmpty,
                let population = Int(populationString),
                let latitudeString = values[kCitiesLatitudeIndex].nonEmpty,
                let latitude = CLLocationDegrees(latitudeString),
                let longitudeString = values[kCitiesLongitudeIndex].nonEmpty,
                let longitude = CLLocationDegrees(longitudeString) else {
                    throw CityFileParserError.citiesLineMissingRequiredFields
            }
            
            let countryNamePreferred = try fetchCountryNamePreferred(forCountryCode: countryCode)
            
            // Optional fields
            let admin1Code = values[kCitiesAdmin1CodeIndex].nonEmpty
            let admin2Code = values[kCitiesAdmin2CodeIndex].nonEmpty
            
            var admin1Name : String?
            if let admin1Code = admin1Code {
                do {
                    admin1Name = try fetchAdmin1Name(forAdmin1Code: admin1Code, countryCode: countryCode, admin1Mapping: admin1Mapping)
                }
                catch CityFileParserError.citiesLineAdmin1NameNotFound {
                    print("Warning: \(CityFileParserError.citiesLineAdmin1NameNotFound) for city : \(cityName) [\(countryCode).\(admin1Code)]")
                }
            } else {
                print("Warning: No admin1Code for city : \(cityName) [\(countryCode)]")
            }
            
            if admin2Code == nil {
                print("Warning: No admin2Code for city : \(cityName) [\(countryCode)]")
            }
            
            return (cityName, timeZone, countryCode, countryNamePreferred, admin1Code, admin1Name, admin2Code, population, latitude, longitude)
    }
    
    func fetchCountryNamePreferred(forCountryCode countryCode : String) throws -> String {
        let countryIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue : countryCode])
        let englishLocale = Locale(identifier: "en_GB")
        guard let countryNamePreferred = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: countryIdentifier) else {
            throw CityFileParserError.citiesLineCountryCodeNotRecognised
        }
        return countryNamePreferred
    }
}

@objc extension CityFileParser {
    
    internal func createAdmin1Mapping() -> [String : [String : String]] {
        return self.createAdmin1Mapping(fromContents: self.admin1FileContents)
    }
    
}

extension CityFileParser {
    
    func createAdmin1Mapping(fromContents admin1FileContents : String?) -> [String : [String : String]] {
        
        var mapping = [String : [String : String]]()
        
        if let admin1Lines = admin1FileContents?.components(separatedBy: kLineSeparator) {
            for line in admin1Lines {
                
                let values = line.components(separatedBy: kTabSeparator)
                
                do {
                    let parsedValues = try self.parseAdmin1MappingValues(values)
                    if var countryMapping = mapping[parsedValues.countryCode] {
                        countryMapping[parsedValues.admin1Code] = parsedValues.admin1Name
                        mapping[parsedValues.countryCode] = countryMapping
                    } else {
                        mapping[parsedValues.countryCode] = [parsedValues.admin1Code : parsedValues.admin1Name]
                    }
                } catch let error {
                    print("Caught error: \(error) for line: \(line)")
                }
            }
        }
        return mapping
    }
    
    var kAdmin1NumberOfFields : Int { return 4 }
    var kAdmin1KeysIndex : Int { return 0 }
    var kAdmin1NameIndex : Int { return 1 }
    var kAdmin1NumberOfKeysFields : Int { return 2 }
    var kAdmin1KeysCountryCodeIndex : Int { return 0 }
    var kAdmin1KeysAdmin1CodeIndex  : Int { return 1 }
    
    func parseAdmin1MappingValues(_ values : [String]) throws -> (countryCode : String, admin1Code : String, admin1Name : String) {
        
        guard values.count == kAdmin1NumberOfFields else {
            throw CityFileParserError.admin1LineUnexpectedNumberOfFields
        }
        
        let admin1Keys = values[kAdmin1KeysIndex].components(separatedBy: kKeySeparator)
        
        guard admin1Keys.count == kAdmin1NumberOfKeysFields else {
            throw CityFileParserError.admin1LineMissingKeysFields
        }
        
        if let countryCode = admin1Keys[kAdmin1KeysCountryCodeIndex].nonEmpty,
            let admin1Code = admin1Keys[kAdmin1KeysAdmin1CodeIndex].nonEmpty,
            let admin1Name = values[kAdmin1NameIndex].nonEmpty {
            return (countryCode, admin1Code, admin1Name)
        } else {
            throw CityFileParserError.admin1LineEmptyFields
        }
    }
    
    func fetchAdmin1Name(forAdmin1Code admin1Code : String?, countryCode : String, admin1Mapping : [String : [String : String]]) throws -> String? {
        if let validAdmin1Code = admin1Code {
            guard let admin1Name = (admin1Mapping[countryCode]?[validAdmin1Code])?.nonEmpty else {
                throw CityFileParserError.citiesLineAdmin1NameNotFound
            }
            return admin1Name
        }
        return nil
    }
}
