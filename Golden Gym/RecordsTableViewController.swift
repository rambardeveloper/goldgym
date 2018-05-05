//
//  RecordsTableViewController.swift
//  Golden Gym
//
//  Created by Andres Rambar on 5/4/18.
//  Copyright © 2018 Rambar. All rights reserved.
//

import UIKit
import CoreData

class RecordsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let persistentContainer = NSPersistentContainer(name: "Reports")
    var records: [NSManagedObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        
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

  
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return records.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")
        let record = records[indexPath.row]
        print("Record value \(String(describing: record.value(forKey: "sexo")))")
        cell?.textLabel?.text="\(String(describing: record.value(forKey: "imc")))"
        return cell!
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
