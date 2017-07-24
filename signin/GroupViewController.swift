//
//  GroupViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/21/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

/*import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase


class GroupViewController: UIViewController {
    
    var user: User!
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    var eventHandle: DatabaseHandle = 0
    var eventRef: DatabaseReference?
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    static var groupSelected: Group? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("There are \(GroupService.groups.count) groups")
        return GroupService.groups.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "GroupImageCell", for: indexPath) as! GroupImageCell
        
        
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = true
        
        if indexPath.item < GroupService.groups.count {
            let groupName = GroupService.groups[indexPath.item].dictValue["group_name"]
            cell.groupLabel.text = groupName
            cell.backgroundColor = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
            
            return cell
        }
        let cellCount = indexPath.item
        if cellCount == GroupService.groups.count + 1 {
            cell.groupLabel.text = "Join Group"
            return cell
        }
        else {
            cell.groupLabel.text = "Create Group"
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
        if indexPath.item < GroupService.groups.count {
            let groupNumber = indexPath.item
            //groupSelected = GroupService.groups[groupNumber]
        }
        else {
            if indexPath.item == GroupService.groups.count {
                GroupService.create(groupName: "ANOTHERGROUP", uid: User.current.uid)
            }
            DispatchQueue.main.async {
                self.eventCollectionView.reloadData()
            }
            print("RELOADED PEW PEW")
        }
        
    }
}*/
