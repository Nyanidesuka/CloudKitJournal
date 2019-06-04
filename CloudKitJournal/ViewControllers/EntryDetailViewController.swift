//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by Haley Jones on 6/3/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    //landing bois
    var pageEntry: Entry?
    var entryTable: EntryListTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entry = pageEntry{
            titleTextField.text = entry.title
            bodyTextView.text = entry.text
        }
    }
    
    //IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, let body = bodyTextView.text else {return}
        guard title != "", body != "" else {return}
        if let entry = pageEntry{
            entry.text = body
            entry.title = title
            EntryController.shared.saveEntry(entry: entry) { (_) in }
        } else {
            EntryController.shared.createEntry(title: title, text: body, timestamp: Date())
        }
        //i could pop the vc but i feel like i shouldnt, i'll let the user save at multiple stges without popping etc
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
