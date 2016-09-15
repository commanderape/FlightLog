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

    //Replace both UITableViewDataSource methods
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let person = people[indexPath.row]
        
        cell!.textLabel!.text =
            person.value(forKey: "name") as? String
        
        return cell!
    }
    
    func saveName(name: String) {
        //1
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let managedContext = appDelegate.managedObjectContext
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        NSLog(managedContext.nil?)
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addName(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        
        let saveAction = UIAlertAction(title: "Speichern",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(name: textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Batteries"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}

