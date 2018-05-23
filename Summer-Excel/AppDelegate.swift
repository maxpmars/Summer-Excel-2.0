//
//  AppDelegate.swift
//  Summer-Excel
//
//  Created by SCHNASER, ETHAN; MARSHALL, MAX; and ABBOTT, JAKE on 12/7/17.
//  Copyright © 2017 DIstrict 196. All rights reserved.
//

//Global array that contains the while team.
var theTeam: [Athlete] = []

//Global variable for the athlete currently logged in
var theAthlete: Athlete? = nil

var teamRef: DatabaseReference!

//Array that saves the data between app closures
var pArray: PersistentStringArray?

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("didFinishLaunchingWithOptions is Called")
        
        if let data = UserDefaults.standard.object(forKey: "theTeam") as? NSData
        {
            theTeam = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Athlete]
        }
        
        FirebaseApp.configure()
        teamRef = Database.database().reference().child("team")
        
        //Read Data from Firebase if athlete is added
        teamRef.observe(DataEventType.childAdded) { (snapshot) in
            
            if snapshot.childSnapshot(forPath: "name").exists() && snapshot.childSnapshot(forPath: "grade").exists() && snapshot.childSnapshot(forPath: "key").exists() {
                let name = snapshot.childSnapshot(forPath: "name").value as! String
                let grade = snapshot.childSnapshot(forPath: "grade").value as! Int
                let key = snapshot.childSnapshot(forPath: "key").value as! String
                
                let newAthlete = Athlete(name: name, grade: grade, newId: key)
                
                var isNew = true
                for athletes in theTeam {
                    if newAthlete.id == athletes.id {
                        isNew = false
                    }
                }
                
                if isNew {
                    theTeam.append(newAthlete)
                }
            }
        }
        
        //Read Data from Firebase if athlete is modified (workout is added or athlete is edited)
        teamRef.observe(DataEventType.childChanged) { (snapshot) in
            
            //athlete is edited
            for eachMate in theTeam {
                if snapshot.key == eachMate.id {
                    let newName = snapshot.childSnapshot(forPath: "name").value as! String
                    let newGrade = snapshot.childSnapshot(forPath: "grade").value as! Int
                    eachMate.thisName = newName
                    eachMate.thisGrade = newGrade
                }
            }
            
            //workout is added code
                let athleteKey = snapshot.childSnapshot(forPath: "key").value as! String
                let workouts = snapshot.childSnapshot(forPath: "workouts")
                
                let format = DateFormatter()
                format.dateStyle = .medium
                format.timeStyle = .none
                format.locale = Locale(identifier: "en_US")
                
                
                for thisWorkout in workouts.children {
                    let eachWorkout = thisWorkout as! DataSnapshot
                    if eachWorkout.hasChild("time") {
                        let attendance = eachWorkout.childSnapshot(forPath: "attendance").value as! Bool
                        let dateString = eachWorkout.childSnapshot(forPath: "date").value as! String
                        let date = format.date(from: dateString)
                        let miles = eachWorkout.childSnapshot(forPath: "miles").value as! Double
                        let notes = eachWorkout.childSnapshot(forPath: "notes").value as! String
                        let seconds = eachWorkout.childSnapshot(forPath: "time").childSnapshot(forPath: "seconds").value as! Int
                        let minutes = eachWorkout.childSnapshot(forPath: "time").childSnapshot(forPath: "minutes").value as! Int
                        let time = Time(sec: seconds, min: minutes)
                        
                        let newWorkout = Workout(miles: miles, timeE: time, theDate: date!, words: notes, attend: attendance, thisId: eachWorkout.key)
                        
                        for eachAthlete in theTeam {
                            if eachAthlete.id == athleteKey {
                                var isNew = true
                                for athleteWorkout in eachAthlete.workouts {
                                    if athleteWorkout.id == newWorkout.id {
                                        isNew = false
                                        athleteWorkout.milesRan = newWorkout.milesRan
                                        athleteWorkout.timeElapsed = newWorkout.timeElapsed
                                        athleteWorkout.notes = newWorkout.notes
                                    }
                                }
                                if isNew {
                                    eachAthlete.addWorkout(new: newWorkout)
                                }
                            }
                        }
                    }
                }
        }
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        
    }


}

