//
//  DateModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/06/2022.
//

import UIKit

class DateModel: NSObject {
    
    static let shared = DateModel()
    
    override init() {
        super.init()
    }
    
    func seconds(_ ti: TimeInterval, f: NSString = "%0.2d") -> NSString {
        var time = NSInteger(ti) % 60
        time = time <= 0 ? 0 : time
        
        return NSString(format: f, time)
    }
    
    func minutes(_ ti: TimeInterval, f: NSString = "%0.2d") -> NSString {
        var time = (NSInteger(ti) / 60) % 60
        time = time <= 0 ? 0 : time
        
        return NSString(format: f, time)
    }
    
    func hours(_ ti: TimeInterval, f: NSString = "%0.2d") -> NSString {
        var time = NSInteger(ti) / (60*60)
        time = time <= 0 ? 0 : time
        
        return NSString(format: f, time)
    }
    
    func days(_ ti: TimeInterval, f: NSString = "%0.2d") -> NSString {
        var time = NSInteger(ti) / (24*60*60)
        time = time <= 0 ? 0 : time
        
        return NSString(format: f, time)
    }
    
    func getOnlineStatus(with timeTxt: String) -> String {
        var text = ""
        
        guard let date = longFormatter().date(from: timeTxt) else {
            return text
        }
                
        let timeInterval = NSDate().timeIntervalSince(date)
        let dateFormatter = DateFormatter()
        
        if timeInterval < 60 {
            //Giây
            let seconds = seconds(timeInterval, f: "%0.1d")
            text = "\(seconds) seconds ago"
            
        } else if timeInterval >= 60 && timeInterval < (60*60) {
            //Phút
            let minutes = minutes(timeInterval, f: "%0.1d")
            text = "\(minutes) minutes ago"
            
        } else if timeInterval >= (60*60) && timeInterval <= (24*60*60) {
            //Giờ
            let hours = hours(timeInterval, f: "%0.1d")
            text = "\(hours) hours ago"
            
        } else {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            text = dateFormatter.string(from: date)
        }
        
        return text
    }
}
