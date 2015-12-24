//
//  ViewController.swift
//  ParseMapper
//
//  Created by Phil Scarfi on 12/23/15.
//  Copyright © 2015 Pioneer Mobile Applications. All rights reserved.
//

import UIKit
import MapKit
import Parse

//Constants
private let AppID = "" //Your Parse AppID
private let ClientKey = "" //Your Parse Client Key
public let ClassName = "" //This should be the class where the PFGeoPoints are located in
public let LocationColumnName = "" //This should be the column that stores the PFGeoPoints
public let TitleColumnName = "" //This should be the column that stores a string to be used as the annotations title --> Totally optional though :)

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Parse.setApplicationId(AppID, clientKey: ClientKey)

        // Do any additional setup after loading the view, typically from a nib.
        queryForParseLocations(ClassName, locationColumnName: LocationColumnName, titleColumnName: TitleColumnName)
    }
    
    private func queryForParseLocations(className: String, locationColumnName: String, titleColumnName: String) {
        let query = PFQuery(className: className)
        query.limit = 1000
        query.whereKeyExists(locationColumnName)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                for object in objects {
                    if let location = object[locationColumnName] as? PFGeoPoint {
                        self.plotLocation(location.latitude, longitude: location.longitude, name: object[titleColumnName] as? String)
                    }
                }
            }
        }
    }
    
    private func plotLocation(latitude: Double, longitude: Double, name: String?) {
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        dropPin.title = name
        mapView.addAnnotation(dropPin)
    }
}

