//
//  EditViewController.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var noteTextView: UITextView!
    
    //MARK: - Properties
    var notesViewModel: NotesViewModel!
    var selectedIndex: Int = -1
    
    //MARK: - UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedIndex >= 0 {
            self.noteTextView.text = notesViewModel.getText(forIndex: selectedIndex)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.noteTextView.becomeFirstResponder()
    }
    
    //MARK: - Actions
    
    @IBAction func onDoneTapped(_ sender: Any) {
        guard !noteTextView.text.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Text cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if selectedIndex >= 0 {
            notesViewModel.edit(atIndex: selectedIndex, withText: noteTextView.text)
        } else {
            notesViewModel.add(withText: noteTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
