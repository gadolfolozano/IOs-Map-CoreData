//
//  ViewController.swift
//  MapsAndCoreData
//
//  Created by Adolfo Lozano Mendez on 17/02/18.
//  Copyright © 2018 Adolfo Lozano Mendez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mMapView: MKMapView!
    var mLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mMapView.delegate = self
        
        mLocationManager.delegate = self
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager.requestWhenInUseAuthorization()
        mLocationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mMapView.setRegion(region, animated: true)
        
    }


}

