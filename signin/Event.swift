//
//  Event.swift
//  signin
//
//  Created by Shannon Ding on 7/19/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Event {
    var key: String
    var name: String
    var date: String
    var groupOf: String
    var dictValue: [String : String] {
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //let toDate = formatter.date(from: myString)
        //let dateString = formatter.string(from: date)
        return ["event_name" : name,
                "event_date" : date,
                "event_group_of": groupOf]
    }
    
    init(key: String, name: String, groupOf: String, date: String) {
        self.name = name
        self.key = key
        self.groupOf = groupOf
        self.date = date
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["event_name"] as? String,
            let date = dict["event_date"] as? String,
            let groupOf = dict["event_group_of"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
        self.date = date
        self.groupOf = groupOf
    }
}

