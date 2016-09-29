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
    var id: String
    var longitude: Double
    var latitude: Double
    var name: String
    var phoneNumber: String
    var email: String
    
    init(id: String, name: String, email: String, phoneNumber: String, longitude: Double, latitude: Double){
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Gets users from api
    static func getAllUsers(completionHandler: @escaping (_ users: [User]) -> () ) {
        var users = [User]()
        let url = NSURL(string: "http://localhost:3000/people")
        let session = URLSession.shared
        let task = session.dataTask(with: url as! URL, completionHandler: {
            data, response, error in
            do {
                if let resultsArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for results in resultsArray {
                        if let user = results as? NSDictionary {
                            users.append(User(id: user["id"] as! String, name: user["name"]! as! String, email: user["email"]! as! String, phoneNumber: user["phoneNumber"]! as! String, longitude: Double(user["longitude"]! as! String)!, latitude: Double(user["latitude"]! as! String)!))
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
    
    // adds new user to database
    static func addUser(user: [String], completionHandler: @escaping (_ user: User) -> Void){
        var newUser: User?
        var request = URLRequest(url: URL(string: "http://localhost:3000/people")!)
        request.httpMethod = "POST"
        let post = "name=\(user[0])&email=\(user[1])&phoneNumber=\(user[2])&longitude=-122.307508&latitude=47.664504"
        request.httpBody = post.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, reponse, error in
            do {
                if let resultDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    newUser = User(id: resultDictionary["id"] as! String,
                                   name: resultDictionary["name"]! as! String,
                                   email: resultDictionary["email"]! as! String,
                                   phoneNumber: resultDictionary["phoneNumber"]! as! String,
                                   longitude: Double(resultDictionary["longitude"]! as! String)!,
                                   latitude: Double(resultDictionary["latitude"]! as! String)!)
                    completionHandler(newUser!)
                }
            } catch {
                print("There was an \(error)")
            }

        })
        task.resume()
    }
//    {"id": "0", "name": "Evan", "email": "evan@gmail.com", "phoneNumber": "1111111111", "longitude": "-122.307508","latitude": "47.664504"}
    
    static func updateUser(user: User, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        var request = URLRequest(url: URL(string: "http://localhost:3000/people/\(user.id)")!)
        request.httpMethod = "PUT"
        let put = "latitude=\(user.latitude)&longitude=\(user.longitude)"
        request.httpBody = put.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}














