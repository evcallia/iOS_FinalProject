//
//  SelectPartnerViewController.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SelectRestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate { //, MKMapViewDelegate

// Mark: - Class variables
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var emailLabel: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var searchInput: UISearchBar!
    
    weak var partner: User?
    weak var cancelButtonDelegate: CancelButtonDelegate?
    var radius: Double?
    let locationManager = CLLocationManager()
    var siblingDelegate: SearchRestaurantsViewController?
    var places = [MKMapItem]()
    var previousSearch = ""
//*********
    
    
// Mark: - Page load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Location set up
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        
        //Search bar set up
        self.searchInput.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchInput.text = previousSearch
        search()
        tableView.reloadData()
        print(places.count)
    }
//***********

    
// MARK: - Search functions
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
    
    func search(){
        siblingDelegate?.previousSearch = searchInput.text!
        var places = [MKMapItem]()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchInput.text
        let center = locationManager.location?.coordinate
        request.region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta:0.25, longitudeDelta:0.25))
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {
            response, error in
            if error != nil{
                print(error)
            }else if let mapItems = response?.mapItems{
                print("Map Item Count: ", mapItems.count)
                for item in mapItems{
                    let location = item.placemark.location
                    let myLocation = self.locationManager.location
                    let distanceBetween = (myLocation?.distance(from: location!))! / 1609.344
                    if distanceBetween <= self.radius!{
                        places.append(item)
                    }
                }
                print("Places Item Count: ", places.count)
                self.tableView.reloadData()
            }
        })
    }
//************
    
    
// MARK: - TableView functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
//**********
}














