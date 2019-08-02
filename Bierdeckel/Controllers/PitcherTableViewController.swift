//
//  PitcherTableViewController.swift
//  Bierdeckel
//
//  Created by Werner on 17.02.18.
//  Copyright © 2018 WeRoServices. All rights reserved.
//

import UIKit
import CoreData

class PitcherTableViewController: UITableViewController {
    
    @IBOutlet weak var pitcherTableView: UITableView!
    
    var pitcherArray = [Pitcher]()
    var dateFormatter = DateFormatter()

    var selectedAWM : AWM? {
        didSet{
            loadPitchers()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pitcherTableView.register(UINib(nibName: "PitcherTableViewCell", bundle: nil), forCellReuseIdentifier: "PitcherCell")

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return pitcherArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PitcherCell", for: indexPath) as! PitcherTableViewCell

        let pitcher = pitcherArray[indexPath.row]
        
        cell.pitcherName.text = "Pitcher \(pitcher.nummer)"
        
        dateFormatter.dateFormat = "HH:mm:ss"

        if pitcher.uhrzeit != nil {
            cell.pitcherUhrzeit.text = dateFormatter.string(from: pitcher.uhrzeit!)
        } else {
            cell.pitcherUhrzeit.text = ""
        }
        
        return cell
    }
    
    
    // neu 17.04.2018: Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // neu 17.04.2018: Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(pitcherArray[indexPath.row] )
            self.pitcherArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.savePitchers()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("Editing style \(editingStyle) selected")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newPitcher = Pitcher(context: self.context)
        
        newPitcher.nummer = Int16(self.pitcherArray.count + 1)
        newPitcher.uhrzeit = Date()
        newPitcher.parentAWM = self.selectedAWM
        
        self.pitcherArray.append(newPitcher)
        
        self.savePitchers()

    }
 
    //MARK: - Model Manipulation Methods
    
    func savePitchers() {
        
        do {
            try context.save()
        } catch {
            print("Fehler beim Speichern der Pitcherdaten: \(error)")
        }
        
        tableView.reloadData()
        
    }

    func loadPitchers(with request: NSFetchRequest<Pitcher> = Pitcher.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let awmPredicate = NSPredicate(format: "parentAWM.name MATCHES %@", selectedAWM!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [awmPredicate, additionalPredicate])
        } else {
            request.predicate = awmPredicate
        }

        do {
            pitcherArray = try context.fetch(request)
        } catch {
            print("Fehler beim Laden der Pitcherdaten: \(error)")
        }
        
        tableView.reloadData()
        
    }

}
