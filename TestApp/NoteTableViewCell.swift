//
//  NoteTableViewCell.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Configure Cell
    
    func configure(text: String?, date: Date?) {
    
        guard let text = text, let date = date else {
            return
        }
        
        self.noteTextLabel.text = text
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .full
        self.dateLabel.text = dateFormatter.string(from: date)
    }
}
