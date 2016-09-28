//
//  RadiusDelegate.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
protocol RadiusDelegate: class {
    func radiusDelegate(_ controller: RadiusViewController, didSet radius: Double)
}
