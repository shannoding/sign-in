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
    var dictValue: [String : Any] {
        
        return ["group_name" : name]
    }
    
    init(key: String, name: String) {
        self.name = name
        self.key = key
    }
    
}
