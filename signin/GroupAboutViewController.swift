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
        self.leaveGroupButton.backgroundColor = RandomColor.red
    }
    
    @IBAction func leaveGroupButtonTapped(_ sender: UIButton) {
    }
    
}
