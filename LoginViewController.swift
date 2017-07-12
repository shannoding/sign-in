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
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        print("handle user signup / login")
    }
}

