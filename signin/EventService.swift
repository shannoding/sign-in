//
//  EventService.swift
//  signin
//
//  Created by Shannon Ding on 7/19/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase


struct EventService {
    static var events: [Event] = []
    
    
    static func create(eventName: String, groupKey: String, uid: String, eventTime: String) {
        print("creating an event now!")
        
        let ref = Database.database().reference().child("events_about").childByAutoId()
        
        let key = ref.key
        let event = Event(key: key, name: eventName, groupOf: groupKey, date: eventTime, attended: false)
        var dict = event.dictValue
        
        let baseRef = Database.database().reference()
        baseRef.child("user_events").child(uid).child(key).updateChildValues(dict)
        let groupKey = HomeViewController.groupSelected!.key
        
        dict["event_attended"] = nil
        baseRef.child("group_events").child(groupKey).child(key).updateChildValues(dict)
        //let dictMutable = dict["event_attended"] = nil
        
        
        ref.updateChildValues(dict)
        let userRef = Database.database().reference().child("user_events").child(uid).child(key)
        userRef.setValue(["event_attended": false])
    
        EventService.populateAllUserEvents(groupKey: groupKey, eventKey: key) { complete in
            if complete {
                self.events.append(event)
            }
            else {
                print("ERROR in populate all user events")
            }
        }
        
    }
    
    static func fillEvents(uid: String, groupKey: String, completion: @escaping ([Event]) -> ()) {
        events = []
        let ref = Database.database().reference().child("group_events").child(groupKey)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print(snapshot)
            for snip in snapshot {
                guard let dict = snip.value as? [String : Any],
                    let name = dict["event_name"] as? String,
                    let date = dict["event_date"] as? String
                    //let attended = dict["event_attended"] as? Bool
                    else { return }
                let key = snip.key
                
                var attendedBool = false
                var event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: attendedBool)
                let userRef = Database.database().reference().child("user_events").child(uid).child(key)
                userRef.observeSingleEvent(of: .value, with: { snapshot in
                    guard let userDict = snapshot.value as? [String: Any],
                    let attended = userDict["event_attended"] as? Bool
                        else {
                            event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: false)
                            events.append(event)
                            completion(events)
                            
                            return }
                    print("Attended: \(attended)")
                    attendedBool = attended
                    //events.remove(at: events.count - 1)
                    event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: attended)
                    events.append(event)
                    completion(events)
                    
                })
            }
            print(events)
            
        })

    }
    
    //will overwrite all attends to false! this should only be used in the create function
    static func populateAllUserEvents(groupKey:String, eventKey: String, completion: @escaping (Bool) -> ()) {
        
        let ref = Database.database().reference().child("group_members").child(groupKey)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print("The group members snapshot is \(snapshot)")
            for snip in snapshot {
                guard let userKey = snip.key as? String
                    else { return }
                
                let ref = Database.database().reference().child("user_events").child(userKey).child(eventKey)
                let dict = ["event_attended": false]
                ref.setValue(dict)
            }
            completion(true)
        })
        
        
    }

    static func attendEvent(eventKey: String, uid: String, completion: @escaping (Event) -> ()) {
        let ref = Database.database().reference().child("user_events").child(uid).child(eventKey)
        let dict = ["event_attended": true]
        ref.setValue(dict)
        let baseRef = Database.database().reference().child("event_attendees").child(eventKey).child(uid)
        
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let userDict = snapshot.value as? [String: String],
            let username = userDict["username"],
            let email = userDict["email"]
            else {
                return
            }
            let userAbout = ["username": username, "email": email]
            baseRef.setValue(userAbout)
            
        })
        
    }
}
