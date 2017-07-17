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
        
        let ref = Database.database().reference().child("users").child(firUser.uid).child("profile")
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
    static func updateUser(_ firUser: FIRUser, username: String, email: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username, "email": email]
        
        let ref = Database.database().reference().child("users").child(firUser.uid).child("profile")
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
}