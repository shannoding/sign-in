//
//  GroupAboutViewController.swift
//  signin
//
//  Created by Shannon Ding on 8/7/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class GroupAboutViewController: UIViewController {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var leaveGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameLabel.text = HomeViewController.groupSelected!.name
        self.leaveGroupButton.backgroundColor = RandomColor.red
    }
    
    @IBAction func leaveGroupButtonTapped(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Leave group?", message: "Group will be removed from Home.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            UserService.leaveGroup(uid: User.current.uid, groupKey: HomeViewController.groupSelected!.key)
            HomeViewController.groupSelected = nil
            self.performSegue(withIdentifier: "unwindToGroupAboutHome", sender: self)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    
}
