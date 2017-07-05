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
    
    func addTask(withText text: String) {
        app.navigationBars["Notes"].buttons["Add"].tap()
        let textField = app.textViews["Note Text Field"]
        textField.typeText(text)
        app.navigationBars["Add"].buttons["Done"].tap()
    }
    
    func test1AddTask() {
        addTask(withText: "Test")
        
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
    
    func test3SearchNotes() {
        addTask(withText: "banana")
        addTask(withText: "Banana")
        addTask(withText: "Bandit")
        addTask(withText: "Bob")
        app.tables.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("Ban")
        XCTAssertEqual(app.tables.cells.count, 3)
    }
    
    func test4DeleteTask() {
        
        while app.tables.cells.count > 0 {
            let cell = app.tables.cells.allElementsBoundByIndex[0]
            cell.swipeLeft()
            app.tables.buttons["Delete"].tap()
        }
        
        XCTAssert(app.tables.cells.count == 0)
    }
    
}
