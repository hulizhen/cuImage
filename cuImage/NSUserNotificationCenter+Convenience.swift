//
//  NSUserNotificationCenter+Convenience.swift
//  cuImage
//
//  Created by Lizhen Hu on 12/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

extension NSUserNotificationCenter {
    func deliverNotification(with title: String, subtitle: String = "", informativeText: String = "",
                                 soundName: String = NSUserNotificationDefaultSoundName) {
        let notification = NSUserNotification()        
        notification.title = title
        notification.subtitle = subtitle
        notification.informativeText = informativeText
        notification.soundName = soundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}
