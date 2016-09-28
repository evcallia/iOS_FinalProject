//
//  User.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation

class User{
    var longitude: Double
    var latitude: Double
    var name: String
    var phoneNumber: String
    var email: String
    
    init(name: String, email: String, phoneNumber: String, longitude: Double, latitude: Double){
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.longitude = longitude
        self.latitude = latitude
    }
}
