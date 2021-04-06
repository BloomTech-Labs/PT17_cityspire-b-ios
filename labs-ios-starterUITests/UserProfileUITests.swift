//
//  UserProfileUITests.swift
//  labs-ios-starterUITests
//
//  Created by Kevin Stewart on 3/25/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import XCTest

class UserProfileTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    func testUserMisspellsCity() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.searchFields.element.tap()
        app.typeText("San Francisco")
        app.keyboards.buttons["search"].tap()
        sleep(2)
        XCTAssertTrue(app.alerts.element.buttons["OK"].exists)
    }
    
    func testUserSearchesForACity() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.searchFields.element.tap()
        app.typeText("San Francisco, CA")
        app.keyboards.buttons["search"].tap()
        sleep(2)
        app.alerts.element.buttons["View City"].tap()
        
        XCTAssertEqual(app.staticTexts["City name"].label, "San Francisco, CA")
        XCTAssertTrue(app.collectionViews.cells.count >= 1)
    }
    
    func testUserCanPinACityToFavorites() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.searchFields.element.tap()
        app.typeText("San Francisco, CA")
        app.keyboards.buttons["search"].tap()
        sleep(2)
        app.alerts.element.buttons["View City"].tap()
        app.buttons["PinnedButton"].tap()
        app.buttons["pinnedList"].tap()
        
        XCTAssertEqual(app.staticTexts["cityLabel"].label, "San Francisco, CA")
    }
    
    func testUserCanRemovePinnedCity() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.buttons["pinnedList"].tap()
        app.buttons["favoriteButton"].tap()
        
        XCTAssertFalse(app.staticTexts["San Francisco, CA"].exists)
    }
    
    
    
}
