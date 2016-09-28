//
//  GetAllPeople.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
class PeopleModel {
    static func getAllPeople(completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void ) {
        let url = NSURL(string: "http://localhost:3000/people")
        let session = URLSession.shared
        let task = session.dataTask(with: url! as URL, completionHandler: completionHandler)
        task.resume()
    }
}
