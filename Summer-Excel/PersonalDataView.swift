//
//  PersonalDataView.swift
//  Summer-Excel
//
//  Created by SCHNASER, ETHAN on 12/11/17.
//  Copyright © 2017 DIstrict 196. All rights reserved.
//

import UIKit
import JTAppleCalendar


class PersonalDataView: SwipableTabVC {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var runDate: UILabel!
    @IBOutlet weak var milesButton: UITextField!
    @IBOutlet weak var timeButton: UITextField!
    @IBOutlet weak var noteSection: UITextView!
    //Calendar
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var editWorkoutButton: UIButton!
    var dateInCalendar: Date!
    
    
    @IBAction func changeDate(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //everytime the date is changed in the datePicker, the label changes with it.
        let miles = theAthlete?.getWorkout(selectedDate: dateInCalendar).milesRan
        let milesStr = "\(miles ?? 0)"
        milesButton.text = milesStr
        let minutes = theAthlete?.getWorkout(selectedDate: dateInCalendar).timeElapsed
        timeButton.text = minutes?.toString()
        noteSection.text = theAthlete?.getWorkout(selectedDate: dateInCalendar).notes
        //sets the miles, time and notes section to the current value stored for that athlete on that day
    
        
    }
    
    
    @IBAction func editWorkout(_ sender: Any) {
        
        milesButton.isEnabled = true
        timeButton.isEnabled = true
        if (noteSection.text == "No Workout Logged") {
            noteSection.text = ""
        }
        noteSection.isEditable = true
    }
 

    
    @IBAction func doneEditing(_ sender: Any) {
        //casts the buttons to usable variables
       let theseMiles = Double(milesButton.text!)
        let theseMinutes = Int((timeButton.text?.components(separatedBy: ":").first)!)
        let theseSeconds = Int((timeButton.text?.components(separatedBy: ":").last)!)
        let thisTime = Time(sec: theseSeconds!, min: theseMinutes!)
       let theseNotes = noteSection.text
       
        theAthlete?.getWorkout(selectedDate: dateInCalendar).milesRan = theseMiles!
        theAthlete?.getWorkout(selectedDate: dateInCalendar).timeElapsed = thisTime
        theAthlete?.getWorkout(selectedDate: dateInCalendar).notes = theseNotes!
        
        milesButton.isEnabled = false
        timeButton.isEnabled = false
        noteSection.isEditable = false
        
        let data = NSKeyedArchiver.archivedData(withRootObject: theTeam)
        UserDefaults.standard.set(data, forKey: "theTeam")
    }
 


    override func viewDidLoad() {
        super.viewDidLoad()
        
        milesButton.isEnabled = false
        timeButton.isEnabled = false
        noteSection.isEditable = false
        
        //open to todays date
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        //Calendar
        setUpCalendarView()
    }
    
    //Stuff for calendar
    let formatter = DateFormatter()
    
    func setUpCalendarView() {
        //removes cell insets, sets the space between the cells
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //sets labels to month and year
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "yyyy"
            self.yearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "MMMM"
            self.monthLabel.text = self.formatter.string(from: date)
            
        }
        
        
    }
    
    //Changes the color of the text in the cells
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CollectionViewCell else { return }
        
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                return
            } else {
                cell.dateLabel.textColor = UIColor.black
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PersonalDataView: JTAppleCalendarViewDataSource {
    //Configures calendar with start and end dates
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6)
        return parameters
    }
    
    //Satisfies the data source protocol, displays the cell??
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CollectionViewCell
        cell.dateLabel.text = cellState.text

        //Makes sure collection view de-selects cells after reusing them for other months
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
}

extension PersonalDataView: JTAppleCalendarViewDelegate {
    //Displays the cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CollectionViewCell
        cell.dateLabel.text = cellState.text
        
        //Makes sure collection view de-selects cells after reusing them for other months
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        dateInCalendar = cellState.date
    }
    
    //Displays the background view when a date is selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard (cell as? CollectionViewCell) != nil else { return }
        let validCell = cell as! CollectionViewCell
        validCell.selectedView.isHidden = false
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        let selectedDate = cellState.date
        let miles = theAthlete?.getWorkout(selectedDate: selectedDate).milesRan
        let milesStr = "\(miles ?? 0)"
        milesButton.text = milesStr
        
        let minutes = theAthlete?.getWorkout(selectedDate: selectedDate).timeElapsed
        timeButton.text = minutes?.toString()
        //sets the miles and time button to the current value stored for that athlete on that day
        noteSection.text = theAthlete?.getWorkout(selectedDate: selectedDate).notes
        
        dateInCalendar = cellState.date
    }
    
  
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard (cell as? CollectionViewCell) != nil else { return }
        let validCell = cell as! CollectionViewCell
        validCell.selectedView.isHidden = true
        
        handleCelltextColor(view: cell, cellState: cellState)
        
        dateInCalendar = cellState.date
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    
    
}






