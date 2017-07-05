//
//  NotesViewModel.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation

protocol NotesViewModelDelegate: class {
    func onDataUpdate()
}

class NotesViewModel {
    
    //MARK: - Properties
    
    private var notesList: [NoteModel] = []
    weak var delegate: NotesViewModelDelegate?
    
    var count : Int {
        get {
            return notesList.count
        }
    }
    
    //MARK: - Initializer
    
    init() {
        NoteMockSource().getAllNotes { (notesList, error) in
            self.notesList = notesList
            self.delegate?.onDataUpdate()
        }
    }
    
    //MARK: - Getters
    
    func getText(forIndex index: Int) -> String? {
        guard index <= notesList.count else {
            return nil
        }
        return notesList[index].text
    }
    
    func getDate(forIndex index: Int) -> Date? {
        guard index <= notesList.count else {
            return nil
        }
        return notesList[index].dateOfCreation
    }
}
