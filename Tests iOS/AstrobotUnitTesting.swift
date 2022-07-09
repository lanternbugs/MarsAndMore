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
    
    func testSunSignIsCorrestForFirstOfMonth() throws
    {

    }

}
