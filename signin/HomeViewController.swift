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
    
        GroupService.fillGroups(uid: User.current.uid) { (groupList) in
            self.groups = groupList
            self.groupCollectionView.reloadData()
        }
        
        user = user ?? User.current
        
        
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProfileHome(segue:UIStoryboardSegue) { }
    @IBAction func unwindToCreateGroupHome(segue:UIStoryboardSegue) { self.groupCollectionView.reloadData()
    self.groups = GroupService.groups }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
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
    
    
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("There are \(GroupService.groups.count) groups")
        return groups.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupImageCell", for: indexPath) as! GroupImageCell
        
        
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = true
        
        if indexPath.item < groups.count {
            let groupName = groups[indexPath.item].dictValue["group_name"]
            cell.groupLabel.text = groupName
            cell.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
            
            return cell
        }
        let cellCount = indexPath.item
        if cellCount == groups.count + 1 {
            cell.groupLabel.text = "Join Group"
            return cell
        }
        else {
            cell.groupLabel.text = "Create Group"
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOOKS LIKE YOU TOUCHED GROUP NUMBER \(indexPath.item) MY FRIEND")
        if indexPath.item < groups.count {
            let groupNumber = indexPath.item
            //groupSelected = GroupService.groups[groupNumber]
        }
        else {
            if indexPath.item == groups.count {
                performSegue(withIdentifier: "createGroupSegue", sender: self)
            }
            DispatchQueue.main.async {
                self.groupCollectionView.reloadData()
            }
            print("HERE ARE ALL THE GROUPS \(groups)")
            print("RELOADED")
        }
        
    }
}
