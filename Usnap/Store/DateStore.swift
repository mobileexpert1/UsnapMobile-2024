//
//  DateStore.swift
//  Usnap
//
//  Created by CSPC141 on 02/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class DateStore: NSDate {
   
    static let sharedDate = DateStore()
   
    //return the current day
    func fetchLocalDay() ->  String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date as Date)
        return dayInWeek
    }
    
    //formar date according to requriment
    func formarDate(requreidFormat: String, finalDate: String  ) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: finalDate)
        dateFormatter.dateFormat = requreidFormat
        return  dateFormatter.string(from: date!)
    }
    
    //formar date according to requriment
    func formarDateForCard(requreidFormat: String, finalDate: String  ) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: finalDate)
        dateFormatter.dateFormat = requreidFormat
        return  dateFormatter.string(from: date!)
    }
    
    
    //formar date according to requriment
    func compareDates(startDate: String, endDate: String  ) ->  String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let firstDate = formatter.date(from: startDate)
        let secondDate = formatter.date(from: endDate)
        
        
        if startDate == "" || endDate == "" {
            return ""
        }
        
        if firstDate?.compare(secondDate!) == .orderedSame {
            return "same"
        }
        
        if firstDate?.compare(secondDate!) == .orderedAscending {
             return "start date is smaller then end date"
        }
        
        if firstDate?.compare(secondDate!) == .orderedDescending {
            return "start date is greater then end date"
        }
        
        return "empty"
        
    }
    
    
    
    
    func imageNameWithDate() ->  String  {
        let date :NSDate = NSDate()
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        var imageName = "\(dateFormatter.string(from: date as Date)).jpg"
        let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
        let someString:String = String(randomNum)
        imageName = String(format: "%@%@", someString,imageName)
        return imageName
    }

  
    
    func videoNameWithDate() ->  String  {
        let date :NSDate = NSDate()
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        var imageName = "\(dateFormatter.string(from: date as Date)).MOV"
        let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
        let someString:String = String(randomNum)
        imageName = String(format: "%@%@", someString,imageName)
        return imageName
    }
    
}
