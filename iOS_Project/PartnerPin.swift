//
//  PartnerPin.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/29/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
import MapKit

class PartnerPin: MKPointAnnotation{
    var pinColor: UIColor
    
    init(title: String, pinColor: UIColor){
        self.pinColor = pinColor
        super.init()
        self.title = title
    }
}
