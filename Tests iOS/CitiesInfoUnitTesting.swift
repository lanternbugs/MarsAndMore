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
        sut = BirthDataManager() { [weak self] in
            self?.expected.fulfill()
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        expected = nil
        try super.tearDownWithError()
    }

    func testCitiesDataNotNil() throws {
        wait(for: [expected], timeout: 5)
        XCTAssertNotNil(sut.cityInfo)
    }

}
