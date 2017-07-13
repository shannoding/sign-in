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
    
    @IBOutlet weak var enterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {

        
//        if Auth.auth().currentUser != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: .main)
//            
//            if let initialViewController = storyboard.instantiateInitialViewController() {
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
//                self.performSegue(withIdentifier: "showHomeSegue", sender: self)
//        } else {
                guard let authUI = FUIAuth.defaultAuthUI()
                    else { return }
                
                // 2
                authUI.delegate = self
                
                // 3
                let authViewController = authUI.authViewController()
                present(authViewController, animated: true)
            //}
      //  }

    }
    
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
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
                print("Welcome back, \(user.username).")
                 User.setCurrent(user)
            } else {
                print("New user!")
                
                guard let firUser = Auth.auth().currentUser,
                    let username = firUser.displayName,
                    !username.isEmpty else { return }
                
                
                // 4
                UserService.createUser(firUser, username: username) { (user) in
                    guard let user = user else { return }
                print("Created new user, \(user.username)")
                     User.setCurrent(user)
                }
            }
        })
    }
}
