//
//  EventsTableViewController.swift
//  Morning Star 2
//
//  Created by capstone team on 4/19/17.
//  Copyright © 2017 Uva Wise. All rights reserved.
//

import UIKit
import CoreData

class EventsTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    //var manager = coreDataDriver()
    
    var  eventsArray: [NSManagedObject] = []
    
    // The Managed Object Context retrieved from the app delegate
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gettAllRecords()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let event = eventsArray[indexPath.row]
        
        let eventTitle = event.value(forKeyPath: "eTitle") as? String
        let eventLocation = event.value(forKeyPath: "eLocation") as? String
        let eventDateTime = event.value(forKeyPath: "eDateTime") as? String
        
        cell.titleLable.text = eventTitle
        cell.locationLable.text = eventLocation
        cell.dateTimeLable.text = eventDateTime
        
        return cell
    }
    
    
    /***********************************************************************
     *
     * This function gets all records from the database and returns
     * an array of ManagedObject
     *
     **********************************************************************/
    
    func gettAllRecords() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
        
        do {
            eventsArray = try managedContext.fetch(fetchRequest)
            
            table.reloadData()
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareActions = UITableViewRowAction(style: .normal, title: "Share") { (_ rowAction: UITableViewRowAction, _ indexPath: IndexPath) in
            
            let shareEvent = self.eventsArray[indexPath.row]
            
            let shareString = "Hey, check out this event!\n"
            
            let eventTitle = shareEvent.value(forKeyPath: "eTitle") as? String
            let eventLocation = shareEvent.value(forKeyPath: "eLocation") as? String
            let eventDateTime = shareEvent.value(forKeyPath: "eDateTime") as? String
            
            let activityViewController = UIActivityViewController(activityItems: [shareString, eventTitle!, "at", eventLocation!, "on", eventDateTime!], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_ rowAction: UITableViewRowAction, _ indexPath: IndexPath) in
            let event = self.eventsArray[indexPath.row]
            self.managedContext.delete(event)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.gettAllRecords()
        }
        
        shareActions.backgroundColor = UIColor.gray
        
        return [deleteAction, shareActions]
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let indexPath = table.indexPathForSelectedRow
            let vc = segue.destination as! AddEventsViewController
            let event = eventsArray[(indexPath?.row)!]
            vc.event = event
        }
    }
    
}
