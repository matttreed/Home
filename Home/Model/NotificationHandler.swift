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
    
    //let realmInterface = RealmInterface()
    
    func createNotification(hour: Int, minutes: Int, day: Int, playlist: Playlist) -> Notification {
        let notification = Notification()
        notification.day = day
        notification.hour = hour
        notification.minutes = minutes
        notification.playlist = playlist
        notification.id = UUID().uuidString
        notification.idea = playlist.ideas.randomElement()
        
        
        
        let content = UNMutableNotificationContent()
        content.title = notification.playlist?.name ?? "Error Loading Playlist"
        content.body = notification.idea?.idea ?? "Error Loading Idea"
        content.sound = .default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)

        dateComponents.weekday = notification.day // 1-7
        dateComponents.hour = notification.hour
        dateComponents.minute = notification.minutes
        dateComponents.timeZone = TimeZone.current
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        // Create the request
        let request = UNNotificationRequest(identifier: notification.id,
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
        return notification
    }

    func removeNotifications(IDs: [Notification]) {
        //print(IDs)
        let idStrings = IDs.map { (notification) -> String in
            return notification.id
        }
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: idStrings)
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let e = error { print(e) }
        }
    }
    
    
}
