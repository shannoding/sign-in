//
//  User.swift
//  signin
//
//  Created by Shannon Ding on 7/12/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Properties
    
    let uid: String
    var username: String
    var email: String
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Init
    
    init(uid: String, username: String, email: String) {
        self.uid = uid
        self.username = username
        self.email = email
        super.init()
    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let username = dict["username"] as? String, let email = dict["email"] as? String else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.email = email
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let username = aDecoder.decodeObject(forKey: "username") as? String,
        let email = aDecoder.decodeObject(forKey: "email") as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        self.email = email
        
        super.init()
    }
    
    // MARK: - Class Methods
    
    // 5
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
        
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
    }
}
