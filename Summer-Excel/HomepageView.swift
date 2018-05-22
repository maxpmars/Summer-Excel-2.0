//
//  HomepageView.swift
//  Summer-Excel
//
//  Created by SCHNASER, ETHAN on 12/11/17.
//  Copyright © 2017 DIstrict 196. All rights reserved.
//

import UIKit

class HomepageView: SwipableTabVC {
    
    @IBOutlet weak var mileInput: UITextField!
    @IBOutlet weak var minuteInput: UITextField!
    @IBOutlet weak var notesInput: UITextView!
    @IBOutlet weak var attendanceInput: UISwitch!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var dateInput: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet weak var changeTeamateButton: UIButton!
    @IBOutlet weak var workoutPicker: UIPickerView!
    @IBOutlet weak var secondInput: UITextField!
    @IBInspectable var defaultIndex: Int = 0
    

    var workoutArr: [Workout] = []
    


    
    
    @IBAction func milesEdited(_ sender: Any) {
        enabled()
    }
    
    @IBAction func minutesEdited(_ sender: Any) {
        enabled()
    }
    
    @IBAction func dateEdited(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateInput.text = dateFormatter.string(from: self.datePicker.date)
        
    }

    @IBAction func secondsEdited(_ sender: Any) {
        enabled()
    }
    
    @IBAction func pressEnter(_ sender: Any) {
        //casts the buttons to usable variables
        let theseMiles = Double(mileInput.text!)
        let theseMinutes = Int(minuteInput.text!)
        let theseSeconds = Int(secondInput.text!)
        let thisTime = Time(sec: theseSeconds!, min: theseMinutes!)
        var theseNotes = notesInput.text
        let attended = attendanceInput.isOn
        if notesInput.hasText == false
        {
            theseNotes = "No notes entered"
        }
        
        let key = teamRef.child((theAthlete?.id)!).child("workouts").childByAutoId().key
        
        //creates the workout for this log
        let thisWorkout = Workout(miles: theseMiles!, timeE: thisTime, theDate: Date(), words: theseNotes!, attend: attended, thisId: key)
        
        //attaches the workout to the athlete that is logged in
        theAthlete?.addWorkout(new: thisWorkout)
        
        //Clears the fields
        mileInput.text = nil
        minuteInput.text = nil
        notesInput.text = nil
        secondInput.text = nil
        attendanceInput.isOn = false
        enabled()
        
        let data = NSKeyedArchiver.archivedData(withRootObject: theTeam)
        UserDefaults.standard.set(data, forKey: "theTeam")
        
        
    }
    
    
    func enabled() {
        if (mileInput.hasText && minuteInput.hasText && secondInput.hasText) {
            enterButton.isEnabled = true
        } else {
            enterButton.isEnabled = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*keyboard displays when dateInput is selected
       datePicker.datePickerMode = UIDatePickerMode.date
        dateInput.inputView = datePicker
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateInput.text = dateFormatter.string(from: self.datePicker.date)

    }
    

}
