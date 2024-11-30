//
//  MarsRoomUITesting.swift
//  Tests iOS
//
//  Created by Michael Adams on 11/30/24.
//

import XCTest

final class MarsRoomUITesting: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        let marsTab = app.tabBars["Tab Bar"].buttons["Mars Room"]
        marsTab.tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAboutGoesBackToMarsRoom() throws {
        
        let aboutButton = app.buttons["About"]
        let backMars = app.buttons["<Mars Room"]
        
        XCTAssertTrue(aboutButton.exists)
        aboutButton.tap()
        XCTAssertTrue(backMars.exists)
        backMars.tap()
        XCTAssertTrue(aboutButton.exists)
        
                        
    }
    
    func testBeforeAfterGoState() throws {
        let goButton = app.buttons["Go"]
        let introText = app.staticTexts["Pick a date and select go for an Evengeline Adams(ghostwriter Crowley) Sun Reading and sign Mars is in on this date."]
        
        XCTAssertTrue(introText.exists)
        goButton.tap()
        XCTAssertTrue(!introText.exists)
    }
}
