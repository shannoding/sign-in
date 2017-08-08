//
//  GroupSearchViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/28/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import UIKit

class GroupSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var groupSearchBar: UISearchBar!
    @IBOutlet weak var groupSearchTableView: UITableView!
    
    
    //let groupSearchController = UISearchController(searchResultsController: nil)
    
    var searchActive : Bool = false
    var data = [Group]()
    var filtered = [Group]()
//    var data: [String] = []
//    var filtered:[String] = []

    
    override func viewDidLoad() {
        
//        GroupService.searchGroupArray() { groupArray in
//            self.data = groupArray
//            
//        }
    
        
        groupSearchTableView.delegate = self
        groupSearchTableView.dataSource = self
        groupSearchBar.delegate = self
        
        
        //groupSearchController.searchResultsUpdater = self
        //groupSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //groupSearchTableView.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        GroupService.searchGroup() { (groupList) in
            self.data = groupList
            self.groupSearchTableView.reloadData()
        }
            super.viewWillAppear(animated)
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(groupSearchController.isActive)
        //if groupSearchController.isActive && 
        if groupSearchBar.text != "" {
            return filtered.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupSearchTableView.dequeueReusableCell(withIdentifier: "groupSearchTableViewCell", for: indexPath) as! GroupSearchTableViewCell
        
        let groupSearched: Group
        
        //if groupSearchController.isActive && 
        if groupSearchBar.text != "" {
            groupSearched = filtered[indexPath.row]
        }
        else {
            groupSearched = data[indexPath.row]
        }
        cell.groupNameLabel.text = groupSearched.name
        return cell
    }
    
    
    
    // MARK: - Search functions

    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filtered = data.filter { group in
            return group.name.lowercased().contains(searchText.lowercased()) //range(of: searchText.lowercased()) != nil
        }
        groupSearchTableView.reloadData()

    }

    
    // MARK: - Segues
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if groupSearchController.isActive && 
        if groupSearchBar.text != "" {
            let groupSearched = filtered[indexPath.row]
            UserService.joinGroup(uid: User.current.uid, groupKey: groupSearched.key) { (groupJoined) in
                HomeViewController.groupSelected = groupJoined
                print("Groups joined is \(groupJoined)")
                print("The group selected from joining is \(HomeViewController.groupSelected)")
                self.view.endEditing(true)
                self.performSegue(withIdentifier: "showGroupFromSearchSegue", sender: self)
            }
        }
        else {
            let groupSearched = data[indexPath.row]
            
            UserService.joinGroup(uid: User.current.uid, groupKey: groupSearched.key) { (groupJoined) in
                HomeViewController.groupSelected = groupJoined
                print("Groups joined is \(groupJoined)")
                print("The group selected from joining is \(HomeViewController.groupSelected)")
                self.view.endEditing(true)
                self.performSegue(withIdentifier: "showGroupFromSearchSegue", sender: self)
            }

        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchBar.text!)
    }


}
