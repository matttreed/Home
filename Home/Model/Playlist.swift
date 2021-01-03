//
//  Playlist.swift
//  Home
//
//  Created by Matthew Reed on 12/30/20.
//

import Foundation
import RealmSwift

class Playlist: Object {
    @objc dynamic var name: String = "playlist uninit."
    @objc dynamic var color: String = ""
    @objc dynamic var id: String = UUID().uuidString
}
