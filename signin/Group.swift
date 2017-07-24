//
//  Group.swift
//  signin
//
//  Created by Shannon Ding on 7/19/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Group {
    var key: String
    var name: String
    var dictValue: [String : String] {
        
        return ["group_name" : name]
    }
    
    init(key: String, name: String) {
        self.name = name
        self.key = key
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let name = dict["group_name"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
    }
}
