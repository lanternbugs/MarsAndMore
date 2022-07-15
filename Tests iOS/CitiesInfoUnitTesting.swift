//
//  CitiesInfoUnitTesting.swift
//  Tests iOS
//
//  Created by Michael Adams on 7/14/22.
//

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

    func testCitiesDataNotNil() throws {
        wait(for: [expected], timeout: 5)
        XCTAssertNotNil(sut.cityInfo)
    }
    
    func testThereAreCities() throws {
        wait(for: [expected], timeout: 5)
        guard let cities = sut.cityInfo?.cities  else {
            XCTAssertNotNil(sut.cityInfo)
            return
        }
        XCTAssertGreaterThan(cities.count, 0)
    }
    
    func testLatitudeLongitudeNotZeroZero() throws {
        wait(for: [expected], timeout: 5)
        guard let cities = sut.cityInfo?.cities  else {
            XCTAssertNotNil(sut.cityInfo)
            return
        }
        for city in cities {
            let zeroZero = city.latitude.getLatLongAsDouble() == 0 && city.longitude.getLatLongAsDouble() == 0 ? true : false
            XCTAssertNotEqual(zeroZero, true)
        }
    }
    
    func testLatitudeInRange() throws {
        wait(for: [expected], timeout: 5)
        guard let cities = sut.cityInfo?.cities  else {
            XCTAssertNotNil(sut.cityInfo)
            return
        }
        for city in cities {
            let outOfRange = city.latitude.getLatLongAsDouble() >= -90 && city.latitude.getLatLongAsDouble() <= 90 ? false : true
            XCTAssertNotEqual(outOfRange, true)
        }
    }
    
    func testLongitudeInRange() throws {
        wait(for: [expected], timeout: 5)
        guard let cities = sut.cityInfo?.cities  else {
            XCTAssertNotNil(sut.cityInfo)
            return
        }
        for city in cities {
            let outOfRange = city.longitude.getLatLongAsDouble() >= -180 && city.longitude.getLatLongAsDouble() <= 180 ? false : true
            XCTAssertNotEqual(outOfRange, true)
        }
    }

}
