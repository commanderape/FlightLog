//
//  ViewController.swift
//  CopterBat
//
//  Created by Bastian Immel on 15.09.16.
//  Copyright © 2016 MorsabAlto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //Replace both UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batteries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let battery = batteries[indexPath.row]
        cell!.textLabel!.text = battery.value(forKey: "name") as? String
        return cell!
    }
    
    func saveName(name: String) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "battery", in:managedContext)
        let battery = NSManagedObject(entity: entity!, insertInto: managedContext)
        battery.setValue(name, forKey: "name")
        do {
            try managedContext.save()
            batteries.append(battery)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addName(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Name:", message: "Füge einen neuen Namen hinzu:", preferredStyle: .alert)
        let saveAction = UIAlertAction(
            title: "Speichern", style: .default, handler:
            {
                (
                    action:UIAlertAction) -> Void in
                    let textField = alert.textFields!.first
                    self.saveName(name: textField!.text!
                )
            self.tableView.reloadData()
            }
        )
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addTextField {(textField: UITextField) -> Void in}
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    

    var batteries = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Batteries"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "battery")
        do {
            let results =
                try managedContext.fetch(fetchRequest)
                    batteries = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
}

