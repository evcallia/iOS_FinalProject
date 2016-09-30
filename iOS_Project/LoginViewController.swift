//
//  LoginViewController.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/29/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RegisterViewControllerDelegate {
    
    var user: User?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
// MARK: - RegisterViewControllerDelegate functions
    func registerViewController(_ controller: RegisterViewController, didCreate user: User){
        dismiss(animated: true, completion: {
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "Login", sender: user)
            }
        })
    }
//**********
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        User.login(email:emailTextField.text!, password: passwordTextField.text!, completionHandler: {
            user in
            self.user = user
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        })
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Register"{
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! RegisterViewController
            controller.delegate = self
        }else if segue.identifier == "Login"{
            let controller = segue.destination as! SearchMapViewController
            controller.currentUser = user!
        }
    }
}
















