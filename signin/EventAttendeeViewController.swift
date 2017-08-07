//
//  EventAttendeeViewController.swift
//  signin
//
//  Created by Shannon Ding on 8/4/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class EventAttendeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var attendees: [String] = []

    @IBOutlet weak var eventAttendeeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventService.showAttendees(eventKey: GroupViewController.eventSelected!.key) { (attendeeList) in
            self.attendees = attendeeList
            self.eventAttendeeTableView.reloadData()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventAttendeeTableView.dequeueReusableCell(withIdentifier: "eventAttendeeTableViewCell", for: indexPath) as! EventAttendeeTableViewCell
        cell.attendeeNameLabel.text = attendees[indexPath.row]
        return cell
    }
    
}
