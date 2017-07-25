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
        let event = Event(key: key, name: eventName, groupOf: groupKey, date: eventTime)
        let dict = event.dictValue
        
        ref.updateChildValues(dict)
        
        let baseRef = Database.database().reference()
        baseRef.child("events_attended").child(uid).child(key).updateChildValues(dict)
        let groupKey = HomeViewController.groupSelected!.key
        baseRef.child("group_events").child(groupKey).child(key).updateChildValues(dict)
        
        self.events.append(event)
        
    }
    
    static func fillEvents(groupKey: String, completion: @escaping ([Event]) -> ()) {
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
                    else { return }
                let key = snip.key
                let event = Event(key: key, name: name, groupOf: groupKey, date: date)
                print(event)
                events.append(event)
                completion(events)
            }
            print(events)
            
        })

    }
}
