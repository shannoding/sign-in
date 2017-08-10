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
                //EventService.events.append(event)
            }
            else {
                print("ERROR in populate all user events")
            }
        }
        
    }
    
    static func fillEvents(uid: String, groupKey: String, completion: @escaping ([Event]) -> ()) {
        EventService.events = []
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
//                            event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: false)
//                            events.append(event)
//                            completion(events)
//                            
                            return
                    }
                    print("Attended: \(attended)")
                    attendedBool = attended
                    //events.remove(at: events.count - 1)
                    event = Event(key: key, name: name, groupOf: groupKey, date: date, attended: attended)
                    EventService.events.append(event)
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
    static func populateNewUserEvents(groupKey:String, uid: String, completion: @escaping (Bool) -> ()) {
        
        let ref = Database.database().reference().child("group_events").child(groupKey)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print("The group members snapshot is \(snapshot)")
            for snip in snapshot {
                guard let eventKey = snip.key as? String
                    else { return }
                
                let ref = Database.database().reference().child("user_events").child(uid).child(eventKey)
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
    static func showAttendees(eventKey: String, completion: @escaping ([String]) -> ()) {
        var attendeeArray: [String] = []
        let ref = Database.database().reference().child("event_attendees").child(eventKey)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            print("The group members snapshot is \(snapshot)")
            for snip in snapshot {
                guard let dict = snip.value as? [String: String],
                    let username = dict["username"]
                    else { return }
                attendeeArray.append(username)
            }
            completion(attendeeArray)
            print("The attendee data is \(attendeeArray)")
        })
    }
    static func flagEvent(_ event: Event) {
        // 1
        let eventKey = event.key
        
        // 2
        let flaggedEventRef = Database.database().reference().child("flagged_events").child(eventKey)
        
        
        let groupName = event.name
        let flaggedDict = ["event_name": groupName,
                           "admins": ["this", "doesn't", "exist", "yet"],
                           "reporter_uid": User.current.uid] as [String : Any]
        
        // 4
        flaggedEventRef.updateChildValues(flaggedDict)
        
        // 5
        let flagCountRef = flaggedEventRef.child("flag_count")
        flagCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        })
    }
    static func dateDiff(dateStr:String) -> Int {

        let start = dateStr.index(dateStr.startIndex, offsetBy: 4)
        let end = dateStr.index(dateStr.endIndex, offsetBy: -10)
        let range = start..<end
        
        var eventDay = Int(dateStr.substring(with: range))
        
        let date = Date()
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: date)
        guard let eDay = eventDay
            else { return -1 }
        if eDay < currentDay {
            return currentDay - eDay
        }
        else {
            return eDay - currentDay + 30
        }

//        var f:DateFormatter = DateFormatter()
//        f.timeZone = NSTimeZone.local
//        f.dateFormat = "MMM dd, hh:mm a"
//        
//        var now = f.string(from: NSDate() as Date)
//        var startDate = f.date(from: dateStr)
//        var endDate = f.date(from: now)
//        var calendar: NSCalendar = NSCalendar.current as NSCalendar
//        
//        let calendarUnits = NSCalendar.Unit.hour
//        let dateComponents = calendar.components(calendarUnits, fromDate: startDate!, toDate: endDate!, options: nil)
//        
//        let hours = abs(dateComponents.hour)
//        
//        var hoursAgo = 0
//        
//        if(hours >= 0){
//            hoursAgo = hours
//            
//        }
//        print("hoursAgo is ===> \(hoursAgo)")
//        return hoursAgo
    }
    
    static func autoEventDelete(uid: String, groupKey: String) {
        
        let groupEventsRef = Database.database().reference().child("group_events").child(groupKey)
        groupEventsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            // gets event key for each event in group
            for snip in snapshot {
                let eventKey = snip.key
                // uses event key to get date
                let eventDateRef = Database.database().reference().child("events_about").child(eventKey).child("event_date")
                eventDateRef.observeSingleEvent(of: .value, with: { (snipshot) in
                    guard let eventDate = snipshot.value as? String
                        else { return }
                    // gets the time passed
                    let eventDateDiff = EventService.dateDiff(dateStr: eventDate)
                    // auto deletes the event if it's over a week old
                    if eventDateDiff > 168 {
                        // deletes the event from everywhere
                        let eventRef = Database.database().reference().child("events_about").child(eventKey)
                        eventRef.setValue(nil)
                        let eventAttendeeRef = Database.database().reference().child("event_attendees").child(eventKey)
                        eventAttendeeRef.setValue(nil)
                        let eventFlaggedRef = Database.database().reference().child("flagged_events").child(eventKey)
                        eventFlaggedRef.setValue(nil)
                        let groupEventsRef = Database.database().reference().child("group_events").child(groupKey).child(eventKey)
                        groupEventsRef.setValue(nil)
                        let userEventsRef = Database.database().reference().child("user_events").child(uid).child(eventKey)
                        userEventsRef.setValue(nil)
                    }
                })
                
        }
            
        })
    }

}
