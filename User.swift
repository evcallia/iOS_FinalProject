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
    var id: Int
    var longitude: Double
    var latitude: Double
    var name: String
    var phoneNumber: Int
    var email: String
    
    init(id: Int, name: String, email: String, phoneNumber: Int, longitude: Double, latitude: Double){
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.longitude = longitude
        self.latitude = latitude
    }
    
    // Gets users from api
    static func getAllUsers(currentUser: User, completionHandler: @escaping (_ users: [User]) -> () ) {
        var users = [User]()
        let url = NSURL(string: "http://localhost:3000/people")
        let session = URLSession.shared
        let task = session.dataTask(with: url as! URL, completionHandler: {
            data, response, error in
            do {
                if let resultsArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for results in resultsArray {
                        if let user = results as? NSDictionary {
                            if user["id"] as! Int != currentUser.id {
                                users.append(User(id: user["id"] as! Int, name: user["name"]! as! String, email: user["email"]! as! String, phoneNumber: user["phoneNumber"]! as! Int, longitude: user["longitude"]! as! Double , latitude: user["latitude"]! as! Double))
                            }
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
                    newUser = User(id: resultDictionary["id"] as! Int,
                                   name: resultDictionary["name"]! as! String,
                                   email: resultDictionary["email"]! as! String,
                                   phoneNumber: resultDictionary["phoneNumber"]! as! Int,
                                   longitude: resultDictionary["longitude"]! as! Double,
                                   latitude: resultDictionary["latitude"]! as! Double)
                    completionHandler(newUser!)
                }
            } catch {
                print("There was an \(error)")
            }

        })
        task.resume()
    }
//    {"id": "0", "name": "Evan", "email": "evan@gmail.com", "phoneNumber": "1111111111", "longitude": "-122.307508","latitude": "47.664504"}
    
    static func updateUser(user: User){
        var request = URLRequest(url: URL(string: "http://localhost:3000/people/\(user.id)")!)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let put = "name=\(user.name)&email=\(user.email)&phoneNumber=\(user.phoneNumber)&latitude=\(user.latitude)&longitude=\(user.longitude)"
        request.httpBody = put.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if (error != nil) {
                print(error)
            }
        })
        task.resume()
    }

    static func login(email: String, password: String, completionHandler: @escaping (_ user:User) -> Void) {
        var user: User?
        let url = NSURL(string: "http://localhost:3000/people/0")
        let session = URLSession.shared
        let task = session.dataTask(with: url as! URL, completionHandler: {
            data, response, error in
            do {
                if let resultDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    user = User(id: resultDictionary["id"] as! Int,
                                name:  resultDictionary["name"]! as! String,
                                email: resultDictionary["email"]! as! String,
                                phoneNumber: resultDictionary["phoneNumber"]! as! Int,
                                longitude: resultDictionary["longitude"]! as! Double,
                                latitude: resultDictionary["latitude"]! as! Double)
                    completionHandler(user!)
                }
            } catch {
                print("There was an \(error)")
            }
        })
        task.resume()
    }
}














