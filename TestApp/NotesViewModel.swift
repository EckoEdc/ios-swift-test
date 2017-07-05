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
    func onUpdate(atIndex index: (Int, Int), eventType: NotesViewModelDelegateEventType)
    func onError(error: Error)
}

class NotesViewModel {
    
    //MARK: - Properties
    
    private var notesList: [[NoteModel]] = []
    private var filteredNotesList: [NoteModel]?
    private var dataSource: [DataSourceProtocol]
    
    weak var delegate: NotesViewModelDelegate?
    
    var section : Int {
        get {
            if filteredNotesList != nil {
                return 1
            }
            return dataSource.count
        }
    }
    
    //MARK: - Initializer
    
    init() {
        dataSource = [NoteMockSource(), NoteCoreDataSource()]
        
        self.notesList = [[], []]
        for (index, dataS) in dataSource.enumerated() {
            dataS.getAllNotes { (notesList, error) in
                self.notesList[index] = notesList
                self.delegate?.onDataUpdate()
            }
        }
    }
    
    //MARK: - Getters
    
    func getText(forIndex index: Int, section: Int) -> String? {
        let notesList = filteredNotesList ?? self.notesList[section]
        guard index >= 0, index < notesList.count else {
            return nil
        }
        return notesList[index].text
    }
    
    func getDate(forIndex index: Int, section: Int) -> Date? {
        let notesList = filteredNotesList ?? self.notesList[section]
        guard index >= 0, index < notesList.count else {
            return nil
        }
        return notesList[index].dateOfCreation
    }
    
    func count(section: Int) -> Int {
        if let filteredList = filteredNotesList {
            return filteredList.count
        }
        guard section >= 0, section < notesList.count else {
            return 0
        }
        return notesList[section].count
    }
    
    func sectionHeaderTitle(for section: Int) -> String {
        return String(describing: type(of:dataSource[section]))
    }
    
    //MARK: - CRUD
    
    func add(withText text: String, section: Int) {
        let note = NoteModel(withText: text)
        if let error = dataSource[section].add(note) {
           self.delegate?.onError(error: error)
        } else {
            notesList[section].append(note)
            self.delegate?.onUpdate(atIndex: (notesList[section].count-1, section), eventType: .insert)
        }
    }
    
    func delete(atIndex index: Int, section: Int) {
        guard index >= 0, index < notesList[section].count else {
            return
        }
        if let error = dataSource[section].delete(notesList[section][index]) {
            self.delegate?.onError(error: error)
        } else {
            notesList[section].remove(at: index)
            self.delegate?.onUpdate(atIndex: (index, section), eventType: .delete)
        }
    }
    
    func edit(atIndex index: Int, withText text: String, section: Int) {
        guard index >= 0, index < notesList[section].count else {
            return
        }
        let note = notesList[section][index]
        if let error = dataSource[section].edit(note, withText: text) {
            self.delegate?.onError(error: error)
        } else {
            note.text = text
            self.delegate?.onUpdate(atIndex: (index, section), eventType: .edit)
        }
    }
    
    //MARK: - Filter
    
    func filter(contains text: String) {
        if text.isEmpty {
            filteredNotesList = nil
        } else {
            filteredNotesList = notesList.joined().filter({ (note) -> Bool in
                return note.text.lowercased().contains(text.lowercased())
            })
        }
        self.delegate?.onDataUpdate()
    }
}
