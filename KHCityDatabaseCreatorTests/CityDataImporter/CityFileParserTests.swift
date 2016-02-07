//
//  CityFileParserTests.swift
//  KHCityDatabase
//
//  Created by Kent Humphries on 20/12/2015.
//  Copyright © 2015 HumpBot. All rights reserved.
//

import XCTest
@testable import KHCityDatabaseCreator
import CoreLocation

class CityFileParserStub : CityFileParser {

    var stubCitiesFileContents : String?
    var stubAdmin1FileContents : String?
    
    override func parseCities() -> [City] {
        
        if let fileContents = self.stubCitiesFileContents {
            return self.parseCities(fromContents: fileContents)
        } else {
            return self.parseCities(fromContents: self.citiesFileContents)
        }
    }
    
    override func createAdmin1Mapping() -> [String : [String : String]] {
        
        if let fileContents = self.stubAdmin1FileContents {
            return self.createAdmin1Mapping(fromContents: fileContents)
        } else {
            return self.createAdmin1Mapping(fromContents: self.admin1FileContents)
        }
    }
}

let citiesFileName = "cities5000"
let admin1FileName = "admin1CodesASCII"

class CityFileParserTests: XCTestCase {

    let binaryFileName = "binary"
    
    var testBundle : NSBundle?
    
    override func setUp() {
        super.setUp()
        
       testBundle = NSBundle(forClass: self.dynamicType)
    }

    // MARK: - Setup Tests
    
    func testBundleIsInitialised() {
        XCTAssertNotNil(testBundle)
    }
    
    func testFilesExistInTestBundle() {
        XCTAssertNotNil(testBundle?.pathForResource(citiesFileName, ofType: "txt"), "Cannot find file: '" + citiesFileName + "'")
        XCTAssertNotNil(testBundle?.pathForResource(admin1FileName, ofType: "txt"), "Cannot find file: '" + admin1FileName + "'")
        XCTAssertNotNil(testBundle?.pathForResource(binaryFileName, ofType: "txt"), "Cannot find file: '" + binaryFileName + "'")
    }
    
    // MARK: - Initialiser Tests

    func testInit_emptyCitiesFileName() {
        do {
            _ = try timeZoneFileParser(citiesFileName:"")
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
        catch CityFileParserError.citiesFileNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }

    func testInit_emptyAdmin1FileName() {
        do {
            _ = try timeZoneFileParser(admin1FileName: "")
            XCTFail("Parser must throw .admin1FilNameNotFound error")
        }
        catch CityFileParserError.admin1FilNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }

    func testInit_invalidCitiesFileName() {
        do {
            _ = try timeZoneFileParser(citiesFileName:"garbage")
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
        catch CityFileParserError.citiesFileNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }
    
    func testInit_invalidAdmin1FileName() {
        do {
            _ = try timeZoneFileParser(admin1FileName: "garbage")
            XCTFail("Parser must throw .admin1FilNameNotFound error")
        }
        catch CityFileParserError.admin1FilNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }
    
    func testInit_binaryCitiesFileName() {
        do {
            _ = try timeZoneFileParser(citiesFileName:binaryFileName)
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
        catch CityFileParserError.citiesFileNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }
    
    func testInit_binaryAdmin1FileName() {
        do {
            _ = try timeZoneFileParser(admin1FileName: binaryFileName)
            XCTFail("Parser must throw .admin1FilNameNotFound error")
        }
        catch CityFileParserError.admin1FilNameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesFileNameNotFound error")
        }
    }
    
    // MARK: - parseAdmin1MappingValues Tests
    
    func testParseAdmin1MappingValues_valid() {
        do {
            let values = ["AU.07", "Victoria", "", ""]
            let parsedValues = try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTAssertEqual(parsedValues.countryCode, "AU")
            XCTAssertEqual(parsedValues.admin1Code, "07")
            XCTAssertEqual(parsedValues.admin1Name, "Victoria")
        }
        catch {
            XCTFail("Parser must not throw an error")
        }
    }
    
    func testParseAdmin1MappingValues_noValues() {
        do {
            let values = [String]()
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineUnexpectedNumberOfFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineUnexpectedNumberOfFields error")
        }
    }
    
    func testParseAdmin1MappingValues_emptyCodes() {
        do {
            let values = ["", "Victoria", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineMissingKeysFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineMissingKeysFields error")
        }
    }
    
    func testParseAdmin1MappingValues_missingCodesSeparator() {
        do {
            let values = ["AU07", "Victoria", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineMissingKeysFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineMissingKeysFields error")
        }
    }
    
    func testParseAdmin1MappingValues_emptyCountryCode() {
        do {
            let values = [".07", "Victoria", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineEmptyFields error")
        }
    }
    
    func testParseAdmin1MappingValues_emptyAdmin1Code() {
        do {
            let values = ["AU.", "Victoria", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineEmptyFields error")
        }
    }
    
    func testParseAdmin1MappingValues_emptyAdmin1Name() {
        do {
            let values = [".07", "", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineEmptyFields error")
        }
    }
    
    func testParseAdmin1MappingValues_extraFields() {
        do {
            let values = [".07", "", "", "", ""]
            try stubCityFileParser().parseAdmin1MappingValues(values)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.admin1LineUnexpectedNumberOfFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .admin1LineUnexpectedNumberOfFields error")
        }
    }
    
    // MARK: - createAdmin1Mapping Tests

    func testCreateAdmin1Mapping_emptyContents() {

        let contents = ""
        let parser = stubCityFileParser(admin1FileContents: contents)
        
        let mapping = parser.createAdmin1Mapping()
        XCTAssertEqual(mapping.count, 0)
    }
    
    func testCreateAdmin1Mapping_singleLine() {
        
        let contents = "AU.07\tVictoria\tVictoria\t2145234"
        let parser = stubCityFileParser(admin1FileContents: contents)
        
        let mapping = parser.createAdmin1Mapping()
        XCTAssertTrue(mappingDictionariesAreEqual(lhs:admin1MappingVictoria, rhs: mapping))
    }

    func testCreateAdmin1Mapping_fiveLines() {
        
        let contents = "AU.07\tVictoria\tVictoria\t2145234" + "\n"
            + "AU.06\tTasmania\tTasmania\t2145231" + "\n"
            + "AU.04\tQueensland\tQueensland\t2145232" + "\n"
            + "GB.SCT\tScotland\tScotland\t2145233" + "\n"
            + "GB.WLS\tWales\tWales\t2145235"
        let expectedMapping : [String: [String : String]] = [
            "AU" : ["07" : "Victoria", "04" : "Queensland", "06" : "Tasmania"],
            "GB" : ["SCT" : "Scotland", "WLS" : "Wales"]
        ]
        let parser = stubCityFileParser(admin1FileContents: contents)
        
        let mapping = parser.createAdmin1Mapping()
        XCTAssertTrue(mappingDictionariesAreEqual(lhs:expectedMapping, rhs: mapping), "\(mapping) is not equal to \(expectedMapping)")
    }
    
    func testCreateAdmin1Mapping_invalidLine() {
        
        let contents = "AU.07\tVictoria\tVictoria\t2145234" + "\n" + "garbage" + "\n" + "GB.WLS\tWales\tWales\t2145235"
        
        let expectedMapping : [String: [String : String]] = [
            "AU" : ["07" : "Victoria"],
            "GB" : ["WLS" : "Wales"]
        ]
        let parser = stubCityFileParser(admin1FileContents: contents)
        
        let mapping = parser.createAdmin1Mapping()
        XCTAssertTrue(mappingDictionariesAreEqual(lhs:expectedMapping, rhs: mapping), "\(mapping) is not equal to \(expectedMapping)")
    }
    
    // MARK: - parseCitiesValues Tests
    
    func testParseCitiesValues_valid() {
        do {
            let values = self.citiesLineValues()
            let parsedValues = try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)

            XCTAssertEqual(parsedValues.cityNameEnglish, "Melbourne")
            XCTAssertEqual(parsedValues.timeZoneEnglish, "Australia/Melbourne")
            XCTAssertEqual(parsedValues.countryCode, "AU")
            XCTAssertEqual(parsedValues.countryNameEnglish, "Australia")
            XCTAssertEqual(parsedValues.admin1Code, "07")
            XCTAssertEqual(parsedValues.admin1NameEnglish, "Victoria")
        }
        catch {
            XCTFail("Parser must not throw an error")
        }
    }

    func testParseCitiesValues_noValues() {
        do {
            let values = [String]()
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineUnexpectedNumberOfFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineUnexpectedNumberOfFields error")
        }
    }
    
    func testParseCitiesValues_emptyCountryCode() {
        do {
            let values = self.citiesLineValues(countryCode: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }
    
    func testParseCitiesValues_unrecognisedCountryCode() {
        do {
            let values = self.citiesLineValues(countryCode: ".?!")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineCountryCodeNotRecognised {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineCountryCodeNotRecognised error")
        }
    }
    
    func testParseCitiesValues_emptyAdmin1Code() {
        do {
            let values = self.citiesLineValues(admin1Code: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }
    
    func testParseCitiesValues_emptyTimeZone() {
        do {
            let values = self.citiesLineValues(timeZone: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }

    func testParseCitiesValues_emptyCityName() {
        do {
            let values = self.citiesLineValues(cityName: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }
    
    func testParseCitiesValues_emptyAdmin2Code() {
        do {
            let values = self.citiesLineValues(admin2Code: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }

    func testParseCitiesValues_emptyPopulation() {
        do {
            let values = self.citiesLineValues(population: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }
    
    func testParseCitiesValues_emptyLatitude() {
        do {
            let values = self.citiesLineValues(latitude: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }

    func testParseCitiesValues_emptyLongitude() {
        do {
            let values = self.citiesLineValues(longitude: "")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineEmptyFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineEmptyFields error")
        }
    }

    func testParseCitiesValues_emptyAdmin1Mapping() {
        do {
            let values = self.citiesLineValues()
            let admin1Mapping = [String : [String : String]]()
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1Mapping)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineAdmin1NameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineAdmin1NameNotFound error")
        }
    }

    func testParseCitiesValues_Admin1MappingNotFound() {
        do {
            // Use admin1Code that cannot be found in admin1Mapping
            let values = self.citiesLineValues(admin1Code : "04")
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineAdmin1NameNotFound {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineAdmin1NameNotFound error")
        }
    }

    func testParseCitiesValues_extraFields() {
        do {
            let values = [".07", ""]
            try stubCityFileParser().parseCitiesValues(values, admin1Mapping: admin1MappingVictoria)
            XCTFail("Parser must throw error")
        }
        catch CityFileParserError.citiesLineUnexpectedNumberOfFields {
            // Do nothing test passed
        }
        catch {
            XCTFail("Parser must throw .citiesLineUnexpectedNumberOfFields error")
        }
    }

    // MARK: - parseCities Tests
    
    func testParseCities_emptyContents() {
        
        let contents = ""
        let parser = stubCityFileParser(citiesFileContents: contents)
        
        let cities = parser.parseCities()
        XCTAssertEqual(cities.count, 0)
    }
    
    func testParseCities_singleLine() {
        
        let parser = stubCityFileParser(citiesFileContents: citiesLineMelbourne)
        let cities = parser.parseCities()

        XCTAssertEqual([cityMelbourne], cities)
    }
    
    func testParseCities_fiveLines() {
        
        let contents = [citiesLineMelbourne, citiesLineHobart, citiesLineBrisbane, citiesLineGlasgow, citiesLineCardiff].joinWithSeparator("\n")
        
        let expectedCities = [cityMelbourne, cityHobart, cityBrisbane, cityGlasgow, cityCardiff]
        
        let parser = stubCityFileParser(citiesFileContents: contents)
        let cities = parser.parseCities()
        XCTAssertEqual(cities.count, 5)
        XCTAssertEqual(expectedCities[0], cities[0])
        XCTAssertEqual(expectedCities[1], cities[1])
        XCTAssertEqual(expectedCities[2], cities[2])
        XCTAssertEqual(expectedCities[3], cities[3])
        XCTAssertEqual(expectedCities[4], cities[4])
    }
    
    func testParseCities_invalidLine() {
        
        let lineGlasgow = "Glasgow Wheee!"
        let contents = [citiesLineMelbourne, citiesLineHobart, citiesLineBrisbane, lineGlasgow, citiesLineCardiff].joinWithSeparator("\n")
        
        let expectedCities = [cityMelbourne, cityHobart, cityBrisbane, cityCardiff]
        
        let parser = stubCityFileParser(citiesFileContents: contents)
        let cities = parser.parseCities()
        XCTAssertEqual(cities.count, 4)
        XCTAssertEqual(expectedCities[0], cities[0])
        XCTAssertEqual(expectedCities[1], cities[1])
        XCTAssertEqual(expectedCities[2], cities[2])
        XCTAssertEqual(expectedCities[3], cities[3])
    }

    // MARK: - Utilties
    
    var admin1MappingVictoria : [String : [String : String]] {
        return ["AU" : ["07" : "Victoria"]]
    }
    
    var citiesLineMelbourne : String {
        return self.citiesLineValues().joinWithSeparator("\t")
    }

    var cityMelbourne : City {
        return City(cityNameEnglish: "Melbourne", timeZoneEnglish: "Australia/Melbourne", countryCode: "AU", countryNameEnglish: "Australia", admin1Code: "07", admin1NameEnglish: "Victoria", admin2Code: "24600", population: 123456, latitude: 37.81, longitude: 144.96)
    }
    
    var citiesLineHobart : String {
        return self.citiesLineValues(cityName: "Hobart", timeZone: "Australia/Hobart", admin1Code: "06", admin2Code: "12345", population: "30000", latitude: "37.81", longitude: "140.96").joinWithSeparator("\t")
    }
    
    var cityHobart : City {
        return City(cityNameEnglish: "Hobart", timeZoneEnglish: "Australia/Hobart", countryCode: "AU", countryNameEnglish: "Australia", admin1Code: "06", admin1NameEnglish: "Tasmania", admin2Code: "12345", population: 30000, latitude: 37.81, longitude: 140.96)
    }
    
    var citiesLineBrisbane : String {
        return self.citiesLineValues(cityName: "Brisbane", timeZone: "Australia/Brisbane", admin1Code: "04", admin2Code: "23456", population: "300000", latitude: "37.81", longitude: "148.96").joinWithSeparator("\t")
    }
    
    var cityBrisbane : City {
        return City(cityNameEnglish: "Brisbane", timeZoneEnglish: "Australia/Brisbane", countryCode: "AU", countryNameEnglish: "Australia", admin1Code: "04", admin1NameEnglish: "Queensland", admin2Code: "23456", population: 300000, latitude: 37.81, longitude: 148.96)
        
    }
    
    var citiesLineGlasgow : String {
        return self.citiesLineValues(cityName: "Glasgow", timeZone: "Europe/London", countryCode: "GB", admin1Code: "SCT", admin2Code: "34567", population: "2000000", latitude: "55.85", longitude: "4.26").joinWithSeparator("\t")
    }
    
    var cityGlasgow : City {
        return City(cityNameEnglish: "Glasgow", timeZoneEnglish: "Europe/London", countryCode: "GB", countryNameEnglish: "United Kingdom", admin1Code: "SCT", admin1NameEnglish: "Scotland", admin2Code: "34567", population: 2000000, latitude: 55.85, longitude: 4.26)
    }
    
    var citiesLineCardiff : String {
        return self.citiesLineValues(cityName: "Cardiff", timeZone: "Europe/London", countryCode: "GB", admin1Code: "WLS", admin2Code: "45678", population: "10000", latitude: "55.85", longitude: "6.26").joinWithSeparator("\t")
    }

    var cityCardiff : City {
        return City(cityNameEnglish: "Cardiff", timeZoneEnglish: "Europe/London", countryCode: "GB", countryNameEnglish: "United Kingdom", admin1Code: "WLS", admin1NameEnglish: "Wales", admin2Code: "45678", population: 10000, latitude: 55.85, longitude: 6.26)
    }
    
    func citiesLineValues(
        cityName cityName:String? = "Melbourne",
        timeZone:String? = "Australia/Melbourne",
        countryCode:String? = "AU",
        admin1Code:String? = "07",
        admin2Code:String? = "24600",
        population:String? = "123456",
        latitude:String? = "37.81",
        longitude:String? = "144.96") -> [String] {
            
            return ["", cityName!, "", "", latitude!, longitude!, "", "", countryCode!, "", admin1Code!, admin2Code!, "", "", population!, "", "", timeZone!, ""]
    }
    
    func mappingDictionariesAreEqual(lhs lhs : [String : [String : String]], rhs : [String : [String : String]]) -> Bool {
        
        var isEqual = false
        
        let equalKeys = Array(lhs.keys) == Array(rhs.keys)
        
        if equalKeys {
            var allKeysAreEqual = true
            
            for key in lhs.keys {
                allKeysAreEqual = allKeysAreEqual && lhs[key]! == rhs[key]!
                
                if !allKeysAreEqual {
                    break;
                }
            }
            isEqual = allKeysAreEqual
        }
        
        return isEqual
    }
    
    func validCityFileParser() -> CityFileParser {
        
        let parser = try? timeZoneFileParser()
        return parser!
    }
    
    func stubCityFileParser(
        citiesFileContents citiesFileContents:String? = nil,
        admin1FileContents:String? = nil) -> CityFileParserStub {
            
            let parser = try? CityFileParserStub(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: testBundle!)
            parser?.stubAdmin1FileContents = admin1FileContents
            parser?.stubCitiesFileContents = citiesFileContents
            return parser!
    }
    
    func timeZoneFileParser(
        citiesFileName citiesFileName:String = citiesFileName,
        admin1FileName:String = admin1FileName) throws -> CityFileParser {
            
            let parser = try CityFileParser(citiesFileName: citiesFileName, admin1FileName: admin1FileName, inBundle: testBundle!)
            return parser
    }
    
}
