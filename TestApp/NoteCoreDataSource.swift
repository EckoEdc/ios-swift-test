//
//  NoteCoreDataSource.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum NoteCoreDataSourceError : Error {
    case NoteNotFound
}

class NoteCoreDataSource: DataSourceProtocol {
    
    func getAllNotes(onComplete: @escaping ([NoteModel], Error?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            let noteList = try managedObjectContext.fetch(fetchRequest)
            let result = noteList.map({ (note) -> NoteModel in
                return NoteModel(withText: note.text!, createdOn: note.dateOfCreation! as Date)
            })
            onComplete(result, nil)
        } catch {
            onComplete([], error)
        }
    }
    
    func add(_ note: NoteModel) -> Error? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let noteCD = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedObjectContext) as! Note
        noteCD.text = note.text
        noteCD.dateOfCreation = note.dateOfCreation as NSDate
        do {
            try managedObjectContext.save()
            return nil
        } catch {
            return error
        }
    }
    
    func edit(_ note: NoteModel, withText text: String) -> Error? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text = %@ && dateOfCreation = %@", note.text, note.dateOfCreation as NSDate)
        do {
            let noteList = try managedObjectContext.fetch(fetchRequest)
            if let noteCD = noteList.first {
                noteCD.text = text
            } else {
                return NoteCoreDataSourceError.NoteNotFound
            }
            try managedObjectContext.save()
            return nil
        } catch {
            return error
        }
    }
    
    func delete(_ note: NoteModel) -> Error? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "text = %@ && dateOfCreation = %@", note.text, note.dateOfCreation as NSDate)
        do {
            let noteList = try managedObjectContext.fetch(fetchRequest)
            if noteList.count > 0 {
                for noteCD in noteList {
                    managedObjectContext.delete(noteCD)
                }
            } else {
                return NoteCoreDataSourceError.NoteNotFound
            }
            try managedObjectContext.save()
            return nil
        } catch {
            return error
        }
    }
}
