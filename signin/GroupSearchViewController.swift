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
    
    var searchActive : Bool = false
    var data: [String] = []
    var filtered:[String] = []
    
    override func viewDidLoad() {
        
        GroupService.searchGroupArray() { groupArray in
            self.data = groupArray
            
        }
        
        groupSearchTableView.delegate = self
        groupSearchTableView.dataSource = self
        groupSearchBar.delegate = self
        super.viewDidLoad()
    
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            
            let tmp = text.lowercased()
            let range = tmp.range(of: searchText.lowercased())
            if let range = range {
                return true

            }
            else {
                return false
            }
            /*let tmp:NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound*/
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.groupSearchTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = groupSearchTableView.dequeueReusableCell(withIdentifier: "groupSearchTableViewCell", for: indexPath) as! GroupSearchTableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
}
