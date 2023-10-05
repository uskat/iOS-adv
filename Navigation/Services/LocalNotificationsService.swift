//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Diego Abramoff on 03.10.23.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationsService {
    
    let center = UNUserNotificationCenter.current()

    func registeForLatestUpdatesIfPossible() {

        center.requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
            if result {
                print("✳️Request of authorization from Notification Center confirmed. Result = \(result)")
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "notification.checkUpdate".localized
                    content.body = "..."
                    content.badge = NSNumber(11)
                    content.sound = .defaultRingtone
                    
                    var components = DateComponents()
                    components.hour = 16
                    components.minute = 45
                    components.second = 00
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    self.center.add(request)
                }
            } else {
                print("🆘Request of authorization from Notification Center failed")
            }
        }
    }
}
