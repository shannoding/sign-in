//
//  EmailAttendeeListViewController.swift
//  signin
//
//  Created by Shannon Ding on 8/9/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import UIKit

class EmailAttendeeListViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var messageTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = User.current.email
    }
    
}
