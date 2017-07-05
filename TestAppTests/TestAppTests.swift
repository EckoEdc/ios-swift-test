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
        for section in 0..<vm.section {
            let count = vm.count(section: section)
            vm.add(withText: "Test", section: section)
            XCTAssertEqual(vm.count(section: section), count+1)
        }
    }
    
    func test3EditDataSource() {
        for section in 0..<vm.section {
            vm.edit(atIndex: 1, withText: "Test", section: section)
            XCTAssertEqual(vm.getText(forIndex: 1, section: section), "Test")
        }
    }
    
    func test4DeleteDataSource() {
        for section in 0..<vm.section {
            let count = vm.count(section: section)
            vm.delete(atIndex: 0, section: section)
            XCTAssertEqual(vm.count(section: section), count-1)
        }
    }
}
