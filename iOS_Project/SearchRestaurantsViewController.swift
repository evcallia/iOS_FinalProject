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
    
    weak var partner: User?
    weak var cancelButtonDelegate: CancelButtonDelegate?
    var radius: Double?
    let locationManager = CLLocationManager()
    var siblingDelegate: SelectRestaurantsTableViewController?
    var previousSearch = ""
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
    }
//*********
    

// MARK: - Search bar functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       search()
    }
    
    func search(){
        siblingDelegate?.previousSearch = searchInput.text!
        map.removeAnnotations(map.annotations)
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
        
    }
    
    // Deselect pin on map
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
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
    
//    // Adds custom tooltip vew for user pins
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "UserAnnotation"
//        if annotation is UserAnnotation {
//            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//                view.annotation = annotation
//                return view
//            } else {
//                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.isEnabled = true
//                view.canShowCallout = true
//                
//                let btn = UIButton(type: .detailDisclosure)
//                view.rightCalloutAccessoryView = btn as UIView
//                return view
//            }
//        }
//        return nil
//    }
    
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
            
        }
    }
//***********

}
















