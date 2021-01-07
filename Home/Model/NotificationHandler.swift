//
//  NotificationHandler.swift
//  Home
//
//  Created by Matthew Reed on 1/6/21.
//

import Foundation
import UIKit

class NotificationHandler {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func createNotification(hour: Int, minutes: Int, day: Int, playlist: Playlist) -> String {
        let content = UNMutableNotificationContent()
        content.title = playlist.name
        content.body = playlist.ideas.randomElement()?.idea ?? "Empty Playlist"
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)

        dateComponents.weekday = day // 1-7
        dateComponents.hour = hour
        dateComponents.minute = minutes
        dateComponents.timeZone = TimeZone.current
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        notificationCenter.add(request) { (error) in
           if error != nil {
            print("Error scheduling notification: \(error.debugDescription)")
           }
        }
        
//        notificationCenter.getPendingNotificationRequests(){[unowned self] requests in
//            for request in requests {
//                guard let trigger = request.trigger as? UNCalendarNotificationTrigger else {return}
//                print(trigger.nextTriggerDate()?.description)
//            }
//        }
        return uuidString
    }

    func removeNotifications(IDs: [String]) {
        //print(IDs)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: IDs)
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let e = error { print(e) }
        }
    }
    
    
}
