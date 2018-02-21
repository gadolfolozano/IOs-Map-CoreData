//
//  LocalizationListViewController.swift
//  MapsAndCoreData
//
//  Created by Adolfo Lozano Mendez on 17/02/18.
//  Copyright © 2018 Adolfo Lozano Mendez. All rights reserved.
//

import UIKit

class LocalizationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "cell"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMapSegue", sender: self)
    }

}
