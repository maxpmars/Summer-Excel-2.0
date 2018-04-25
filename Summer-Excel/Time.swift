//
//  Time.swift
//  Summer-Excel
//
//  Created by SCHNASER, ETHAN; MARSHALL, MAX; and ABBOTT, JAKE on 12/7/17.
//  Copyright © 2017 DIstrict 196. All rights reserved.
//

import UIKit

class Time: NSObject, NSCoding {
    //Integer that represents the seconds of the time the time object is representing
    var seconds: Int
    //Integer that represents the minutes of the time the time object is representing
    var minutes: Int
    

    
    init(sec: Int, min: Int)
    {
        seconds = sec
        minutes = min
        
    }
    
    required convenience init?(coder decoder: NSCoder)
    {
        let secs = decoder.decodeInteger(forKey: "seconds")
        let mins = decoder.decodeInteger(forKey: "minutes")
        self.init(sec: secs, min: mins)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.seconds, forKey: "seconds")
        aCoder.encode(self.minutes, forKey: "minutes")
    }
    
    
    
    
    //This function will allow a time object to have another time object's instance variables added with their own
    //parameters: time2 = time object that will be added to the object being used to call.
    //return: none
    func addTime(time2: Time)
    {
        let sec = time2.seconds
        let min = time2.minutes
        
        seconds = seconds + sec
        minutes = minutes + min
    }
    
    //This function will allow the instance variables of a time object be listed in a way for the user to view the time that the object is associated with
    //parameters = none
    //return = String of letters and numbers representing the time the time object holds
    func toString() -> String
    {
        let min: String
        if seconds < 10
        {
        min = "\(minutes):0\(seconds)"
        }
        else
        {
        min = "\(minutes):\(seconds)"
        }
        return min
    }
    
    //Divides the time object by a double using floating point arithmetic
    func divideTime(number: Double) -> Time
    {
        let num = Int(number)
        var minu = minutes
        var secs = seconds
        let totalSeconds = (minu * 60) + secs
        let averageSeconds = totalSeconds/num
        minu = averageSeconds / 60
        secs = averageSeconds % 60
        let result = Time(sec: Int(secs), min: Int(minu))
        return result
    }
    
    func add(number: Time) -> Time
    {
        var totalSeconds = seconds + number.seconds
        var totalMinutes = minutes + number.minutes
        if totalSeconds > 60
        {
            totalMinutes = totalMinutes + 1
            totalSeconds = totalSeconds - 60
        }
        let time = Time(sec: totalSeconds, min: totalMinutes)
        return time
    }
    

    
}

