//
//  LoginViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/6/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase


class LoginViewController: UIViewController {
    

    @IBOutlet weak var headerBackgroundView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        headerBackgroundView.backgroundColor = RandomColor.green
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        print("enter button pressed")
        let user = Auth.auth().currentUser
        if let user = user {
            print("\(user)")
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
                
                self.performSegue(withIdentifier: "showHomeSegue", sender: self)
        }
            
            else {
                guard let authUI = FUIAuth.defaultAuthUI()
                    else { return }
                
                // 2
                authUI.delegate = self
                // 3
                let authViewController = authUI.authViewController()
                present(authViewController, animated: true)
        }
        

    }
    
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        print("into authui")
        if let error = error {
            //assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // 1
        guard let user = user
            else { return }
        
        // 2
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // 3
        
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print(user)
                print("Welcome back, \(user.username).")
                User.setCurrent(user, writeToUserDefaults: true)
                print("Welcome back pt. 2, \(User.current.username)")
                //self.enterButton.setTitle("ENTER", for: .normal)
                self.performSegue(withIdentifier: "showHomeSegue", sender: self)
            } else {
                print("New user!")
                
                guard let firUser = Auth.auth().currentUser,
                    let username = firUser.displayName,
                    let email = firUser.email,
                    !username.isEmpty || !email.isEmpty else { return }
                
                    UserService.createUser(firUser, username: username, email: email) { (user) in
                    guard let user = user else { return }
                    print("Created new user, \(user.username)")
                    User.setCurrent(user, writeToUserDefaults: true)
                    print("Created new user pt. 2, \(User.current.username)")
                    self.performSegue(withIdentifier: "showHomeSegue", sender: self)
                }
            }
        })
    }
}
