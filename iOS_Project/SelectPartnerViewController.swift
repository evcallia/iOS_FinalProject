//
//  SelectPartnerViewController.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import UIKit

class SelectPartnerViewController: UIViewController {

    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var emailLabel: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    weak var partner: User?
    weak var delegate: SelectPartnerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
