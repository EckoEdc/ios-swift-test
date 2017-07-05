//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UITableViewController {

    //MARK: - Properties
    
    var notesViewModel = NotesViewModel()

    //MARK: - UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        
        notesViewModel.delegate = self
        
        tableView.contentInset.top = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    //MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as!NoteTableViewCell
        
        cell.configure(text: notesViewModel.getText(forIndex: indexPath.row),
                       date: notesViewModel.getDate(forIndex: indexPath.row))
        return cell
    }
}

//MARK: - NotesViewModelDelegate
extension NoteViewController: NotesViewModelDelegate {
    
    func onDataUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

