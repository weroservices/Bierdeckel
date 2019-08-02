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
    
    var awmArray = [AWM]()
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var awmTableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        awmTableView.register(UINib(nibName: "AWMTableViewCell", bundle: nil), forCellReuseIdentifier: "AWMCell")
        
        loadAwms()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return awmArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AWMCell", for: indexPath) as! AWMTableViewCell
        
        let awm = awmArray[indexPath.row]
        cell.awmName.text = awm.name

        dateFormatter.dateFormat = "dd.MM.yyyy"
        if awm.datum != nil {
            cell.awmDatum.text = dateFormatter.string(from: awm.datum!)
        } else {
            cell.awmDatum.text = ""
        }
                
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPitcher", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PitcherTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedAWM = awmArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    // neu 17.04.2018: Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // neu 17.04.2018: Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(awmArray[indexPath.row] )
            self.awmArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveAwms()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

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
            awmArray = try context.fetch(request)
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
            
            self.awmArray.append(newAWM)
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
