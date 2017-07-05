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
    func onError(error: Error)
}

class NotesViewModel {
    
    //MARK: - Properties
    
    private var notesList: [NoteModel] = []
    private var filteredNotesList: [NoteModel]?
    private var dataSource: DataSourceProtocol
    
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
        dataSource = NoteCoreDataSource()
        dataSource.getAllNotes { (notesList, error) in
            self.notesList = notesList
            self.delegate?.onDataUpdate()
        }
    }
    
    //MARK: - Getters
    
    func getText(forIndex index: Int) -> String? {
        let notesList = filteredNotesList ?? self.notesList
        guard index >= 0, index < notesList.count else {
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
        let note = NoteModel(withText: text)
        if let error = dataSource.add(note) {
           self.delegate?.onError(error: error)
        } else {
            notesList.append(note)
            self.delegate?.onUpdate(atIndex: notesList.count-1, eventType: .insert)
        }
    }
    
    func delete(atIndex index: Int) {
        guard index >= 0, index < notesList.count else {
            return
        }
        if let error = dataSource.delete(notesList[index]) {
            self.delegate?.onError(error: error)
        } else {
            notesList.remove(at: index)
            self.delegate?.onUpdate(atIndex: index, eventType: .delete)
        }
    }
    
    func edit(atIndex index: Int, withText text: String) {
        guard index >= 0, index < notesList.count else {
            return
        }
        let note = notesList[index]
        if let error = dataSource.edit(note, withText: text) {
            self.delegate?.onError(error: error)
        } else {
            note.text = text
            self.delegate?.onUpdate(atIndex: index, eventType: .edit)
        }
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
