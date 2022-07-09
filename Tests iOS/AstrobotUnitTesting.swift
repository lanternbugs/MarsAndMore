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

    func testSunSignIsCorrestForFirstOfMonth() throws
    {

    }

    func testDegreeStringsNotEmpty() throws
    {

    }

    func testNoPlanetsDuplicated() throws
    {

    }
        
    func testNoSignNone() throws
    {

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
