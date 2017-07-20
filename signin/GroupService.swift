//
//  GroupService.swift
//  signin
//
//  Created by Shannon Ding on 7/19/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct GroupService {

    var groups: [Group]
    var groupKey: String?
    
    static func create(groupName: String) {
        // create new group in database
        
        
        // list of uids inside a group key (group_members and group_admins)
        // list of other attributes under group key
        let currentUser = User.current
        
        let ref = Database.database().reference().child("groups_about").childByAutoId()
        
        let key = ref.key
        let group = Group(key: key, name: groupName)
        // 3
        let dict = group.dictValue
        
        ref.updateChildValues(dict)
        
        let baseRef = Database.database().reference()
        baseRef.child("groups_joined").child(currentUser.uid).child(key).updateChildValues(dict)
        //baseRef.child("group_members").child(key).child( //user array)
        
    }
}
