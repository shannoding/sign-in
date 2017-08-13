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
    
    static var groups: [Group] = []
        //Group(key: "GROUPKEY1", name: "GROUPNAME1"), Group(key: "GROUPKEY2", name: "GROUPNAME2"), Group(key: "GROUPKEY3", name: "GROUPNAME3"),Group(key: "GROUPKEY4", name: "GROUPNAME4"), Group(key: "GROUPKEY5", name: "GROUPNAME5"), Group(key: "GROUPKEY6", name: "GROUPNAME6")]
    //var groupKey: String?
    
    
    static func create(groupName: String, uid: String) {
        print("creating a group now!")
        
        let ref = Database.database().reference().child("groups_about").childByAutoId()
        
        let key = ref.key //Database.database().reference().child("groups_about").childByAutoId()
        let group = Group(key: key, name: groupName)
        // 3
        let dict = group.dictValue
        
        ref.updateChildValues(dict)
        
        let baseRef = Database.database().reference()
        baseRef.child("groups_joined").child(uid).child(key).updateChildValues(dict)
        //baseRef.child("group_members").child(key).child( //user array)
        
        self.groups.append(group)
        
    }
    
    static func fillGroups(uid: String, completion: @escaping ([Group]) -> ()) {
        GroupService.groups = []
        let ref = Database.database().reference().child("groups_joined").child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print(snapshot)
            for snip in snapshot {
                guard let dict = snip.value as? [String : Any],
                    let name = dict["group_name"] as? String
                    else { return }
                
                let group = Group(key: snip.key, name: name)
                print("Fill groups groups are: \(group)")
                groups.append(group)
                completion(groups)
                return
            }
            completion([])
            //HomeViewController.refresh()
            
        })
    }
    
    static func searchGroupArray(completion: @escaping ([String]) -> ()) -> [String] {
        var groupSearchData: [String] = []
        let ref = Database.database().reference().child("groups_about")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print(snapshot)
            for snip in snapshot {
                guard let dict = snip.value as? [String: String],
                let groupName = dict["group_name"]
                    else { return }
                groupSearchData.append(groupName)
            }
            completion(groupSearchData)
            print("The group search data is \(groupSearchData)")
            })
        return groupSearchData
    }
    
    static func showMembers(groupKey: String, completion: @escaping ([String]) -> ()) {
        var groupMembersArray: [String] = []
        let ref = Database.database().reference().child("group_members").child(groupKey)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print("The group members snapshot is \(snapshot)")
            for snip in snapshot {
                guard let dict = snip.value as? [String: String],
                    let username = dict["username"]
                    else { return }
                groupMembersArray.append(username)
            }
            completion(groupMembersArray)
            print("The group members data is \(groupMembersArray)")
        })
    }
    
    static func searchGroup(completion: @escaping ([Group]) -> ()) {
        var groupSearchData: [Group] = []
        let ref = Database.database().reference().child("groups_about")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for snip in snapshot {
                guard let dict = snip.value as? [String: String],
                    let groupName = dict["group_name"]
                    else { return }
                let groupKey = snip.key
                let group = Group(key: groupKey, name: groupName)
                groupSearchData.append(group)
            }
            completion(groupSearchData)
        })
    }
    
    static func flagGroup(_ group: Group) {
        // 1
        let groupKey = group.key
        
        // 2
        let flaggedGroupRef = Database.database().reference().child("flagged_groups").child(groupKey)
        
        
        let groupName = group.name
        let flaggedDict = ["group_name": groupName,
                           "admins": ["this", "doesn't", "exist", "yet"],
                           "reporter_uid": User.current.uid] as [String : Any]
        
        // 4
        flaggedGroupRef.updateChildValues(flaggedDict)
        
        // 5
        let flagCountRef = flaggedGroupRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        })
    }
    
}
