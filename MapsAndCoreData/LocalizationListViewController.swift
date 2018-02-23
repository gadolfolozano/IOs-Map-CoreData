//
//  LocalizationListViewController.swift
//  MapsAndCoreData
//
//  Created by Adolfo Lozano Mendez on 17/02/18.
//  Copyright © 2018 Adolfo Lozano Mendez. All rights reserved.
//

import UIKit
import CoreData

class LocalizationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    var locationArray = [LocationModel]()
    var selectedLocation : LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
        retrieveInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedLocation = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocalizationListViewController.retrieveInfo), name: NSNotification.Name(rawValue:"newLocationCreated"), object: nil)
    }
    
    @objc func retrieveInfo(){
        
        self.locationArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    let location = LocationModel()
                    location.name = result.value(forKey: "name") as! String
                    location.comment = result.value(forKey: "comment") as! String
                    location.latitude = result.value(forKey: "latitude") as! Double
                    location.longitude = result.value(forKey: "longitude") as! Double
                    
                    locationArray.append(location)
                    
                    self.mTableView.reloadData()
                }
            }
        } catch {
            print("there was an error")
        }
        
        
    }
    
    //get count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }

    //bind
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = locationArray[indexPath.row].name
        return cell
    }
    
    //on item click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = locationArray[indexPath.row]
        performSegue(withIdentifier: "showMapSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMapSegue"){
            let destination = segue.destination as! ViewController
            destination.selectedLocation = selectedLocation
        }
    }

}
