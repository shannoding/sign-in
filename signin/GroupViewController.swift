//
//  GroupViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/21/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase


class GroupViewController: UIViewController {
    
    var user: User!
    static var eventSelected: Event? = nil
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var eventForLabel: UILabel!
    
    var eventHandle: DatabaseHandle = 0
    var eventRef: DatabaseReference?
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = user ?? User.current
        self.title = HomeViewController.groupSelected!.name
        
        self.eventForLabel.text = "Events for \(HomeViewController.groupSelected!.name)"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = []
        EventService.fillEvents(uid: User.current.uid, groupKey: HomeViewController.groupSelected!.key) { (eventList) in
            self.events = eventList
            print("The events are \(self.events)")
            self.eventCollectionView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToCreateEventHome(segue: UIStoryboardSegue) {
        self.events = []
        self.events = EventService.events
        self.eventCollectionView.reloadData()
        let backItem = UIBarButtonItem()
        backItem.title = "Group"
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func unwindToSignInHome(segue: UIStoryboardSegue) {
        self.events = EventService.events
        self.eventCollectionView.reloadData()
        let backItem = UIBarButtonItem()
        backItem.title = "Group"
        navigationItem.backBarButtonItem = backItem
    }
    
}

extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are \(events.count) plus one events")
        return events.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        
        
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        
        if indexPath.item < events.count {
            let eventName = events[indexPath.item].dictValue["event_name"]
            cell.eventLabel.text = eventName as! String
            let eventAttended = events[indexPath.item].dictValue["event_attended"] as! Bool
            if eventAttended {
                cell.backgroundColor = RandomColor.green
            }
            else {
                cell.backgroundColor = RandomColor.chooseCoolColors()
            }
            
            return cell
        }
        else {
            cell.eventLabel.text = "Create Event"
            cell.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
            return cell
        }
    }
}

extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 3
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

extension GroupViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOOKS LIKE YOU TOUCHED GROUP NUMBER \(indexPath.item) MY FRIEND")
        if indexPath.item < events.count {
            let eventNumber = indexPath.item
            GroupViewController.eventSelected = EventService.events[eventNumber]
            performSegue(withIdentifier: "showSignInSegue", sender: self)
        }
        else {
            performSegue(withIdentifier: "showCreateEventSegue", sender: self)
            print("Create Event Tapped")
            DispatchQueue.main.async {
                self.eventCollectionView.reloadData()
            }
            print("HERE ARE ALL THE EVENTS \(events)")
            print("RELOADED")
        }
        
    }
}
