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
        
    
        
        self.events.append(event)
        
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
                
                
                let userRef = Database.database().reference().child("user_events").child(uid).child(key)
                userRef.observeSingleEvent(of: .value, with: { snapshot in
                    guard let userDict = snapshot.value as? [String: Any],
                    let attended = userDict["event_attended"] as? Bool
                        else { return }
                    print("Attended: \(attended)")
                    
                    
                    let event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: attended)
                    print(event)
                    events.append(event)
                    completion(events)
                    
                    })
                
                
                /*let event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: attended)
                print(event)
                events.append(event)
                completion(events)*/
            }
            print(events)
            
        })

    }
    static func attendEvent(eventKey: String, uid: String, completion: @escaping (Event) -> ()) {
        let ref = Database.database().reference().child("user_events/\(uid)/\(eventKey)")
        let dict = ["event_attended": true]
        ref.setValue(dict)
        let baseRef = Database.database().reference()
        baseRef.child("user_events").child(uid).child("\(eventKey)/event_attended").setValue(true)
        let groupKey = HomeViewController.groupSelected!.key
        baseRef.child("group_events").child("\(groupKey)/\(eventKey)/event_attended").setValue(true)
        
    }
}
