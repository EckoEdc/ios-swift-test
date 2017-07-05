//
//  TestAppUITests.swift
//  TestAppUITests
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import XCTest

class TestAppUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test1AddTask() {
        app.navigationBars["Notes"].buttons["Add"].tap()
        let textField = app.textViews["Note Text Field"]
        textField.typeText("Test")
        app.navigationBars["Add"].buttons["Done"].tap()
        
        XCTAssert(app.tables.cells.count >= 1)
    }
    
    func test2EditTask() {
        let cell = app.tables.cells.allElementsBoundByIndex[0]
        cell.tap()
        let textField = app.textViews["Note Text Field"]
        textField.press(forDuration: 1.2)
        app.menuItems["Select All"].tap()
        textField.typeText("Test")
        app.navigationBars["Add"].buttons["Done"].tap()
        
        XCTAssert(app.tables.cells.staticTexts["Test"].exists)
    }
    
    func test3DeleteTask() {
        
        while app.tables.cells.count > 0 {
            let cell = app.tables.cells.allElementsBoundByIndex[0]
            cell.swipeLeft()
            app.tables.buttons["Delete"].tap()
        }
        
        XCTAssert(app.tables.cells.count == 0)
    }
    
}
