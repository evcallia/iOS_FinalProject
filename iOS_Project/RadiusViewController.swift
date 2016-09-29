//
//  RadiusViewController.swift
//  iOS_Project
//
//  Created by Joseph Depew on 9/28/16.
//  Copyright © 2016 Evan Callia. All rights reserved.
//

import UIKit

class RadiusViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var halfNumbers = [".0", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9"]
    var wholeNumbers = [String]()
    var halfNumber = ".0"
    var wholeNumber = "0"
    weak var cancel: CancelButtonDelegate?
    weak var delegate: RadiusViewControllerDelegate?
    var radius: Double?

// VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...20 {
            wholeNumbers.append(String(i))
        }
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
    }

// MARK: - Picker View Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return wholeNumbers.count
        }else{
            return halfNumbers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return wholeNumbers[row]
        }else{
            return halfNumbers[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            wholeNumber = wholeNumbers[row]
        }else if component == 1{
            halfNumber = halfNumbers[row]
        }
    }
//********
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        cancel?.cancelButtonPressedFrom(self)
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let radius = Double(wholeNumber + halfNumber)
        delegate?.radius(controller: self, didSet: radius!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
