//
//  Playlist.swift
//  Home
//
//  Created by Matthew Reed on 12/30/20.
//

import Foundation
import RealmSwift

class Playlist: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var frequency: Int = 2
    @objc dynamic var startTime: String = "9:00 AM"
    @objc dynamic var endTime: String = "10:00 PM"
    @objc dynamic var days: Int8 = 127
    let ideas: List<Idea> = List<Idea>()
    @objc dynamic var color: String = ""
    @objc dynamic var id: String = UUID().uuidString
}
