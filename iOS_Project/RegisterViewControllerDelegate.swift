//
//  RegisterViewControllerDelegate.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/29/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
protocol RegisterViewControllerDelegate: class {
    var user: User? {get set}
    func registerViewController(_ controller: RegisterViewController, didCreate user: User)
}
