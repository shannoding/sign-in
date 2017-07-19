//
//  GroupService.swift
//  signin
//
//  Created by Shannon Ding on 7/19/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

/*import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct GroupService {

    var groups: [Group]
    
    private static func create(groupName: String) {
        // create new group in database
        
        
        // list of group keys under user uid profile
        // list of uids inside a group key (group_members and group_admins)
        // list of other attributes under group key
        let currentUser = User.current
        // 2
        let group = Group(name: groupName)
        // 3
        let dict = group.dictValue
        
        // 4
        let postRef = Database.database().reference().child(currentUser.uid).child("groups").childByAutoId()
        //5
        postRef.updateChildValues(dict)
    }
}*/
