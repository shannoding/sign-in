//
//  DatabaseReferenceLocation.swift
//  signin
//
//  Created by Shannon Ding on 7/11/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseReference {
    enum SignLocation {
        case root
        case groups(uid: String) //find groupIDs user has joined
        case profile(uid: String) //enter the profile of a user
        case groupMembers(groupID: String) //find all memberUIDs of a group
        
        
        
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            switch self {
            case .root:
                return root
                
            case .groups(let uid):
                return root.child(uid).child("groups")
            
            case .profile(let uid):
                return root.child(uid)
                
            case .groupMembers(let groupID):
                return root.child("groups").child(groupID).child("members")
            }
            
        }
        
        
    }
    
    
    static func toLocation(_ location: SignLocation) -> DatabaseReference {
        return location.asDatabaseReference()
    }
    
}
