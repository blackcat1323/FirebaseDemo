//
//  LoginViewController.swift
//  FirebaseDemo
//
//  Created by admin on 3/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLoginPassword.isSecureTextEntry = true
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil{
                self.performSegue(withIdentifier: "LoginToList", sender: nil)
            }
        })
        // Do any additional setup after loading the view.
    }
    @IBAction func loginDidTouch(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: txtLoginEmail.text!,
                               password: txtLoginPassword.text!)
    }
    
    @IBAction func signupDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        let actSave = UIAlertAction(title: "Save", style: .default) { (action) in
            let txtEmail = alert.textFields![0]
            let txtPass     = alert.textFields![1]
            
            FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPass.text!, completion: { (user, error) in
                if error == nil{
                    FIRAuth.auth()?.signIn(withEmail: self.txtLoginEmail.text!, password: self.txtLoginPassword.text!, completion: nil)
                }
            })
        }
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { (textPassword) in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        alert.addAction(actSave)
        alert.addAction(actCancel)
        present(alert, animated: true, completion: nil)
    }
}
