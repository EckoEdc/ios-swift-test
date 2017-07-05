//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import XCTest
@testable import TestApp

class TestAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMockDataSource() {
        
        let expec = expectation(description: "Get all notes")
        
        let dataSource = NoteMockSource()
        dataSource.getAllNotes { (notesList, error) in
            if !notesList.isEmpty {
                expec.fulfill()
            } else {
                XCTFail("No notes were retrieved")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
