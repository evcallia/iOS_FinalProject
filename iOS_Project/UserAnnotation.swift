//
//  UserAnnotation.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class UserAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var user: User
    var radius: Double
    var pinColor: UIColor
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, user: User, radius: Double, pinColor: UIColor) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.user = user
        self.radius = radius
        self.pinColor = pinColor
    }
    
}
