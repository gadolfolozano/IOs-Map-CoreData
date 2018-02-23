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
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mTxtName: UITextField!
    @IBOutlet weak var mTxtComment: UITextField!
    
    @IBOutlet weak var mMapView: MKMapView!
    var mLocationManager = CLLocationManager()
    
    var latitudeSelected = 0.0
    var longitudeSelected = 0.0
    
    var selectedLocation : LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mMapView.delegate = self
        
        if let _ = selectedLocation {
            mTxtName.text = selectedLocation?.name
            mTxtComment.text = selectedLocation?.comment
            
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: (self.selectedLocation?.latitude)!, longitude: (self.selectedLocation?.longitude)!)
            annotation.coordinate = coordinate
            annotation.title = selectedLocation?.name
            annotation.subtitle = selectedLocation?.comment
            self.mMapView.addAnnotation(annotation)
        }
        
        
        //init localization manager
        mLocationManager.delegate = self
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager.requestWhenInUseAuthorization()
        mLocationManager.startUpdatingLocation()
        
        //create gesture recognition
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mMapView.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Reciving current localization
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations);
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mMapView.setRegion(region, animated: true)
        
    }
    
    //called whith long press
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchedPoint = gestureRecognizer.location(in: self.mMapView)
            let chosenCoordinates = self.mMapView.convert(touchedPoint, toCoordinateFrom: self.mMapView)
            
            self.latitudeSelected = chosenCoordinates.latitude
            self.longitudeSelected = chosenCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = chosenCoordinates
            annotation.title = mTxtName.text
            annotation.subtitle = mTxtComment.text
            self.mMapView.addAnnotation(annotation)
            
        }
        
    }
    
    //for to get pin style
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    //Control go to maps, like an intent
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let requestCLLocation = CLLocation()
        
        /*if transmittedLatitude != 0 {
            if transmittedLongitude != 0 {
                self.requestCLLocation = CLLocation(latitude: transmittedLatitude, longitude: transmittedLongitude)
            }
        }*/
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            
            if let placemark = placemarks {
                
                if placemark.count > 0 {
                    
                    let newPlaceMark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlaceMark)
                    //item.name = self.transmittedTitle
                    item.name = "hola"
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                    
                }
            }
        }
    }

    @IBAction func onSaveClick(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
        
        newLocation.setValue(mTxtName.text, forKey: "name")
        newLocation.setValue(mTxtComment.text, forKey: "comment")
        newLocation.setValue(self.latitudeSelected, forKey: "latitude")
        newLocation.setValue(self.longitudeSelected, forKey: "longitude")
        
        
        do {
            try context.save()
            print("we managed to save it")
        } catch {
            print("error")
        }
        
        
        self.mTxtComment.text = ""
        self.mTxtComment.text = ""
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newLocationCreated"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

