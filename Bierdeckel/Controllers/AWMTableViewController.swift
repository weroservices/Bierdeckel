//
//  AWMTableViewController.swift
//  Bierdeckel
//
//  Created by Werner on 17.02.18.
//  Copyright © 2018 WeRoServices. All rights reserved.
//

import UIKit
import CoreData

class AWMTableViewController: UITableViewController {
    
    var awms = [AWM]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAwms()
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return awms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AWMCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = awms[indexPath.row].name
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPitcher", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PitcherTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedAWM = awms[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveAwms() {
        
        do {
            try context.save()
        } catch {
            print("Fehler beim Speichern derAWMs \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadAwms() {
        
        let request: NSFetchRequest<AWM> = AWM.fetchRequest()
        
        do {
            awms = try context.fetch(request)
        } catch {
            print("Fehler beim Laden der Events \(error)")
        }
        
        tableView.reloadData()
        
    }

    //MARK: - Add New AWMs
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "AWM hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Hinzufügen", style: .default) { (action) in
            
            let newAWM = AWM(context: self.context)
            newAWM.name = textField.text!
            newAWM.datum = Date()
            
            self.awms.append(newAWM)
            
            self.saveAwms()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Neuen AWM hinzufügen"
        }
        
        present(alert, animated: true, completion: nil)
        
    }

}
