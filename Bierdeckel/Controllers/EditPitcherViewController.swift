//
//  EditPitcherViewController.swift
//  Bierdeckel
//
//  Created by Werner on 05.08.19.
//  Copyright © 2019 WeRoServices. All rights reserved.
//

import UIKit

protocol EditPitcherDelegate {
    func saveChanges(forPitcher: Pitcher)
}

class EditPitcherViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pitcherNameTextField: UITextField!
    @IBOutlet weak var pitcherTime: UIPickerView!
    
    var hours : [String] = []
    var minutes : [String] = []
    var seconds : [String] = []
    var pickerData : [[String]] = [[]]
    var zeit = ""
    var uhrzeit : [String] = []
    
    
    var selectedPitcher : Pitcher?
    var delegate : EditPitcherDelegate?
    
    var formatter = DateFormatter()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPickerData()
        
        formatter.timeZone = .none
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "de_DE")
        
        
        
        // Do any additional setup after loading the view.
        pitcherTime.dataSource = self
        pitcherTime.delegate = self
        
        
        // Disable editing for TextField
        pitcherNameTextField.isEnabled = false

        if let pitcherNummer = selectedPitcher?.nummer {
            pitcherNameTextField.text = "Pitcher \(pitcherNummer)"
        } else {
            pitcherNameTextField.text = "Pitcher dummy"
        }
        
        if let pitcherZeit = selectedPitcher?.uhrzeit {
            zeit = formatter.string(from: pitcherZeit)
        } else {
            zeit = formatter.string(from: Date())
       }
        
        uhrzeit = zeit.components(separatedBy: ":")
        
        pitcherTime.selectRow(Int(uhrzeit[0]) ?? 0, inComponent: 0, animated: true)
        pitcherTime.selectRow(Int(uhrzeit[1]) ?? 0, inComponent: 2, animated: true)
        pitcherTime.selectRow(Int(uhrzeit[2]) ?? 0, inComponent: 4, animated: true)

    }
    
    //MARK: PickerView DataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    //MARK: PickerView Delegate Methods
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 
        switch component {
        case 0:
            uhrzeit[0] = "\(row)"
        case 2:
            uhrzeit[1] = "\(row)"
        case 4:
            uhrzeit[2] = "\(row)"
        default:
            break
        }
        
        let zeit = "\(uhrzeit[0]):\(uhrzeit[1]):\(uhrzeit[2])"
        selectedPitcher?.uhrzeit = formatter.date(from: zeit)
        
    }
    
   
    //MARK: Initializing PickerView

    func loadPickerData() {

        for h in 0..<24 {
            hours.insert("\(h)", at: h)
        }
        for ms in 0..<60 {
            minutes.insert("\(ms)", at: ms)
            seconds.insert("\(ms)", at: ms)
        }
        pickerData = [hours, ["Uhr"], minutes, ["Min"], seconds, ["Sek"]]
    }
    
    //MARK: Actions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        delegate?.saveChanges(forPitcher: selectedPitcher!)
        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func savePitcherPressed(_ sender: UIBarButtonItem) {

        delegate?.saveChanges(forPitcher: selectedPitcher!)
        self.navigationController?.popViewController(animated: true)
   }
}
