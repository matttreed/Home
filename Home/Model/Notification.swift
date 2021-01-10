//
//  Notification.swift
//  Home
//
//  Created by Matthew Reed on 1/8/21.
//

import Foundation
import RealmSwift

class Notification: Object {
    @objc dynamic var playlist: Playlist? = nil
    @objc dynamic var idea: Idea? = nil
    @objc dynamic var day: Int = -1
    @objc dynamic var hour: Int = -1
    @objc dynamic var minutes: Int = -1
    @objc dynamic var id: String = ""
}
