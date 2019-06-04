//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Haley Jones on 6/3/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation
import CloudKit
class Entry{
    var title: String
    var text: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, text: String, timestamp: Date, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)){
        self.text = text
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
        self.title = title
    }
    
    //i also wanna be able to initialize an entry from a record
    convenience init?(record: CKRecord){
        guard let text = record["text"] as? String, let timestamp = record["timestamp"] as? Date, let title = record["title"] as? String else {return nil}
        self.init(title: title, text: text, timestamp: timestamp, ckRecordID: record.recordID)
    }
}
//entry needs to be equatable so we can find its index in an array later
extension Entry: Equatable{
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID &&
        lhs.text == rhs.text &&
        lhs.timestamp == rhs.timestamp &&
        lhs.title == rhs.title
    }
}


//we write this extension to give CKRecord another initializer to allow us to make a record from an Entry
extension CKRecord{
    convenience init(entry: Entry){
        self.init(recordType: "Entry", recordID: entry.ckRecordID)
        self.setValue(entry.text, forKey: "text")
        self.setValue(entry.timestamp, forKey: "timestamp")
        self.setValue(entry.title, forKey: "title")
    }
}
