//
//  CreateGroupViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/24/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var createGroupTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func createGroupButtonTapped(_ sender: UIButton) {
        
        guard let groupName = createGroupTextField.text,
        !groupName.isEmpty
            else {
                
                let alertController = UIAlertController(title: "Incomplete Fields", message:
                    "Please do not leave the group name blank.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
            }

        GroupService.create(groupName: groupName, uid: User.current.uid)
        performSegue(withIdentifier: "unwindToCreateGroupHomeSegue", sender: self)
    }
}