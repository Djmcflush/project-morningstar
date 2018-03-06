//
//  AddEventsViewController.swift
//  Morning Star 2
//
//  Created by capstone team on 4/19/17.
//  Copyright © 2017 Uva Wise. All rights reserved.
//

import UIKit
import CoreData

class AddEventsViewController: UIViewController {
    
    //declare variables
    var eventTitle: String?
    var eventLocation: String?
    var eventDateTime: String?
    
    var  eventsArray: [NSManagedObject] = [] //empty array to store events in coredata
    var  event: NSManagedObject! //coredata variable
    
    // The Managed Object Context retrieved from the app delegate
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //managed context talk with database
    
    @IBOutlet weak var txtErr: UILabel! //error label
    
    @IBOutlet weak var txtTitle: UITextField! //title text field
    
    @IBOutlet weak var txtLocation: UITextField! //location text field
    
    @IBOutlet weak var txtTimeDate: UITextField! //Date and Time text field
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtErr.isHidden = true //initially hide the error label
        
        if event != nil { //check if event if not nil
            getData() //if not nil then get data
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        //set the declared variables to text fields
        eventTitle = txtTitle.text
        
        eventLocation = txtLocation.text
        
        eventDateTime = txtTimeDate.text
        
        if !(eventTitle?.isEmpty)!, !(eventLocation?.isEmpty)!, !(eventDateTime?.isEmpty)! { //check if all the textfields are filled
            
            if saveNew() == true { //
                print("Save Sucessfull")
            } else {
                txtErr.isHidden = false
                txtErr.text = "Save unsucessful"
            }
            
            navigationController?.popViewController(animated: true) //pop the navigatin controller to go to events controller
        }
            
            //if one or more textfields are empty, display the below error
        else {
            txtErr.isHidden = false
            txtErr.text = "Please make sure all the entries are filled" //error to display
        }
        
    }
    
    // Action function that clears all the text fields
    @IBAction func btnClear(_ sender: UIButton) {
        txtTitle.text = nil
        txtLocation.text = nil
        txtTimeDate.text = nil
        txtErr.isHidden = true
    }
    
    //action function triggered when presed on Date Time text field
    @IBAction func dateTimePicker(_ sender: UITextField) {
        
        let datePicker = UIDatePicker() //create an instance of UIDatePicker
        
        datePicker.datePickerMode = .dateAndTime //we put date and time inside the picker
        datePicker.minimumDate = Date() //set the minimum date to current date
        sender.inputView = datePicker //puts the date and time with constaints in the picker
        
        datePicker.addTarget(self, action: #selector(AddEventsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged) //present the view contorller
        
    }
    
    //function that format's the date
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter() //instance of DateFromatter class
        dateFormatter.dateStyle = DateFormatter.Style.medium //set the dateStyle to medium
        dateFormatter.timeStyle = DateFormatter.Style.short //set the timeStyle to short
        txtTimeDate.text = dateFormatter.string(from: sender.date) //puts the date in tetxfield
    }
    
    //Function that save new records to the database
    func saveNew() -> Bool {
        
        if event == nil {
            
            let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
            
            event = NSManagedObject(entity: entity, insertInto: managedContext)
            
        }
        
        putData()
        
        // Save Context
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
            
        }
    }
    
    /***********************************************************************
     *
     * This function update a mamange object with values from variables
     *
     **********************************************************************/
    
    func putData()
    {
        event.setValue(eventTitle, forKeyPath: "eTitle")
        event.setValue(eventLocation, forKeyPath: "eLocation")
        event.setValue(eventDateTime, forKeyPath: "eDateTime")
    }
    
    func getData()
    {
        eventTitle = event.value(forKeyPath: "eTitle") as? String
        eventLocation = event.value(forKeyPath: "eLocation") as? String
        eventDateTime = event.value(forKeyPath: "eDateTime") as? String
        
        txtTitle.text = eventTitle
        txtLocation.text = eventLocation
        txtTimeDate.text = eventDateTime
    }
}
