//
//  UserService.swift
//  signin
//
//  Created by Shannon Ding on 7/13/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct UserService {
    static func createUser(_ firUser: FIRUser, username: String, email: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username, "email": email]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                print(snapshot)
                User.setCurrent(user!)
                completion(user)
            })
        }
    }
    static func updateUser(_ firUser: FIRUser, username: String, email: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username, "email": email]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func groups(for user: User, completion: @escaping ([Group]) -> Void) {
        let ref = Database.database().reference().child("groups_joined").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let groups: [Group] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let group = Group(snapshot: $0)
                            else { return nil }
                        
                        
                        return group
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(groups)
            })
        })
    }
    
    static func joinGroup(uid: String, groupKey: String, completion: @escaping (Group) -> Void) {
        let userInfoRef = Database.database().reference().child("users").child(uid)
        userInfoRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let userDict = snapshot.value as? [String: String],
            let username = userDict["username"],
            let email = userDict["email"]
                else { return }
            let userAttrs = ["username": username, "email": email]
        let groupMemberRef = Database.database().reference().child("group_members").child(groupKey).child(uid)
        groupMemberRef.setValue(userAttrs)
        
        // get group key and name
        let groupInfoRef = Database.database().reference().child("groups_about").child(groupKey)
        groupInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let groupDict = snapshot.value as? [String: String],
                let groupName = groupDict["group_name"] as? String
            else { return }
            
            // add user as a member of the group
            let ref = Database.database().reference().child("group_members").child(groupKey).child(uid)
            ref.setValue(userAttrs) { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                let groupJoined = Group(key: groupKey, name: groupName)
                let groupJoinedRef = Database.database().reference().child("groups_joined").child(uid).child(groupKey)
                
                // check if the user already joined
                groupJoinedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let groupDict = snapshot.value as? [String: String],
                        let groupName = groupDict["group_name"] as? String
                        else {
                            EventService.populateNewUserEvents(groupKey: groupKey, uid: uid) { complete in
                                if complete {
                                    let dict = groupJoined.dictValue
                                    groupJoinedRef.updateChildValues(dict)
                                    return completion(groupJoined)
                                }
                                else {
                                    print("ERROR in populate all new user events")
                                }
                            }
                            return completion(groupJoined)
                        }
                    print("the joined group group name is \(groupName)")
                                    // user did not already join
                                    let dict = groupJoined.dictValue
                                    groupJoinedRef.updateChildValues(dict)
                                    return completion(groupJoined)
    
                })
                
//                // user did not already join
//                let dict = groupJoined.dictValue
//                groupJoinedRef.updateChildValues(dict)
//                return completion(groupJoined)
            }
            
        })
        
    })
        
    }
    
    //static func leaveGroup(groupKey: String, )

}
