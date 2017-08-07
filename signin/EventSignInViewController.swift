//
//  EventSignInViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/26/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

class EventSignInViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.text = User.current.username
        emailTextField.text = User.current.email
        eventDateLabel.text = GroupViewController.eventSelected!.date
            eventNameLabel.text = GroupViewController.eventSelected!.name
        
        if GroupViewController.eventSelected!.attended {
            self.signInButton.setTitle("Signed In!", for: .normal)
            self.signInButton.backgroundColor = RandomColor.green
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        GroupViewController.eventSelected!.attended = true
        EventService.attendEvent(eventKey: GroupViewController.eventSelected!.key, uid: User.current.uid) { (event) in
            
        }
        self.signInButton.setTitle("Signed In!", for: .normal)
        self.signInButton.backgroundColor = RandomColor.green
        performSegue(withIdentifier: "unwindToSignInHomeSegue", sender: self)
    
    }
}
