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
    
    @IBOutlet weak var groupLabel: UILabel!
    
    var user: User!
    //var groups = [Group]()
    
    var groupHandle: DatabaseHandle = 0
    var groupRef: DatabaseReference?
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        user = user ?? User.current
        
        /*groupHandle = GroupService.observeProfile(for: user) { [unowned self] (ref, user, groups) in
            self.groupRef = ref
            self.user = user
            self.groups = groups
            
            DispatchQueue.main.async {
                self.groupCollectionView.reloadData()
            }
        }*/
        
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
        return GroupService.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupImageCell", for: indexPath) as! GroupImageCell
        //cell.groupLabel.text = Database.database().reference().child("groups_joined").child(User.current.uid).child(GroupService.groups[0].key).child("group_name").value
        cell.groupLabel.text = GroupService.groups[indexPath.item].dictValue["group_name"]
        cell.backgroundColor = .red
        return cell
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
