//
//  TableController.swift
//  Golden Gym
//
//  Created by Andres Rambar on 5/4/18.
//  Copyright © 2018 Rambar. All rights reserved.
//

import UIKit
import CoreData

class TableController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let persistentContainer = NSPersistentContainer(name: "Reports")
    var records: [NSManagedObject] = []
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Records")
        
        //3
        do {
            records = try managedContext.fetch(fetchRequest)
            print("Record number: \(records.count)")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

  

}
