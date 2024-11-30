//
//  ChartRoomUITesting.swift
//  Tests iOS
//
//  Created by Michael Adams on 11/20/24.
//

import XCTest

final class ChartRoomUITesting: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        let chartTab = app.tabBars["Tab Bar"].buttons["Charts"]
        chartTab.tap()
    }

    override func tearDownWithError() throws {
        
    }

    func testNameVsTimeNow() throws {
        let elementsQuery = app.scrollViews.otherElements
        let elementsQuery2 = elementsQuery.scrollViews.otherElements
        let timeNow = elementsQuery.staticTexts["Time Now"]
        let johnas = elementsQuery2.staticTexts["Johnas"]
        let edit = elementsQuery2.buttons["Edit"]
        let transitsButton = app.buttons["Transits"]
        
        timeNow.tap()
        XCTAssertFalse(edit.exists)
        XCTAssertFalse(transitsButton.exists)
        johnas.tap()
        XCTAssertTrue(transitsButton.exists)
        XCTAssertTrue(edit.exists)
    }
    
    
    func testSettingsGoesBackToChartRoom() throws {
        let settingsButton = app.buttons["Chart Settings"]
        let chartRoomButton = app.buttons["<Chart Room"]
        let elementsQuery = app.scrollViews.otherElements
        let timeNow = elementsQuery.staticTexts["Time Now"]
        settingsButton.tap()
        XCTAssertTrue(chartRoomButton.exists)
        chartRoomButton.tap()
        XCTAssertTrue(timeNow.exists)
                
    }
    
    func testResourcesGoesBackToChartRoom() throws {
        let resourcesButton = app.buttons["Resources"]
        let chartRoomButton = app.buttons["<Chart Room"]
        let elementsQuery = app.scrollViews.otherElements
        let timeNow = elementsQuery.staticTexts["Time Now"]
        resourcesButton.tap()
        XCTAssertTrue(chartRoomButton.exists)
        chartRoomButton.tap()
        XCTAssertTrue(timeNow.exists)
    }
    
    func testPartnerGoesBackToChartRoom() throws {
        let partnerButton = app.buttons["Partner"]
        let chartRoomButton = app.buttons["<Chart Room"]
        let elementsQuery = app.scrollViews.otherElements
        let timeNow = elementsQuery.staticTexts["Time Now"]
        partnerButton.tap()
        XCTAssertTrue(chartRoomButton.exists)
        chartRoomButton.tap()
        XCTAssertTrue(timeNow.exists)
    }
}
