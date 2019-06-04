//
//  EntryListTableViewController.swift
//  CloudKitJournal
//
//  Created by Haley Jones on 6/3/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.shared.tableViewFriend = self
        EntryController.shared.fetchEntries { (success) in
            if (success){
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else{
                print("there was an error loading data.")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        let entry = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: entry.timestamp, dateStyle: .medium, timeStyle: .short)
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.shared.entries[indexPath.row]
            EntryController.shared.removeEntry(entry: entry) { (didItWork) in
                if didItWork{
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExistingEntry"{
            guard let destinVC = segue.destination as? EntryDetailViewController else {return}
            guard let index = tableView.indexPathForSelectedRow else {return}
            let passEntry = EntryController.shared.entries[index.row]
            destinVC.entryTable = self
            destinVC.pageEntry = passEntry
        }
    }
}
