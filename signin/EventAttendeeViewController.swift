//
//  EventAttendeeViewController.swift
//  signin
//
//  Created by Shannon Ding on 8/4/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import MessageUI

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
    @IBAction func emailListButton(_ sender: UIBarButtonItem) {
        sendEmail()
        
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


// email sending stuff
extension EventAttendeeViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: "Feature Doesn't Exist", message:
                "Email doesn't work yet :(", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["shannonding2@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            let alertController = UIAlertController(title: "Email Not Supported", message:
                "Cannot email message on your device.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
