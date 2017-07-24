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

}
