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

    func registeForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "notification.checkUpdate".localized
        content.body = "..."
        content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
        content.sound = .defaultRingtone
        
        var components = DateComponents()
        components.hour = 12
        components.minute = 17
        components.second = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}
