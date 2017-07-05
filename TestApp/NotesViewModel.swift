//
//  NotesViewModel.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation

enum NotesViewModelDelegateEventType {
    case insert
    case delete
    case edit
}

protocol NotesViewModelDelegate: class {
    func onDataUpdate()
    func onUpdate(atIndex index: Int, eventType: NotesViewModelDelegateEventType)
}

class NotesViewModel {
    
    //MARK: - Properties
    
    private var notesList: [NoteModel] = []
    private var filteredNotesList: [NoteModel]?
    
    weak var delegate: NotesViewModelDelegate?
    
    var count : Int {
        get {
            if let filteredList = filteredNotesList {
                return filteredList.count
            }
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
        let notesList = filteredNotesList ?? self.notesList
        guard index >= 0, index < notesList.count else {
            print(notesList.count)
            return nil
        }
        return notesList[index].text
    }
    
    func getDate(forIndex index: Int) -> Date? {
        let notesList = filteredNotesList ?? self.notesList
        guard index >= 0, index < notesList.count else {
            return nil
        }
        return notesList[index].dateOfCreation
    }
    
    //MARK: - CRUD
    func add(withText text: String) {
        notesList.append(NoteModel(withText: text))
        self.delegate?.onUpdate(atIndex: notesList.count-1, eventType: .insert)
    }
    
    func delete(atIndex index: Int) {
        guard index >= 0, index < notesList.count else {
            return
        }
        notesList.remove(at: index)
        self.delegate?.onUpdate(atIndex: index, eventType: .delete)
    }
    
    func edit(atIndex index: Int, withText text: String) {
        guard index >= 0, index < notesList.count else {
            return
        }
        notesList[index].text = text
        self.delegate?.onUpdate(atIndex: index, eventType: .edit)
    }
    
    //MARK: - Filter
    func filter(contains text: String) {
        if text.isEmpty {
            filteredNotesList = nil
        } else {
            filteredNotesList = notesList.filter({ (note) -> Bool in
                return note.text.lowercased().contains(text.lowercased())
            })
        }
        self.delegate?.onDataUpdate()
    }
}
