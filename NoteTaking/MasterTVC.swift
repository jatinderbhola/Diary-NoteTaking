//
//  MasterTVC.swift
//  NoteTaking
//
//  Created by Supreet Singh on 2015-10-21.
//  Copyright © 2015 Project. All rights reserved.
//

import UIKit
import CoreData

var resultSearchController = UISearchController()

class MasterTVC: UITableViewController, NSFetchedResultsControllerDelegate , UISearchResultsUpdating{
    
    // Serach bar---
    //----- search bar option
    var filteredTableData = [String]()
    var itemArr = [Item]()
  //  var resultSearchController = UISearchController()
    //-----
    //-----
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var frc : NSFetchedResultsController = NSFetchedResultsController()
    //--- fetch sort data
    func fetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "subject", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
        
    }
    
    func getFRC() -> NSFetchedResultsController {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    //overload
    func fetchRequest(sort: String) -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: sort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
        
    }
    
    func getFRC(sort: String) -> NSFetchedResultsController {
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(sort), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    @IBAction func sortAction(sender: AnyObject) {
        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        self.tableView.reloadData()
        
    }
    
    @IBAction func sortByDate(sender: AnyObject) {
        frc = getFRC("date")
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        
        self.tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        
        //self.tableView.rowHeight = 60
        //self.tableView.backgroundView = UIImageView(image: UIImage(named: "orange-bg"))
        //self.tableView.reloadData()
        
        
        //search op
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.reloadData()
        //---
    }
    
    override func viewDidAppear(animated: Bool) {
        frc = getFRC()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Failed to perform initial fetch.")
            return
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (frc.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        // 2
        if (resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            let numberOfRowsInSection = frc.sections?[section].numberOfObjects
            return numberOfRowsInSection!
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
            for item in itemArr{
                if item.subject == filteredTableData[indexPath.row]{
                    cell.detailTextLabel?.text = item.date
                    cell.imageView?.image = UIImage(data: (item.image)!)
                }
            }
            return cell
        }
        else {
            let item = frc.objectAtIndexPath(indexPath) as! Item
            cell.textLabel?.text = item.subject
            
        
            cell.detailTextLabel!.text = "\((item.date)!)"
            cell.imageView?.image = UIImage(data: (item.image)!)
        
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        moc.deleteObject(managedObject)
        
        do {
            try moc.save()
        } catch {
            print("Failed to save.")
            return
        }
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit" {
            let indexPath = tableView.indexPathForSelectedRow!
            var item : Item = frc.objectAtIndexPath(indexPath) as! Item
            
            let currentCell = tableView.cellForRowAtIndexPath(indexPath)
            do{
                try itemArr = moc.executeFetchRequest(fetchRequest()) as! [Item]
            }
            catch _{}
            for Item in itemArr {
                
                if Item.subject == currentCell?.textLabel?.text{
                    item = Item
                }
                
            }
            //let cell = sender as! UITableViewCell
          //  let indexPath = tableView.indexPathForCell(cell)
            let itemController : DetailVC = segue.destinationViewController as! DetailVC
           // let item : Item = frc.objectAtIndexPath(indexPath!) as! Item
            itemController.item = item
            
            
        }
        if segue.identifier == "mapVC" {
            var itemArr = [Item]()
            do{
                try itemArr = moc.executeFetchRequest(fetchRequest()) as! [Item]
            }
            catch _{}
            let itemController : MapVC = segue.destinationViewController as! MapVC
            itemController.itemArr = itemArr
        }
//        if segue.identifier == "edit" && self.resultSearchController.active{
//            var itemArr = [Item]()
//            try? itemArr = moc.executeFetchRequest(fetchRequest()) as! [Item]
//            for item in itemArr{
//                if item.subject == filteredTableData[indexPath.row]{
//                    
//                }
//            }
//            
//            let itemController : DetailVC = segue.destinationViewController as! DetailVC
//            itemController.item = itemArr
//        }
        
    }
    
    //---search helper class method
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        var subjectArr = [String]()
        do{
            try itemArr = moc.executeFetchRequest(fetchRequest()) as! [Item]
        }
        catch _{}
        
        for Item in itemArr {
            
            subjectArr.append(Item.subject!)
            
        }
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (subjectArr as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        for item in array
        {
            let infoString = item
            filteredTableData.append(infoString as! String)
        }
        self.tableView.reloadData()
    }

}
