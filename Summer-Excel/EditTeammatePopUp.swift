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
        super.viewWillAppear(true)
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
    }
    
    override func enabled() {
        if (gradeNine.isSelected || gradeTen.isSelected || gradeEleven.isSelected || gradeTwelve.isSelected) && firstNameTextField.hasText && lastNameTextField.hasText {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @IBAction func confirmEdit(_ sender: Any) {
        let name = firstNameTextField.text! + " " + lastNameTextField.text!
        theAthlete?.thisName = name
        if gradeNine.isSelected == true
        {
            theAthlete?.thisGrade = 9
        }
        else if gradeTen.isSelected == true
        {
            theAthlete?.thisGrade = 10
        }
        else if gradeEleven.isSelected == true
        {
            theAthlete?.thisGrade = 11
        }
        else
        {
            theAthlete?.thisGrade = 12
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: theTeam)
        UserDefaults.standard.set(data, forKey: "theTeam")
    }
    
}
