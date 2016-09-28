//
//  User.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//
import UIKit
import MapKit

class User {
    
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
    
    
    
    static func getAllUsers(completionHandler: @escaping (_ users: [User]) -> () ) {
//        let url = NSURL(string: "http://localhost:3000/people")
//        let session = URLSession.shared
//        let task = session.dataTask(with: url! as URL, completionHandler: completionHandler)
//        task.resume()
        var users = [User]()
        let url = NSURL(string: "http://localhost:3000/people")
        let session = URLSession.shared
        let task = session.dataTask(with: url as! URL, completionHandler: {
            data, response, error in
            do {
                if let resultsArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for results in resultsArray {
                        if let user = results as? NSDictionary {
                            users.append(User(name: user["name"]! as! String, email: user["email"]! as! String, phoneNumber: user["phoneNumber"]! as! String, longitude: Double(user["longitude"]! as! String)!, latitude: Double(user["latitude"]! as! String)!))
                        }
                    }
                    completionHandler(users)
                }
            } catch {
                print("There was an \(error)")
            }
        })
        task.resume()
    }
    
    
    
    // json
//    PeopleModel.getAllPeople() {
//        data, response, error in
//        do {
//            if let users = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                for user in users.people {
//    self.peopleArr.append((user as! NSDictionary)["name"] as! String)
//    }
//    print(self.peopleArr)
//    }
//    } catch {
//    print ("ERROR")
//    }
//    }
}
