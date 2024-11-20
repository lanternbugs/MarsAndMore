/*
*  Copyright (C) 2022-2023 Michael R Adams.
*  All rights reserved.
*
* This program can be redistributed and/or modified under
* the terms of the GNU General Public License; either
* version 2 of the License, or (at your option) any later version.
*
*  This code is distributed in the hope that it will
*  be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/


import XCTest
@testable import MarsAndMore

class CitiesInfoUnitTesting: XCTestCase {
    var sut: BirthDataManager!
    var expected: XCTestExpectation!

    override func setUpWithError() throws {
        try super.setUpWithError()
        expected = expectation(description: "callback happens")
        sut = BirthDataManager()
        sut.citiesParsedCompletionHandler = { [weak self] in
            self?.expected.fulfill()
        }
    }

    override func tearDownWithError() throws {
        sut.citiesParsedCompletionHandler = nil
        sut = nil
        expected = nil
        try super.tearDownWithError()
    }

    
    
    func testThereAreCities() throws {
        wait(for: [expected], timeout: 5)
        let cities = sut.subCityInfo
        XCTAssertGreaterThan(cities.count, 0)
    }
    
    func testLatitudeLongitudeNotZeroZero() throws {
        wait(for: [expected], timeout: 5)
        let cities = sut.subCityInfo
        for group in cities {
            for city in group.cities {
                let zeroZero = city.latitude.getLatLongAsDouble() == 0 && city.longitude.getLatLongAsDouble() == 0 ? true : false
                XCTAssertNotEqual(zeroZero, true)
            }
            
        }
    }
    
    func testLatitudeInRange() throws {
        wait(for: [expected], timeout: 5)
        let cities = sut.subCityInfo
        for group in cities {
            for city in group.cities {
                let outOfRange = city.latitude.getLatLongAsDouble() >= -90 && city.latitude.getLatLongAsDouble() <= 90 ? false : true
                XCTAssertNotEqual(outOfRange, true)
            }

        }
    }
    
    func testLongitudeInRange() throws {
        wait(for: [expected], timeout: 5)
        let cities = sut.subCityInfo
        for group in cities {
            for city in group.cities {
                let outOfRange = city.longitude.getLatLongAsDouble() >= -180 && city.longitude.getLatLongAsDouble() <= 180 ? false : true
                XCTAssertNotEqual(outOfRange, true)
            }
            
        }
    }

}
