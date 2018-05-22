//
//  Athlete.swift
//  Summer-Excel
//
//  Created by SCHNASER, ETHAN; MARSHALL, MAX; and ABBOTT, JAKE on 12/7/17.
//  Copyright © 2017 DIstrict 196. All rights reserved.
//

import UIKit
import Firebase

class Athlete: NSObject, NSCoding  {
    
    //All the Athlete properties are found here
    var thisName: String = ""
    var thisGrade: Int = 0
    var workouts: [Workout] = []
    var totalMiles: Double = 0.0
    var totalTime: Time = Time(sec: 0, min: 0)
    var attendance: Int = 0
    var averagePace: Time = Time(sec: 0, min: 0)
    var id: String = ""
    
   
    
    init(name: String, grade: Int, newId: String) {
        thisName = name
        thisGrade = grade
        id = newId
        totalMiles = 0
        attendance = 0
    }
    
    init(name: String, grade: Int, workoutArray: [Workout], totMi: Double, totTi: Time, attenda: Int, aver: Time, newId: String)
    {
        thisName = name
        thisGrade = grade
        workouts = workoutArray
        totalMiles = totMi
        totalTime = totTi
        attendance = attenda
        averagePace = aver
        id = newId
    }

    
    required convenience init?(coder decoder: NSCoder) {
        let name = decoder.decodeObject(forKey: "thisName") as? String
        let grade = decoder.decodeInteger(forKey: "thisGrade")
        let wrkouts = decoder.decodeObject(forKey: "workouts") as! [Workout]
        let miles = decoder.decodeDouble(forKey: "totalMiles")
        let totTime = decoder.decodeObject(forKey: "totalTime") as! Time
        let attend = decoder.decodeInteger(forKey: "attendance")
        let avP = decoder.decodeObject(forKey: "averagePace") as! Time
        let key = decoder.decodeObject(forKey: "thisId") as? String
        self.init(name: name!, grade: grade, workoutArray: wrkouts, totMi: miles, totTi: totTime, attenda: attend, aver: avP, newId: key!)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.thisName, forKey: "thisName")
        aCoder.encode(self.thisGrade, forKey: "thisGrade")
        aCoder.encode(self.workouts, forKey: "workouts")
        aCoder.encode(self.totalMiles, forKey: "totalMiles")
        aCoder.encode(self.totalTime, forKey: "totalTime")
        aCoder.encode(self.attendance, forKey: "attendance")
        aCoder.encode(self.averagePace, forKey: "averagePace")
        aCoder.encode(self.id, forKey: "thisId")
    }
    
    
    
    //Adds a new workout to the workout array
    func addWorkout(new: Workout) {
        
        workouts.append(new)
        
        //Calculates the total miles, time, attendance, and pace and assigns it to the properties
        totalTime.addTime(time2: new.timeElapsed)
        totalMiles += new.milesRan
        if new.didAttend
        {
            attendance += 1
        }
        let timpMin = totalTime.minutes
        let timpSec = totalTime.seconds
        var tmp = Time(sec: timpSec, min: timpMin)
        tmp = tmp.divideTime(number: totalMiles)
        averagePace = tmp
        
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        format.locale = Locale(identifier: "en_US")
        
        teamRef.child(id).child("workouts").child(new.id).child("miles").setValue(new.milesRan)
        let stringDate = format.string(from: new.date)
        teamRef.child(id).child("workouts").child(new.id).child("date").setValue(stringDate)
        teamRef.child(id).child("workouts").child(new.id).child("notes").setValue(new.notes)
        teamRef.child(id).child("workouts").child(new.id).child("attendance").setValue(new.didAttend)
        teamRef.child(id).child("workouts").child(new.id).child("time").child("minutes").setValue(new.timeElapsed.minutes)
        teamRef.child(id).child("workouts").child(new.id).child("time").child("seconds").setValue(new.timeElapsed.seconds)
        
    }
    
    
    func weeklyTotals(day: Date) -> (Double, Time, Int, Time) {
        
        //finds the weekday of the Date object and the date of the previous sunday and next saturday
        let weekday = Calendar.current.component(.weekday, from: day) - 1
        let sunday = Date(timeInterval: TimeInterval(86400 * (-(weekday + 1))), since: day)
        let saturday = Date(timeInterval: TimeInterval(86400 * (6-weekday)), since: day)
        
        //Calculates the total weekly miles, time, attendance, and pace
        var sumMiles = 0.0
        let sumTime = Time(sec: 0, min: 0)
        var sumAttendance = 0
        let sumPace = Time(sec: 0, min: 0)
        for each in workouts {
            if (each.date < saturday) && (each.date < sunday) {
                sumMiles += each.milesRan
                sumTime.addTime(time2: each.timeElapsed)
                if each.didAttend {
                    sumAttendance += 1
                }
                sumPace.addTime(time2: each.avgMilePace)
            }
        }
        
        //Return a tuple of all the weekly totals
        return (sumMiles, sumTime, sumAttendance, sumPace)
    }
    
    //get method that will return the workout object from theAthelte from the date from the paramter
    func getWorkoutArray(selectedDate: Date) -> Array<Workout> {
      
        var arr: [Workout] = []
        
        
        let count = theAthlete!.workouts.count
        for i in stride(from: 0, to: count, by: 1)
        {
            //creates two strings that represents the dates from the parameter and a workout object so they can be compared in the if statement
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let workoutSTR = dateFormatter.string(from: (theAthlete?.workouts[i].date)! )
            let selectedDateSTR = dateFormatter.string(from: selectedDate)
            if(workoutSTR == selectedDateSTR )
            {
                // sets a temp wokrout object to the workout that has the same date as the parameter
                arr.append((theAthlete?.workouts[i])!)
            }
    
        }
        return arr
    }
    

    
    func getWorkout(selectedDate: Date) -> Workout {
        
        //creates a temporary workout object
        let tempTime: Time = Time(sec: 0, min: 0)
        var temp: Workout = Workout(miles: 0.0, timeE: tempTime, theDate: selectedDate, words: "No Workout Logged", attend: false, thisId: "")

        let count = theAthlete!.workouts.count
        for i in stride(from: 0, to: count, by: 1)
        {

            //creates two strings that represents the dates from the parameter and a workout object so they can be compared in the if statement
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let workoutSTR = dateFormatter.string(from: (theAthlete?.workouts[i].date)! )
            let selectedDateSTR = dateFormatter.string(from: selectedDate)
            
            if(workoutSTR == selectedDateSTR )
            {
                // sets a temp wokrout object to the workout that has the same date as the parameter
                temp = (theAthlete?.workouts[i])!
            }
            
        }
        
        return temp
    }
    

    
    func hasWorkout(selectedDate: Date) -> Bool {
        var torf = false
        
        let count = theAthlete!.workouts.count
        for i in stride(from: 0, to: count, by: 1){
            //creates strings of the dates to be compared
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let workoutSTR = dateFormatter.string(from: (theAthlete?.workouts[i].date)! )
            let selectedDateSTR = dateFormatter.string(from: selectedDate)
            
            //if there is a workout in the workout array that has the same date as selected date, torf is set to true
            if (workoutSTR == selectedDateSTR){
                torf = true
            }
            
        }
        return torf
    }
    
    
    
    
    
    
    
    
    
}

