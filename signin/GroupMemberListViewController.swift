//
//  GroupMemberListViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/31/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit

class GroupMemberListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var members: [String] = []
    @IBOutlet weak var groupMemberTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GroupService.showMembers(groupKey: HomeViewController.groupSelected!.key) { (memberList) in
            self.members = memberList
            self.groupMemberTableView.reloadData()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groupMemberTableView.dequeueReusableCell(withIdentifier: "groupMemberTableViewCell", for: indexPath) as! GroupMemberTableViewCell;
        cell.memberNameLabel.text = members[indexPath.row]
        return cell;
    }

}
