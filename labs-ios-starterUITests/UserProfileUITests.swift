//
//  UserProfileUITests.swift
//  labs-ios-starterUITests
//
//  Created by Kevin Stewart on 3/25/21.
//  Copyright © 2021 Spencer Curtis. All rights reserved.
//

import XCTest

class UserProfileTests: XCTestCase {
    
    var app: XCUIApplication!
    
    func testUserLogin() {
        app = XCUIApplication()
        app.launch()
        app.buttons["skipOkta"].tap()
        
        
    }
}
