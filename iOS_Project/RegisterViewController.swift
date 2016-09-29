//
//  RegisterViewController.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/29/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: RegisterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let user = [nameTextField.text!, emailTextField.text!, phoneNumberTextField.text!]
        
        User.addUser(user: user, completionHandler: {
            user in
            self.delegate?.user = user
            self.delegate?.registerViewController(self, didCreate: user)
        })
    }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Register"{
            let controller = segue.destination as! SearchMapViewController
            controller.currentUser = sender as? User
        }
    }
}
