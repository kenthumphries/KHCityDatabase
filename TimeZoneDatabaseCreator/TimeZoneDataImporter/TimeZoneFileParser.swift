//
//  TimeZoneFileParser.swift
//  TimeZoneDatabase
//
//  Created by Kent Humphries on 20/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import Foundation

public enum TimeZoneFileParserError : ErrorType {
    case citiesFileNameNotFound
    case citiesLineUnexpectedNumberOfFields
    case citiesLineAdmin1NameNotFound
    case citiesLineCountryCodeNotRecognised
    case citiesLineEmptyFields
    case admin1FilNameNotFound
    case admin1LineUnexpectedNumberOfFields
    case admin1LineMissingKeysFields
    case admin1LineEmptyFields
}

extension String {
    var nonEmpty : String? {
        return self.characters.count > 0 ? self : nil
    }
}

internal class TimeZoneFileParser: NSObject {
    
    let kLineSeparator = "\n"
    let kTabSeparator = "\t"
    let kKeySeparator = "."
    
    private var bundle : NSBundle
    private(set) var citiesFileContents : String?
    private(set) var admin1FileContents : String?
    
    init(citiesFileName : String, admin1FileName : String, inBundle bundle : NSBundle) throws {

        self.bundle = bundle

        super.init()

        guard citiesFileName.characters.count > 0 else {
            throw TimeZoneFileParserError.citiesFileNameNotFound
        }
        guard let citiesPath = bundle.pathForResource(citiesFileName, ofType: "txt") else {
            throw TimeZoneFileParserError.citiesFileNameNotFound
        }

        guard admin1FileName.characters.count > 0 else {
            throw TimeZoneFileParserError.admin1FilNameNotFound
        }
        guard let admin1Path = bundle.pathForResource(admin1FileName, ofType: "txt") else {
            throw TimeZoneFileParserError.admin1FilNameNotFound
        }
        
        // Load the files to ensure they exist
        do {
            try citiesFileContents = String(contentsOfFile: citiesPath)
        }
        catch {
            throw TimeZoneFileParserError.citiesFileNameNotFound
        }
        
        do {
            try admin1FileContents = String(contentsOfFile: admin1Path)
        }
        catch {
            throw TimeZoneFileParserError.admin1FilNameNotFound
        }
    }

    // MARK: - parseLocations
    // Cannot be in extension as it can't be tested if so (can only test funcs in extensions that return native Swift types, not custom structs like Location)
    internal func parseLocations() -> [Location] {
        return self.parseLocations(fromContents: self.citiesFileContents)
    }
    
    func parseLocations(fromContents citiesFileContents : String?) -> [Location] {
        let admin1Mapping = self.createAdmin1Mapping()
        
        var locations = [Location]()
        
        if let citiesLines = citiesFileContents?.componentsSeparatedByString(kLineSeparator) {
            for line in citiesLines {
                let values = line.componentsSeparatedByString(kTabSeparator)
                
                do {
                    let parsedValues = try self.parseCitiesValues(values, admin1Mapping: admin1Mapping)
                    
                    let location = Location(cityNameEnglish : parsedValues.cityNameEnglish,
                        timeZoneEnglish: parsedValues.timeZoneEnglish,
                        countryCode: parsedValues.countryCode,
                        countryNameEnglish: parsedValues.countryNameEnglish,
                        admin1Code: parsedValues.admin1Code,
                        admin1NameEnglish: parsedValues.admin1NameEnglish,
                        admin2Code: parsedValues.admin2Code,
                        population: parsedValues.population)
                    locations.append(location)
                } catch let error {
                    print("Caught error: \(error) for line: \(line)")
                }
            }
        }
        return locations
    }
}

extension TimeZoneFileParser {
    var kCitiesNumberOfFields : Int { return 19 }
    var kCitiesCityIndex : Int { return 1 }
    var kCitiesCountryCodeIndex : Int { return 8 }
    var kCitiesAdmin1CodeIndex : Int { return 10 }
    var kCitiesAdmin2CodeIndex : Int { return 11 }
    var kCitiesPopulationIndex : Int { return 14 }
    var kCitiesTimeZoneIndex : Int { return 17 }
    
    func parseCitiesValues(values : [String], admin1Mapping : [String : [String : String]]) throws
        -> (cityNameEnglish : String, timeZoneEnglish : String, countryCode : String, countryNameEnglish : String, admin1Code : String, admin1NameEnglish : String, admin2Code : String, population : Int) {
            
            guard values.count == kCitiesNumberOfFields else {
                throw TimeZoneFileParserError.citiesLineUnexpectedNumberOfFields
            }
            
            if let countryCode = values[kCitiesCountryCodeIndex].nonEmpty,
                let admin1Code = values[kCitiesAdmin1CodeIndex].nonEmpty,
                let timeZone = values[kCitiesTimeZoneIndex].nonEmpty,
                let cityName = values[kCitiesCityIndex].nonEmpty,
                let admin2Code = values[kCitiesAdmin2CodeIndex].nonEmpty,
                let populationString = values[kCitiesPopulationIndex].nonEmpty,
                let population = Int(populationString) {
                    
                    let countryIdentifier = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode : countryCode])
                    let englishLocale = NSLocale(localeIdentifier: "en_GB")
                    if let countryNameEnglish = englishLocale.displayNameForKey(NSLocaleIdentifier, value: countryIdentifier) {
                        if let admin1Name = (admin1Mapping[countryCode]?[admin1Code])?.nonEmpty {
                            return (cityName, timeZone, countryCode, countryNameEnglish, admin1Code, admin1Name, admin2Code, population)
                        } else {
                            throw TimeZoneFileParserError.citiesLineAdmin1NameNotFound
                        }
                    } else {
                        throw TimeZoneFileParserError.citiesLineCountryCodeNotRecognised
                    }
            } else {
                throw TimeZoneFileParserError.citiesLineEmptyFields
            }
    }
}

extension TimeZoneFileParser {

    internal func createAdmin1Mapping() -> [String : [String : String]] {
        return self.createAdmin1Mapping(fromContents: self.admin1FileContents)
    }
    
    func createAdmin1Mapping(fromContents admin1FileContents : String?) -> [String : [String : String]] {
    
        var mapping = [String : [String : String]]()
        
        if let admin1Lines = admin1FileContents?.componentsSeparatedByString(kLineSeparator) {
            for line in admin1Lines {
                
                let values = line.componentsSeparatedByString(kTabSeparator)
                
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
    
    func parseAdmin1MappingValues(values : [String]) throws -> (countryCode : String, admin1Code : String, admin1Name : String) {
        
        guard values.count == kAdmin1NumberOfFields else {
            throw TimeZoneFileParserError.admin1LineUnexpectedNumberOfFields
        }
        
        let admin1Keys = values[kAdmin1KeysIndex].componentsSeparatedByString(kKeySeparator)
        
        guard admin1Keys.count == kAdmin1NumberOfKeysFields else {
            throw TimeZoneFileParserError.admin1LineMissingKeysFields
        }
        
        if let countryCode = admin1Keys[kAdmin1KeysCountryCodeIndex].nonEmpty,
            let admin1Code = admin1Keys[kAdmin1KeysAdmin1CodeIndex].nonEmpty,
            let admin1Name = values[kAdmin1NameIndex].nonEmpty {
                return (countryCode, admin1Code, admin1Name)
        } else {
            throw TimeZoneFileParserError.admin1LineEmptyFields
        }
    }
}
