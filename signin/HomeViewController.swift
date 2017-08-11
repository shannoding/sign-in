//
//  HomeViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/13/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    
    
    var user: User!
    
    
    var groupHandle: DatabaseHandle = 0
    var groupRef: DatabaseReference?
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    static var groupSelected: Group? = nil
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        GroupService.fillGroups(uid: User.current.uid) { (groupList) in
//            self.groups = groupList
//            self.groupCollectionView.reloadData()
//        }
        EventService.events = []
        user = user ?? User.current
        self.title = User.current.username
        
        //EventService.populateUserEvents(uid: User.current.uid) { (ok) in
//            print(ok)
//        }
        //logout and go to login screen
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GroupService.fillGroups(uid: User.current.uid) { (groupList) in
            self.groups = groupList
            self.groupCollectionView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Segue your heart out
    @IBAction func unwindToGroupHome(segue:UIStoryboardSegue) {
        self.groups = GroupService.groups
        self.groupCollectionView.reloadData()
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
    @IBAction func unwindToProfileHome(segue:UIStoryboardSegue) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
    @IBAction func unwindToCreateGroupHome(segue:UIStoryboardSegue) { self.groupCollectionView.reloadData()
    self.groups = GroupService.groups
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
    @IBAction func unwindToGroupSearchHome(segue:UIStoryboardSegue) {
        let backItem = UIBarButtonItem()
        backItem.title = "Home"
        navigationItem.backBarButtonItem = backItem
    }
    @IBAction func unwindToGroupAboutHome(segue:UIStoryboardSegue) {
//        self.groups = GroupService.groups
//        self.groupCollectionView.reloadData()
    }
    
    // press that sign out button
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                // firebase sign out and clear groups and user
                try Auth.auth().signOut()
                GroupService.groups = []
                print("The user class should not be an actual user and is \(User.current)")
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
        
    }
    @IBAction func profileButtonPressed(_ sender: UIButton) {
//        GroupService.create(groupName: "group1")
//        GroupService.create(groupName: "group2")
    }
    
    func handleGroupOptionsButtonTap(from cell: GroupImageCell) {
        // 1
        guard let indexPath = groupCollectionView.indexPath(for: cell) else { return }
        
        // 2
        let group = groups[indexPath.item]
        
        //let admins = groups.admin
        // ^doesn't exist yet
        
        // 3
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 4
        //if poster.uid != User.current.uid {
            let flagAction = UIAlertAction(title: "Report as Inappropriate", style: .default) { _ in
                    GroupService.flagGroup(group)
                    
                    let okAlert = UIAlertController(title: nil, message: "The group has been flagged.", preferredStyle: .alert)
                    okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(okAlert, animated: true)

            }
            
            alertController.addAction(flagAction)
        //}
        
        // 5
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 6
        present(alertController, animated: true, completion: nil)    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("There are \(GroupService.groups.count) groups")
        return groups.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupImageCell", for: indexPath) as! GroupImageCell
        
        // collection cell border radius and shadow
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        if indexPath.item < groups.count {
            cell.groupOptionsButton.isHidden = false
            let groupName = groups[indexPath.item].dictValue["group_name"]
            cell.groupLabel.text = groupName
            cell.backgroundColor = RandomColor.chooseWarmColors()
            cell.didTapOptionsButtonForCell = handleGroupOptionsButtonTap(from:)
            
            return cell
        }
        let cellCount = indexPath.item
        if cellCount == groups.count + 1 {
            cell.groupOptionsButton.isHidden = true
            cell.groupLabel.text = "Join Group"
            cell.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
            return cell
        }
        else {
            cell.groupLabel.text = "Create Group"
            cell.groupOptionsButton.isHidden = true
            cell.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 6
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOOKS LIKE YOU TOUCHED GROUP NUMBER \(indexPath.item) MY FRIEND")
        if indexPath.item < groups.count {
            let groupNumber = indexPath.item
            HomeViewController.groupSelected = GroupService.groups[groupNumber]
            performSegue(withIdentifier: "showGroupSegue", sender: self)
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
        else {
            if indexPath.item == groups.count {
                performSegue(withIdentifier: "showCreateGroupSegue", sender: self)
            }
            else {
                performSegue(withIdentifier: "showGroupSearchSegue", sender: self)
                }
            }
            DispatchQueue.main.async {
                self.groupCollectionView.reloadData()
            }
            print("HERE ARE ALL THE GROUPS \(groups)")
            print("RELOADED")
        }
        
    }

