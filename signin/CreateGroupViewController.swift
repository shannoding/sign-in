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
    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var createGroupTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        createGroupTextField.addTarget(self, action: #selector(checkMaxLength(_ :)), for: .editingChanged)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkMaxLength(_ textField: UITextField!) {
        if (textField.text!.characters.count > 50) {
            textField.deleteBackward()
        }
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
        print("About to create the group, \(groupName)")
        GroupService.create(groupName: groupName, uid: User.current.uid)
        let createdGroup = GroupService.groups[GroupService.groups.count - 1]
        UserService.joinGroup(uid: User.current.uid, groupKey: createdGroup.key, completion: {(createdGroup) in
            print("About to segue back to home from Create Group")
            self.createGroupButton.setTitle("Created Group!", for: .normal)
            self.createGroupButton.backgroundColor = RandomColor.green
            self.performSegue(withIdentifier: "unwindToCreateGroupHomeSegue", sender: self)
            print("Did unwindToCreateGroupHomeSegue")
        }
        )
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }

}
