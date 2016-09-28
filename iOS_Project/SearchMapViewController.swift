//
//  ViewController.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/27/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

// MARK: - Class variables
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var longitude = Double()
    var latitude = Double()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//**********
    
    
// MARK: - Start up functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up map and getting location
        map.delegate = self
        self.map.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let myLocation = self.locationManager.location
        let location = CLLocationCoordinate2D(latitude: (myLocation?.coordinate.latitude)!, longitude: (myLocation?.coordinate.longitude)!)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        //get other user location
        getUsersInRadius(distance: 3.0)
    }
//**********
    
    func getUsersInRadius(distance: Double){
        var usersWithin = [User]()
        
        placePins(users: usersWithin)
    }
    
    func placePins(users: [User]){
        for user in users{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
            annotation.coordinate = coordinate
            annotation.title = user.name
            annotation.subtitle = user.phoneNumber
            map.addAnnotation(annotation)
        }
    }
    
// MARK: - Map Functions
    //Select Person on the map
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //show tooltip
        //save person in class variable
    }
//*********
    
    
// Mark: - Pressed button functions
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func setLocationPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func threeMilesPressed(_ sender: UIButton) {
    }
    
    @IBAction func fiveMilesPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func tenMilesPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func setRadiusPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SetRadius", sender: self)
    }
//**********
    

// MARK: - Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetRadius"{
            //SET DELEGATES
        }
    }//**********
}













