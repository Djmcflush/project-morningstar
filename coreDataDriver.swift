//
//  coreDataDriver.swift
//  Morning Star 2
//
//  Created by Kunj Patel on 4/26/17.
//  Copyright © 2017 Uva Wise. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class coreDataDriver: NSObject {
    
    var eventTitle: String?
    var eventLocation: String?
    var eventDateTime: String?
    
    var  eventsArray: [NSManagedObject] = []
    var  event: NSManagedObject!
    
    // The Managed Object Context retrieved from the app delegate
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    /***********************************************************************
     *
     * This Function searches for a particular name
     *
     **********************************************************************/
    
    func find(name:String) -> NSManagedObject!
    {
        // Create the request and the query that will fetch the records
        
        let search   = NSPredicate(format: "eventName == %@", name)
        let query    = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        query.predicate = search
        
        
        do {
            eventsArray  = try managedContext.fetch(query)
            if eventsArray.count > 0
            {
                return eventsArray[0]
            }
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
        return nil
    }
    
    /***********************************************************************
     *
     * This function save a new record to the databasea and returns
     * true if the record is saved and false if not.
     *
     **********************************************************************/
    
    func saveNew() -> Bool {
        
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
        
        event = NSManagedObject(entity: entity, insertInto: managedContext)
        
        self.putData()
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
     * This function update an existing record to the databasea and returns
     * true if the record is saved and false if not.
     *
     **********************************************************************/
    
    func update() -> Bool {
        
        self.putData()
        
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
     * This function reads fields from a managed object
     *
     **********************************************************************/
    
    func getData()
    {
        eventTitle = event.value(forKeyPath: "eTitle") as? String
        eventLocation = event.value(forKeyPath: "eLocation") as? String
        eventDateTime = event.value(forKeyPath: "eDateTime") as? String
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
    
    /***********************************************************************
     *
     * This function gets all records from the database and returns
     * an array of ManagedObject
     *
     **********************************************************************/
    
    func gettAllRecords() -> [NSManagedObject]
    {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        do {
            eventsArray  = try managedContext.fetch(fetchRequest)
            
//            for e in eventsArray
//            {
//                // Do something with the data
//            }
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
        return eventsArray
    }
    
    
    /***********************************************************************
     *
     * This function search core data for a name that contains a string
     * that is passed to this function
     *
     **********************************************************************/
    
    func filterEvents(_ searchText: String)
    {
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        let predicate = NSPredicate(format: "firstName  contains %@", searchText)
        
        request.predicate = predicate
        
        do {
            eventsArray  = try managedContext.fetch(request)
            
//            for e in eventsArray
//            {
//                // Do something with the data
//            }
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
        
    }
    
    
    /*********************************************************************
     *
     * This function Display Action Controller to get a contact name
     *
     *********************************************************************/
    
    @IBAction func searchRecords(_ sender: AnyObject) {
        
        
        // create the alert controller
        
        let v = UIAlertController(title: "Search", message: "Enter  part of a Event name", preferredStyle: UIAlertControllerStyle.alert)
        
        
        // Add the text field
        
        v.addTextField { (storeName:UITextField!) -> Void in
            
            storeName.placeholder = "Event Name"
            
        }
        
        
        // Create the button - Alert Action
        
        let okAc = UIAlertAction(title: "Search", style: UIAlertActionStyle.default)
        { (alert: UIAlertAction) in
            
            let eventName = v.textFields![0]
            
            self.filterEvents(eventName.text!)
            
            v.dismiss(animated: true, completion: nil)
        }
        
        
        // Add it to the controller
        
        v.addAction(okAc)
        
        
        // only one cancel action style allowed
        
        let cancelAc = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel) { (alert: UIAlertAction) in
            
            v.dismiss(animated: true, completion: nil)
            
        }
        
        v.addAction(cancelAc)
        
        // present(v, animated: true , completion: nil)
        
    }
}
