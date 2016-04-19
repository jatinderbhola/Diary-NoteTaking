//
//  ViewController.swift
//  CoreLoc
//
//  Created by macadmin on 2015-10-14.
//  Copyright © 2015 Jatinderbhola. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//singalton class : not muliple instances

class CityLocation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var myPosition = CLLocationCoordinate2D()
    
    var item : Item? = nil
    var itemArr = [Item]()
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var mapView: MKMapView!
    
//    
//    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
//        let location = sender.locationInView(self.mapView)
//        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
//        // to add pin on the map
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = locCoord
//        //annotation.title = "Jatinder Bhola"
//        //annotation.subtitle = "Bhola Family"
//        
//        //----- new stuff
//        let placemark = MKPlacemark(coordinate: locCoord, addressDictionary: nil)
//        destination = MKMapItem(placemark: placemark)
//        //-----
//        
//        
//        // self.mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(annotation)
//        
//        //
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if item != nil{
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
//            print(item?.longitude)
//            print(item?.latitude)
//            print(item?.subject)
//            print(item?.date)
            
            let myLongitude = NSDecimalNumber(decimal: (item!.longitude?.decimalValue)!)
           
            let myLatitude = NSDecimalNumber(decimal: (item!.latitude?.decimalValue)!)
            let locCoord = CLLocationCoordinate2D(latitude: myLatitude.doubleValue, longitude: myLongitude.doubleValue)
            
            // to add pin on the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = locCoord
            annotation.title = item?.subject
            annotation.subtitle = item?.date
            mapView.addAnnotation(annotation)
            
            //zoom
            let span = MKCoordinateSpanMake(0.03, 0.03)//zooming in(small value)/out(more value)--- higher the number - more the distance we are from the ground
            let region = MKCoordinateRegion(center: locCoord, span: span)//center: my position
            mapView.setRegion(region, animated: true)
            
        }
        if itemArr.isEmpty == false {
            print("awesome 2")
            var annotationArr = [MKAnnotation]()
            var myLongitude, myLatitude : NSDecimalNumber
            myLatitude = 0.0
            myLongitude = 0.0
            
            for var i = 0; i < itemArr.count ; i=i+1 {
                myLongitude = NSDecimalNumber(decimal: (itemArr[i].longitude?.decimalValue)!)
                myLatitude = NSDecimalNumber(decimal: (itemArr[i].latitude?.decimalValue)!)
                print(itemArr[i].subject)
                
                annotationArr.append(CityLocation(title: itemArr[i].subject!, coordinate: CLLocationCoordinate2D(latitude: myLatitude.doubleValue, longitude: myLongitude.doubleValue)))
                
                mapView.addAnnotation(annotationArr[i])
                
            }
            
            mapView.addAnnotations(annotationArr)
            
//            let locCoord = CLLocationCoordinate2D(latitude: myLatitude.doubleValue, longitude: myLongitude.doubleValue)
//            //zoom
//            let span = MKCoordinateSpanMake(10,10 )//zooming in(small value)/out(more value)--- higher the number - more the distance we are from the ground
//            let region = MKCoordinateRegion(center: locCoord, span: span)//center: my position
//            mapView.setRegion(region, animated: true)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
//        
//        myPosition = newLocation.coordinate
//        locationManager.stopUpdatingLocation()
//        lblLocation.text = "Got Postion:\n \t latitude: \(newLocation.coordinate.latitude)\n \t longitude:\(newLocation.coordinate.longitude)"
//        
//        let span = MKCoordinateSpanMake(0.05, 0.05)//zooming in(small value)/out(more value)--- higher the number - more the distance we are from the ground
//        let region = MKCoordinateRegion(center: myPosition, span: span)//center: my position
//        
//        
//        mapView.setRegion(region, animated: true)
//    }
    
    //---------- new class --------
    /*
    place mark: put into mapitem
    */
    var destination: MKMapItem = MKMapItem()
    
//    //---------
//    @IBAction func addDirection(sender: AnyObject) {
//        
//        let request = MKDirectionsRequest()
//        request.source = MKMapItem.mapItemForCurrentLocation()
//        request.destination = destination
//        
//        let directions = MKDirections(request: request)
//        
//        //closure function...
//        directions.calculateDirectionsWithCompletionHandler ({ (response, error  ) -> Void in
//            
//            if error != nil {
//                print ("Error in obtaining directions: \(error)")
//            } else {
//                let overlay = self.mapView.overlays
//                self.mapView.removeOverlays(overlay)
//                
//                for route in response!.routes as [MKRoute] {
//                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
//                    
//                    for next in route.steps {
//                        print (next.instructions)
//                    } // end of inner loop
//                } // end of outer loop
//            } // end of else
//        })
//    }
//    
//    
//    
//    func mapView (mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        
//        if let overlay = overlay as? MKPolyline {
//            let v = MKPolylineRenderer(polyline: overlay)
//            v.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
//            v.lineWidth = 3
//            return v
//        }
//        return MKOverlayRenderer()
//        
//    }
    
}















