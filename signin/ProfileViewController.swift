//
//  ProfileViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/11/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            nameTextField.text = User.current.username
            emailTextField.text = User.current.email
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveProfileButtonPressed(_ sender: UIButton) {
        print("save profile button pressed")
        let firUser = Auth.auth().currentUser
        guard let inputUsername = nameTextField.text,
        let inputEmail = emailTextField.text,
        !inputUsername.isEmpty,
        !inputEmail.isEmpty
            else {
                
                    let alertController = UIAlertController(title: "Incomplete Fields", message:
                    "Please fill in the name and email fields.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
        UserService.updateUser(firUser!, username: inputUsername, email: inputEmail, completion: { (user) in
            guard let user = user else { return }
            User.current.username = inputUsername
            User.current.email = inputEmail
            print("Updated username to \(User.current.username) and email to \(User.current.email)")
            //User.setCurrent(user)
        })
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToProfileHome", sender: self)
    }
    
    
}
