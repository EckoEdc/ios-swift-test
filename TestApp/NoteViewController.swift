//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UITableViewController {

    //MARK: - Properties
    
    var notesViewModel = NotesViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    //MARK: - UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteCell")
        
        notesViewModel.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notesViewModel.section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesViewModel.count(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as!NoteTableViewCell
        
        cell.configure(text: notesViewModel.getText(forIndex: indexPath.row,
                                                    section: indexPath.section),
                       date: notesViewModel.getDate(forIndex: indexPath.row,
                                                    section: indexPath.section))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return notesViewModel.sectionHeaderTitle(for: section)
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.notesViewModel.delete(atIndex: index.row, section: indexPath.section)
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
            vc.selectedSection = tableView.indexPathForSelectedRow!.section
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
    
    func onUpdate(atIndex index: (Int, Int), eventType: NotesViewModelDelegateEventType) {
        
        self.tableView.beginUpdates()
        
        switch eventType {
        case .insert:
            self.tableView.insertRows(at: [IndexPath(row: index.0, section: index.1)],
                                      with: .automatic)
        case .delete:
            self.tableView.deleteRows(at:  [IndexPath(row: index.0, section: index.1)],
                                      with: .automatic)
        case .edit:
            self.tableView.reloadRows(at: [IndexPath(row: index.0, section: index.1)], with: .automatic)
        }
        
        self.tableView.endUpdates()
    }
    
    func onError(error: Error) {
        let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UISearchResultsUpdating
extension NoteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        notesViewModel.filter(contains: searchController.searchBar.text!)
    }
}

