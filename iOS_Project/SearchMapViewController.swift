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

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CancelButtonDelegate, RadiusDelegate, SelectPartnerDelegate {

// MARK: - Class variables
    @IBOutlet weak var map: MKMapView!
    var users = [User]()
    var usersWithin = [User]()
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//**********
    
    
// MARK: - Start up functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up map and getting location (EVAN)
//        map.delegate = self
//        self.map.showsUserLocation = true
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        let myLocation = self.locationManager.location
//        let location = CLLocationCoordinate2D(latitude: (myLocation?.coordinate.latitude)!, longitude: (myLocation?.coordinate.longitude)!)
//        let span = MKCoordinateSpanMake(0.5, 0.5)
//        let region = MKCoordinateRegion(center: location, span: span)
//        map.setRegion(region, animated: true)
        
        // Setting up map and getting location (JEFF)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        
        //get other user location
        getAllUsers()
       
    }
//**********
    
    
    func getAllUsers(){
        User.getAllUsers(completionHandler: {
            users in
            self.users = users
            DispatchQueue.main.async (execute: {
                self.getUsersInRadius(distance: 3.0)
            })
        })
    }
    
    func getUsersInRadius(distance: Double){
        usersWithin = [User]()
        for user in users{
            let location = CLLocation(latitude: user.latitude, longitude: user.longitude)
            let myLocation = self.locationManager.location
            let distanceBetween = (myLocation?.distance(from: location))! / 1609.344
            if distanceBetween <= distance{
                usersWithin.append(user)
            }
        }
        showCircle(coordinate: (self.locationManager.location?.coordinate)!, radius: distance)
        placePins(users: usersWithin)
    }
    
    func placePins(users: [User]){
        map.removeAnnotations(map.annotations)
        for user in users{
//            let annotation = MKPointAnnotation()
//            let coordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
//            annotation.coordinate = coordinate
//            annotation.title = user.name
//            annotation.subtitle = user.phoneNumber
//            map.addAnnotation(annotation)
            
            let annotation = UserAnnotation(title: user.name, coordinate: CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude), info: user.phoneNumber)
            map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "UserAnnotation"
        if annotation is UserAnnotation {
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                view.annotation = annotation
                return view
            } else {
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.isEnabled = true
                view.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = btn as UIView
                return view
            }
        }
        return nil
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        print("here")
//        if annotation is MKUserLocation {
//            return nil
//        }
//        
//        let reuseID = "pin"
//        
//        return nil
//    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let user = view.annotation as! UserAnnotation
        let name = user.title
        let phoneNumber = user.info
        
        let ac = UIAlertController(title: name, message: phoneNumber, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance){
        let circle = MKCircle(center: coordinate, radius: (radius * 1609.344) as CLLocationDistance)
        map.add(circle)
    }
    
// MARK: - Map Functions
    //Select Person on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //save person in class variable
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.25, longitudeDelta:0.25))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.fillColor = UIColor.red
        circle.alpha = 0.1
        circle.lineWidth = 1
        circle.strokeColor = UIColor.red
        return circle
    }
//*********
    
    
// Mark: - Pressed button functions
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {

    }
    
    @IBAction func threeMilesPressed(_ sender: UIButton) {
        self.getUsersInRadius(distance: 3.0)
    }
    
    @IBAction func fiveMilesPressed(_ sender: UIButton) {
        self.getUsersInRadius(distance: 5.0)
    }
    
    @IBAction func tenMilesPressed(_ sender: UIButton) {
        self.getUsersInRadius(distance: 10.0)
    }
    
    @IBAction func setRadiusPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "SetRadius", sender: self)
    }
//**********
    

// MARK: - Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetRadius"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! RadiusViewController
            controller.cancel = self
            controller.delegate = self
        }
        if segue.identifier == "SelectPartner" {
            let controller = segue.destination as! SelectPartnerViewController
            controller.delegate = self
            // CHANGE SO YOU SELECT PARTNER FROM PIN
//            controller.partner = user
        }
    }//**********
    
    func radiusDelegate(_ controller: RadiusViewController, didSet radius: Double) {
        dismiss(animated: true, completion: nil)
        self.getUsersInRadius(distance: radius)
    }
    
    func selectPartnerDelegate(_ controller: SelectPartnerViewController, didSelect partner: User) {
        
    }
    
    func cancelButtonPressedFrom(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}













