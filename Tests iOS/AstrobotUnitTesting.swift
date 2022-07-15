//
//  AstrobotUnitTesting.swift
//  Tests iOS
//
//  Created by Michael Adams on 7/9/22.
//

import XCTest
@testable import MarsAndMore

class AstrobotUnitTesting: XCTestCase {
    
    var sut:AstroBot!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AstroBot()
        
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testPlanetsArrayNotEmpty() throws
    {
        let row = sut.getPlanets(time: Date().getAstroTime(), location: nil)
        XCTAssertGreaterThan(row.planets.count, 0)
    }
    
    func testDegreeStringsNotEmpty() throws
    {
        let row = sut.getPlanets(time: Date().getAstroTime(), location: nil)
        for planet in row.planets {
            XCTAssertGreaterThan(planet.degree.count, 0)
        }
    }

    func testNoPlanetsDuplicated() throws
    {
        let row = sut.getPlanets(time: Date().getAstroTime(), location: nil)
        var planetSet = Set<Planets>()
        for planet in row.planets {
            XCTAssertTrue(!planetSet.contains(planet.planet))
            planetSet.insert(planet.planet)
        }
    }
        
    func testNoSignNone() throws
    {
        let row = sut.getPlanets(time: Date().getAstroTime(), location: nil)
        for planet in row.planets {
            let planetCell = planet as? PlanetCell
            XCTAssertNotNil(planetCell)
            guard let planetCell = planetCell else {
                continue
            }
            XCTAssertNotEqual(planetCell.sign, Signs.None)
        }
    }
    
    func testSunSignIsCorrectForFirstOfMonth() throws
    {
        let months: [Int: Signs] = [1: .Capricorn, 2: .Aquarius, 3: .Pisces, 4: .Aries, 5: .Taurus, 6: .Gemini, 7: .Cancer, 8: .Leo, 9: .Virgo, 10: .Libra, 11: .Scorpio, 12: .Sagitarius ]
        let year = Int.random(in: 1800...2100)
        let day = 1
        for month in 1...12
        {
            let date = getDate(y: year, m: month, d: day)
            guard let date = date else {
                XCTAssertNotNil(date)
                return;
            }
            let row = sut.getPlanets(time: date.getAstroTime(), location: nil)
            let planet = row.planets.first { $0.planet == .Sun}
            guard let planet = planet as? PlanetCell else {
                XCTAssertNotNil(planet)
                return
            }
            XCTAssertEqual(planet.sign, months[month])
        }
    }
    
    func testAspectsArrayNotEmpty() throws
    {
        let row = sut.getAspects(time: Date().getAstroTime(), with: nil, and: nil)
        XCTAssertGreaterThan(row.planets.count, 0)
    }
    
    func testAspectsAspectDifferentPlanet() throws
    {
        let row = sut.getAspects(time: Date().getAstroTime(), with: nil, and: nil)
        for planet in row.planets {
            let planetCell = planet as? TransitCell
            XCTAssertNotNil(planetCell)
            guard let planetCell = planetCell else {
                continue
            }
            XCTAssertNotEqual(planetCell.planet, planetCell.planet2)
        }
    }
    
    func getDate(y: Int, m: Int, d: Int)->Date?
    {
        let calendar = Calendar.current

            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: Date())

            dateComponents?.day = d
            dateComponents?.month = m
            dateComponents?.year = y

            let date: Date? = calendar.date(from: dateComponents!)
            return date
    }

}
