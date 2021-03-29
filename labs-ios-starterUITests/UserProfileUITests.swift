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
    
    func testUserSearchForCity() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.searchFields.element.tap()
        app.typeText("San Francisco")
        app.keyboards.buttons["search"].tap()
        sleep(2)
        app.alerts.element.buttons["OK"].tap()
        app.searchFields.element.buttons["Clear text"].tap()
        XCTAssertFalse(app.searchFields.staticTexts[""].exists)
        app.typeText("San Francisco, CA")
        app.keyboards.buttons["search"].tap()
        sleep(2)
        app.alerts.element.buttons["View City"].tap()
        
        XCTAssertEqual(app.staticTexts["City name"].label, "San Francisco, CA")
        XCTAssertTrue(app.collectionViews.children(matching: .cell).count >= 1)
    }
    
    func testUserAddsCityAndRemovesCity() {
        app = XCUIApplication()
        app.launch()
        app.buttons["Test"].tap()
        app.buttons["pinnedList"].tap()
        
        if app.staticTexts["San Francisco, CA"].exists {
            app.buttons["favoriteButton"].tap()
        } else {
            app.buttons["home"].tap()
            app.collectionViews.cells.firstMatch.tap()
            app.buttons["PinnedButton"].tap()
            app.buttons["pinnedList"].tap()
            XCTAssertEqual(app.staticTexts["cityLabel"].label, "San Francisco, CA")
            app.buttons["favoriteButton"].tap()
        }
        XCTAssertFalse(app.staticTexts["cityLabel"].exists)
    }
    
    
}
