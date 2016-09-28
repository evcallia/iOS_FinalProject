//
//  SelectPartnerDelegate.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
protocol SelectPartnerDelegate: class {
    func selectPartnerDelegate(_ controller: SelectPartnerViewController, didSelect partner: User)
}
