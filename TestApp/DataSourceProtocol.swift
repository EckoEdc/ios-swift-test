//
//  DataSource.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation

protocol DataSourceProtocol {
    func getAllNotes(onComplete: @escaping ([NoteModel], Error?) -> ())
    func add(_ note: NoteModel) -> Error?
    func edit(_ note: NoteModel, withText text: String) -> Error?
    func delete(_ note: NoteModel) -> Error?
}

extension DataSourceProtocol {
    
    func add(_ note: NoteModel) -> Error? {
        return nil
    }
    
    func edit(_ note: NoteModel, withText text: String) -> Error? {
        return nil
    }
    
    func delete(_ note: NoteModel) -> Error? {
        return nil
    }
}

