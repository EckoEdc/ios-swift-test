//
//  NoteMockSource.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation

class NoteMockSource: DataSourceProtocol {
    
    //MARK: - Getters
    
    func getAllNotes(onComplete: @escaping ([NoteModel], Error?) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                if let file = Bundle.main.url(forResource: "mockData", withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd'T'hh:mm:ss Z"
                    var notesList: [NoteModel] = []
                    if let notes = json as? [[String: Any]] {
                        for note in notes {
                            notesList.append(NoteModel(withText: note["text"] as! String,
                                                       createdOn: dateFormatter.date(from: note["dateOfCreation"] as! String)!))
                        }
                    }
                    onComplete(notesList, nil)
                }
            }
            catch {
                onComplete([], error)
            }
        }
    }
    
}
