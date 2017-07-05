//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation

class NoteModel {
    
    //MARK: - Properties
    
    var text: String
    var dateOfCreation: Date
    
    //MARK: - Initializers
    
    init(withText text: String, createdOn date: Date) {
        self.text = text
        self.dateOfCreation = date
    }
    
    convenience init(withText text: String) {
        self.init(withText: text, createdOn: Date())
    }

}
