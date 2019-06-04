//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Haley Jones on 6/3/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation
import CloudKit

class EntryController{
    //Singleton
    static let shared = EntryController()
    
    //Source of Truth
    var entries: [Entry] = []{
        didSet{
            guard let tableViewFriend = tableViewFriend else {return}
            DispatchQueue.main.async {
                tableViewFriend.tableView.reloadData()
            }
        }
    }
    
    //a reference to the table view controller for reasons.
    var tableViewFriend: EntryListTableViewController?
    
    //database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD bb
    func createEntry(title: String, text: String, timestamp: Date){
        let entry = Entry(title: title, text: text, timestamp: timestamp)
        self.saveEntry(entry: entry) { (_) in
            //we dont do anything in here?
        }
    }
    
    func removeEntry(entry: Entry, completion: @escaping (Bool) -> ()){
        //remove locally
        guard let index = EntryController.shared.entries.firstIndex(of: entry) else {completion(false); return}
        EntryController.shared.entries.remove(at: index)
        //remove cloudally
        privateDB.delete(withRecordID: entry.ckRecordID) { (_, error) in
            if let error = error{
                print("There was an error deleting the entry from the CloudKit Database. \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func fetchEntries(completion: @escaping (Bool) -> ()){
        let predicate = NSPredicate(value: true) //this makes it ascend
        let query = CKQuery(recordType: "Entry", predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error{
                print("⚠️More bad code!⚠️ \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = records else {completion(false); return}
            let mappedEntries = records.compactMap({Entry(record: $0)})
            self.entries = mappedEntries
            completion(true)
        }
    }
    
    func saveEntry(entry: Entry, completion: @escaping (Bool) -> ()){
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error{
                print("⚠️oh no! Bad code!⚠️ \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let unwrappedRecord = record, let entry = Entry(record: unwrappedRecord) else {completion(false); return}
            self.entries.append(entry)
            completion(true)
        }
    }
    
}
