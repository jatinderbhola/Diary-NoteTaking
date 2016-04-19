//
//  ViewController.swift
//  NoteTaking
//
//  Created by Supreet Singh on 2015-10-21.
//  Copyright © 2015 Project. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DetailVC: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    
    var item : Item? = nil
    
    //map
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var myPosition = CLLocationCoordinate2D()
    //map end
    
    
    //--- date
    
    let formatter = NSDateFormatter()
    //----
    var longitudeD: NSNumber = 0.0
    var latitudeD: NSNumber = 0.0
    
    @IBOutlet weak var enterSub: UITextField!
    @IBOutlet weak var enterNote: UITextView!
    @IBOutlet weak var imageHolder: UIImageView!
    @IBOutlet weak var enterDate: UILabel!
    @IBOutlet weak var addImageFromCamera: UIButton!
//    @IBOutlet weak var longitude: UILabel!
//    @IBOutlet weak var latitude: UILabel!
    
    
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enterSub.becomeFirstResponder()
        resultSearchController.active = false
        if item != nil {
            enterSub.text = item?.subject
            enterNote.text = item?.note
            enterDate.text = "Last Updated on \((item?.date)!)"
            imageHolder.image = UIImage(data: (item?.image)!)
            
            //let cood: String = (item?.map)!
            //let coodArr = cood.componentsSeparatedByString(","ßß
            
            longitudeD = (item?.longitude)!
            latitudeD = (item?.latitude)!
            
        }
        //map
        else{
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            startLocation = nil
        }
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            addImageFromCamera.hidden = true
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        myPosition = newLocation.coordinate
        locationManager.stopUpdatingLocation()
        //        longitude.text = String(format: "%.4f", newLocation.coordinate.longitude)
        //        latitude.text = String(format: "%.4f", newLocation.coordinate.latitude)
        //
        longitudeD = newLocation.coordinate.longitude
        latitudeD = newLocation.coordinate.latitude
        print("lon------")
        print(longitudeD)
        print(latitudeD)
        print("-------")
        if startLocation == nil {
            startLocation = newLocation
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    
    //location manager end ----
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveTapped(sender: AnyObject) {
        if item != nil {
            editItem()
        } else {
            createNewItem()
        }
        
        dismissVC()
    }
    
    

    @IBAction func cancelTapped(sender: AnyObject) {
        dismissVC()
    }
    
    
    @IBAction func addImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func addImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.imageHolder.image = image
    }
    
    func dismissVC() {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func createNewItem() {
        
        let entityDescription = NSEntityDescription.entityForName("Item", inManagedObjectContext: moc)
        
        let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: moc)
        
        item.subject = enterSub.text
        item.note = enterNote.text
   
        // date formater
        
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(NSDate())
        
        item.date = dateString
        item.image = UIImagePNGRepresentation(imageHolder.image!)
        
        //map
        item.latitude = latitudeD
        item.longitude = longitudeD
        
        do {
            try moc.save()
        } catch {
            return
        }
        
    }
    
    func editItem() {
        
        item?.subject = enterSub.text
        item?.note = enterNote.text
        
        
        // date formater
        
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(NSDate())
        
        item?.date = dateString
        
        item!.image = UIImagePNGRepresentation(imageHolder.image!)
        
        item!.latitude = latitudeD
        item!.longitude = longitudeD
        do {
            try moc.save()
        } catch {
            return
        }
        
    }
    
    
    //seque
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "noteLoc" {
            
            let itemController : MapVC = segue.destinationViewController as! MapVC
            //let item : Item = frc.objectAtIndexPath(indexPath!) as! Item
            itemController.item = self.item
            
        }
        
    }

    
}

