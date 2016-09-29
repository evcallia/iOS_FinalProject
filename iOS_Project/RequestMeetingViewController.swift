//
//  RequestMeetingViewController.swift
//  iOS_Project
//
//  Created by Evan Callia on 9/29/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class RequestMeetingViewController: UIViewController, MFMessageComposeViewControllerDelegate {

// MARK: - Class variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    var partner: User?
    var restaurant: MKAnnotationView?
//**********
    
    
// MARK: - set up functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateInfo()
    }
//********

    
    func populateInfo(){
        nameLabel.text = partner?.name
        phoneLabel.text = String(describing: partner!.phoneNumber)
        emailLabel.text = partner?.email
        restaurantLabel.text = ((restaurant!.annotation?.title)!)!
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

// MARK: - buttons pressed
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            controller.body = "Hi \(partner?.name), I saw you were in the area. Do you want to meet for \(((restaurant!.annotation?.title)!)!).      Message sent using Dinn.r"
            controller.recipients = [String(describing: partner?.phoneNumber)]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        if let phoneCallURL = NSURL(string: String(describing: partner!.phoneNumber)){
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL as URL){
                application.open(phoneCallURL as URL, options: [:], completionHandler: nil)
            }else{
                print("Call Failed")
            }
        }
    }
//*********
    
    
}















