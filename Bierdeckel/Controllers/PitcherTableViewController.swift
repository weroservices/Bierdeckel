//
//  PitcherTableViewController.swift
//  Bierdeckel
//
//  Created by Werner on 17.02.18.
//  Copyright © 2018 WeRoServices. All rights reserved.
//

import UIKit
import CoreData

class PitcherTableViewController: UITableViewController, EditPitcherDelegate {
    
    @IBOutlet weak var pitcherTableView: UITableView!
    
    var pitcherArray = [Pitcher]()
    var selectedPitcher : Pitcher?
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
        
//        tableView.rowHeight = 91

    }
    
    //MARK: Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return pitcherArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PitcherCell", for: indexPath) as! PitcherTableViewCell

        let pitcher = pitcherArray[indexPath.row]
        
        cell.pitcherName.text = "Pitcher \(pitcher.nummer)"
        
        dateFormatter.dateFormat = "HH:mm:ss"

        // 02.08.2019: Optional Binding benutzen
        if let pitcherUhrzeit = pitcher.uhrzeit {
            cell.pitcherUhrzeit.text = dateFormatter.string(from: pitcherUhrzeit)
        } else {
            cell.pitcherUhrzeit.text = ""
        }
        
        return cell
    }
    
    //MARK: Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToEditPitcher", sender: self)
    }
    
    //MARK: Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditPitcherViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPitcher = pitcherArray[indexPath.row]

        } else if let pitcher = selectedPitcher {
            destinationVC.selectedPitcher = pitcher

        }
        
        destinationVC.delegate = self
    }

    //MARK: Swipe Actions konfigurieren
    // 02.08.2019
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
        // Action code für Löschen
        let löschen = UIContextualAction(style: .normal, title:  "Löschen", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("Löschen ...")
            self.context.delete(self.pitcherArray[indexPath.row] )
            self.pitcherArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.savePitchers()
            success(true)
        })
        löschen.backgroundColor = .red
        löschen.image = UIImage(named: "trash-icon")
        
        // Action code für Trinken
        let trinken = UIContextualAction(style: .normal, title:  "Trinken", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
//            print("Trinken ...")
//            var textField = UITextField()
            
            let alert = UIAlertController(title: "Jawoll!", message: "So ist es richtig!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Weitermachen!", style: .default) { (action) in
            }

            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            success(true)
        })
        trinken.backgroundColor = .orange
        trinken.image = UIImage(named: "beer-icon")
        
        // Action code für Änderm
        let ändern = UIContextualAction(style: .normal, title:  "Ändern", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            self.selectedPitcher =  self.pitcherArray[indexPath.row]
            self.performSegue(withIdentifier: "goToEditPitcher", sender: self)
            
            print("Ändern...")
            success(true)
        })
        ändern.backgroundColor = .purple
        ändern.image = UIImage(named: "edit-icon-2")
        
        return UISwipeActionsConfiguration(actions: [löschen, ändern, trinken])
    }
    
//    override func tableView(_ tableView: UITableView,
//                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let markieren = UIContextualAction(style: .normal, title:  "Markieren als getrunken", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
//            print("Markieren ...")
//            success(true)
//        })
//        
//        markieren.backgroundColor = .blue
//        return UISwipeActionsConfiguration(actions: [markieren])
//        
//    }
//    
    //MARK: Actions
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
 
    //MARK: EditPitcherDelegate Protocol Method
    func saveChanges(forPitcher: Pitcher) {
        savePitchers()
    }

}
