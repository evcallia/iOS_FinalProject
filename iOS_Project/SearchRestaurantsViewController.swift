//
//  SearchRestaurantsViewController.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SearchRestaurantsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate{

// MARK: - Class variables
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchInput: UISearchBar!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    weak var partner: User?
    weak var cancelButtonDelegate: CancelButtonDelegate?
    var radius: Double?
    let locationManager = CLLocationManager()
    weak var siblingDelegate: SelectRestaurantsTableViewController?
    var previousSearch = ""
    var selectedRestaurant: MKAnnotationView?
//********
    
    
// MARK: - Load functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //location set up
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //map set up
        self.map.showsUserLocation = true
        self.map.delegate = self
        
        //search bar set up
        self.searchInput.delegate = self
        
        showCircle(coordinate: (self.locationManager.location?.coordinate)!, radius: radius!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchInput.text = previousSearch
        search()
        selectButton.isEnabled = false
    }
//*********
    

// MARK: - Search bar functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       search()
    }
    
    func search(){
        siblingDelegate?.previousSearch = searchInput.text!
        map.removeAnnotations(map.annotations)
        placePartnerOnMap()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchInput.text
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {
            response, error in
            if error != nil{
                print(error)
            }else if let mapItems = response?.mapItems{
                for item in mapItems{
                    self.placeItemOnMap(item: item)
                }
            }
        })

    }
//*********
    
    
// MARK: - Map Functions
    //Select pin on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedRestaurant = view
        selectButton.isEnabled = true
    }
    
    // Deselect pin on map
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectButton.isEnabled = false
    }
    
    //function creates and drops pins for each location passed
    func placeItemOnMap(item: MKMapItem){
        let location = item.placemark.location
        let myLocation = self.locationManager.location
        let distanceBetween = (myLocation?.distance(from: location!))! / 1609.344
        if distanceBetween <= radius!{
            let annotation = MKPointAnnotation()
            annotation.coordinate = item.placemark.coordinate
            annotation.title = item.name
            map.addAnnotation(annotation)
        }
    }
    
    // Puts the partner on the map
    func placePartnerOnMap(){
        let annotation = PartnerPin(title: (partner?.name)!, pinColor: .blue)
        annotation.coordinate = CLLocationCoordinate2D(latitude: (partner?.latitude)!, longitude: (partner?.longitude)!)
        annotation.title = partner?.name
        map.addAnnotation(annotation)
    }
    
    // Sets up custom pins/colors
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let partnerPin = annotation as? PartnerPin{
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView.pinTintColor = partnerPin.pinColor
            pinView.annotation = annotation
            pinView.isEnabled = true
            pinView.canShowCallout = true
            return pinView
        }
        return nil
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
    
    // Adds search radius overlay to map
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance){
        let circle = MKCircle(center: coordinate, radius: (radius * 1609.344) as CLLocationDistance)
        map.removeOverlays(map.overlays)
        map.add(circle)
    }
    
//    // User has selected a person to meet with. Perform segue to next view
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let annotation = view.annotation as! UserAnnotation
//        performSegue(withIdentifier: "RequestMeeting", sender: annotation)
//    }
//*********
    
    
// MARK: - action buttons
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    
    }
    
    @IBAction func selectButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "RequestMeeting", sender: self)
        
    }
//**********
    
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RequestMeeting"{
            let controller = segue.destination as! RequestMeetingViewController
            controller.partner = partner
            controller.restaurant = selectedRestaurant
        }
    }
//***********

}
















