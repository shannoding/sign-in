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
    //var authHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
//            guard user == nil else { return }
//            
//            let loginViewController = UIStoryboard.initialViewController(for: .login)
//            self.view.window?.rootViewController = loginViewController
//            self.view.window?.makeKeyAndVisible()
//       }
//    }
//    deinit {
//        if let authHandle = authHandle {
//            Auth.auth().removeStateDidChangeListener(authHandle)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToProfileHome(segue:UIStoryboardSegue) { }
    
//    @IBAction func signOutButtonPressed(_ sender: UIButton) {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
//            print("log out user")
//        }
//        alertController.addAction(signOutAction)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        
//        present(alertController, animated: true)
//    }

}
