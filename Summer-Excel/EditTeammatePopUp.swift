//
//  EditTeammatePopUp.swift
//  Summer-Excel
//
//  Created by Ethan Schnaser on 5/11/18.
//  Copyright © 2018 DIstrict 196. All rights reserved.
//

import UIKit

class EditTeammatePopUp: HomepageView, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var gradeNine: UIButton!
    @IBOutlet weak var gradeTen: UIButton!
    @IBOutlet weak var gradeEleven: UIButton!
    @IBOutlet weak var gradeTwelve: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        gradeNine.isEnabled = true
        gradeTen.isEnabled = true
        gradeEleven.isEnabled = true
        gradeTwelve.isEnabled = true
        let firstName = theAthlete?.thisName.components(separatedBy: " ").first
        let lastName = theAthlete?.thisName.components(separatedBy: " ").last
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        let grade = theAthlete?.thisGrade
        if grade == 9
        {
            gradeNine.isSelected = true
        }
        else if grade == 10
        {
            gradeTen.isSelected = true
        }
        else if grade == 11
        {
            gradeEleven.isSelected = true
        }
        else
        {
            gradeTwelve.isSelected = true
        }
        enabled()

    }

    @IBAction func pressNine(_ sender: Any) {
        gradeNine.isSelected = true
        gradeTen.isSelected = false
        gradeEleven.isSelected = false
        gradeTwelve.isSelected = false
        enabled()
    }
    
    @IBAction func pressTen(_ sender: Any) {
        gradeNine.isSelected = false
        gradeTen.isSelected = true
        gradeEleven.isSelected = false
        gradeTwelve.isSelected = false
        enabled()
    }
    
    @IBAction func pressEleven(_ sender: Any) {
        gradeNine.isSelected = false
        gradeTen.isSelected = false
        gradeEleven.isSelected = true
        gradeTwelve.isSelected = false
        enabled()
    }
    
    @IBAction func pressTwelve(_ sender: Any) {
        gradeNine.isSelected = false
        gradeTen.isSelected = false
        gradeEleven.isSelected = false
        gradeTwelve.isSelected = true
        enabled()
    }
    

    @IBAction func deleteRunner(_ sender: Any) {
        let index = theTeam.index(of: theAthlete!)
        theTeam.remove(at: index!)
        let data = NSKeyedArchiver.archivedData(withRootObject: theTeam)
        UserDefaults.standard.set(data, forKey: "theTeam")
        
        let key = theAthlete?.id
        teamRef.child(key!).removeValue()
    }
    
   
    override func enabled() {
        if (gradeNine.isSelected || gradeTen.isSelected || gradeEleven.isSelected || gradeTwelve.isSelected) && firstNameTextField.hasText && lastNameTextField.hasText {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmEdit(_ sender: Any) {
        let name = firstNameTextField.text! + " " + lastNameTextField.text!
        var grade: Int
        if gradeNine.isSelected == true
        {
            grade = 9
        }
        else if gradeTen.isSelected == true
        {
            grade = 10
        }
        else if gradeEleven.isSelected == true
        {
            grade = 11
        }
        else
        {
            grade = 12
        }
        theAthlete?.thisName = name
        theAthlete?.thisGrade = grade
        
        let data = NSKeyedArchiver.archivedData(withRootObject: theTeam)
        UserDefaults.standard.set(data, forKey: "theTeam")
        
        let key = theAthlete?.id
        teamRef.child(key!).child("name").setValue(name)
        teamRef.child(key!).child("grade").setValue(grade)
        
        dismiss(animated: true)
    }
    
}
