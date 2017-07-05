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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.notesViewModel.delete(atIndex: index.row)
        }
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditSegue", sender: self)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier else {
            return
        }
        switch id {
        case "AddSegue":
            let vc = segue.destination as! EditViewController
            vc.notesViewModel = self.notesViewModel
        case "EditSegue":
            let vc = segue.destination as! EditViewController
            vc.notesViewModel = self.notesViewModel
            vc.selectedIndex = tableView.indexPathForSelectedRow!.row
        default:
            break
        }
    }
    
}

//MARK: - NotesViewModelDelegate
extension NoteViewController: NotesViewModelDelegate {
    
    func onDataUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func onUpdate(atIndex index: Int, eventType: NotesViewModelDelegateEventType) {
        
        self.tableView.beginUpdates()
        
        switch eventType {
        case .insert:
            self.tableView.insertRows(at: [IndexPath(row: index, section: 0)],
                                      with: .automatic)
        case .delete:
            self.tableView.deleteRows(at:  [IndexPath(row: index, section: 0)],
                                      with: .automatic)
        case .edit:
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        self.tableView.endUpdates()
    }
}

