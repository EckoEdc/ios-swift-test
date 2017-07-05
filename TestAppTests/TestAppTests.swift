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
    
    let vm = NotesViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test1MockDataSource() {
        
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
    
    func test2AddDataSource() {
        let count = vm.count
        vm.add(withText: "Test")
        XCTAssertEqual(vm.count, count+1)
    }
    
    func test3EditDataSource() {
        vm.edit(atIndex: 1, withText: "Test")
        XCTAssertEqual(vm.getText(forIndex: 1), "Test")
    }
    
    func test4DeleteDataSource() {
        let count = vm.count
        vm.delete(atIndex: 0)
        XCTAssertEqual(vm.count, count-1)
    }
}
