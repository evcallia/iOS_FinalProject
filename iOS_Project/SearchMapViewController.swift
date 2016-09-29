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

class SearchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, CancelButtonDelegate, RadiusViewControllerDelegate {

// MARK: - Class variables
    @IBOutlet weak var map: MKMapView!
    @IBOutlet var lowerButtons: [UIButton]!
    @IBOutlet weak var selectUserButton: UIBarButtonItem!
    var users = [User]()
    var usersWithin = [User]()
    let locationManager = CLLocationManager()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//**********
    
    
// MARK: - Page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectUserButton.isEnabled = false
        
        // Setting up map and getting location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
        self.map.delegate = self
       
        //get other user location
        getAllUsers()
    }
//**********
    
    
// Mark: - Custom functions
    //grabs all users from database
    func getAllUsers(){
        User.getAllUsers(completionHandler: {
            users in
            self.users = users
            DispatchQueue.main.async (execute: {
                self.getUsersInRadius(distance: 3.0)
            })
        })
    }
    
    // filters users within search radius
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
        placePins(users: usersWithin, radius: distance)
    }
    
    // Adds search radius overlay to map
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance){
        let circle = MKCircle(center: coordinate, radius: (radius * 1609.344) as CLLocationDistance)
        map.removeOverlays(map.overlays)
        map.add(circle)
    }
    
    // Places custom pins on map where filtered users are
    func placePins(users: [User], radius: Double){
        map.removeAnnotations(map.annotations)
        for user in users{
            let annotation = UserAnnotation(title: user.name, coordinate: CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude), info: user.phoneNumber, user: user, radius: radius)
            map.addAnnotation(annotation)
        }
    }
    
    
// MARK: - Map Functions
    //Select pin on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectUserButton.isEnabled = true
    }
    
    // Deselect pin on map
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectUserButton.isEnabled = false
    }
    
    //function that consistantly maintaines users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.25, longitudeDelta:0.25))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // Creates redius circle to overlay on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.fillColor = UIColor.red
        circle.alpha = 0.1
        circle.lineWidth = 2
        circle.strokeColor = UIColor.red
        return circle
    }
    
    // Adds custom tooltip vew for user pins
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
    
    // User has selected a person to meet with. Perform segue to next view
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! UserAnnotation
        performSegue(withIdentifier: "SelectPartner", sender: annotation)
//        let name = annotation.title
//        let phoneNumber = annotation.info
//        
//        let ac = UIAlertController(title: name, message: phoneNumber, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
//*********
    
    
// Mark: - Pressed button functions
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {

    }
    
    @IBAction func selectUserPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SelectPartner", sender: self)
    }
    
    @IBAction func threeMilesPressed(_ sender: UIButton) {
        resetButtonColor()
        sender.backgroundColor = UIColor.blue
        sender.titleLabel?.textColor = UIColor.white
        sender.tintColor = UIColor.white
        self.getUsersInRadius(distance: 3.0)
    }
    
    @IBAction func fiveMilesPressed(_ sender: UIButton) {
        resetButtonColor()
        sender.backgroundColor = UIColor.blue
        sender.titleLabel?.textColor = UIColor.white
        sender.tintColor = UIColor.white
        self.getUsersInRadius(distance: 5.0)
    }
    
    @IBAction func tenMilesPressed(_ sender: UIButton) {
        resetButtonColor()
        sender.backgroundColor = UIColor.blue
        sender.titleLabel?.textColor = UIColor.white
        sender.tintColor = UIColor.white
        self.getUsersInRadius(distance: 10.0)
    }
    
    @IBAction func setRadiusPressed(_ sender: UIButton) {
        resetButtonColor()
        sender.backgroundColor = UIColor.blue
        sender.titleLabel?.textColor = UIColor.white
        sender.tintColor = UIColor.white
        performSegue(withIdentifier: "SetRadius", sender: self)
    }
    
    func resetButtonColor(){
        for btn in lowerButtons{
            btn.backgroundColor = UIColor.white
            btn.titleLabel?.textColor = UIColor.blue
        }
    }
//**********
    

// MARK: - Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetRadius"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! RadiusViewController
            controller.cancel = self
            controller.delegate = self
        }else if (segue.identifier == "SelectPartner") {
            let tabController = segue.destination as? UITabBarController
            let navController = tabController?.viewControllers?[0] as! UINavigationController
            let controller = navController.topViewController as! SearchRestaurantsViewController
            controller.cancelButtonDelegate = self
            controller.partner = (sender as? UserAnnotation)?.user
            controller.radius = (sender as? UserAnnotation)?.radius
            
            let navController2 = tabController?.viewControllers?[1] as! UINavigationController
            let controller2 = navController2.topViewController as! SelectRestaurantsTableViewController
                controller2.cancelButtonDelegate = self
            controller2.partner = (sender as? UserAnnotation)?.user
            controller2.radius = (sender as? UserAnnotation)?.radius
            
            controller.siblingDelegate = controller2
            controller2.siblingDelegate = controller
        }
    }
//**********
    
// MARK: - RadiusControllerDelegate functions
    func radius(controller: RadiusViewController, didSet radius: Double) {
        dismiss(animated: true, completion: nil)
        self.getUsersInRadius(distance: radius)
    }
//*********
    
    
// MARK: - CancelButtonDelegate functions
    func cancelButtonPressedFrom(_ controller: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
//**********
    
}













