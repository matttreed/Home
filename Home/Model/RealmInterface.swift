//
//  RealmInterface.swift
//  Home
//
//  Created by Matthew Reed on 12/30/20.
//

import Foundation
import RealmSwift

class RealmInterface {
    
    let realm = try! Realm()
    
    func saveNew(idea: Idea) {
        do {
            try realm.write {
                realm.add(idea)
            }
        } catch {
            print("Error saving new idea: \(error)")
        }
    }
    
    func saveNew(playlist: Playlist) {
        do {
            try realm.write {
                realm.add(playlist)
            }
        } catch {
            print("Error saving new playlist: \(error)")
        }
    }
    
    func loadIdeas() -> Results<Idea> {
        return realm.objects(Idea.self).sorted(byKeyPath: "dateCreated", ascending: false)
    }
    
    func loadPlaylists() -> Results<Playlist> {
        return realm.objects(Playlist.self)
    }
    
    func update(ideaObject: Idea, idea: String? = nil, explanation: String? = nil, playlist: Playlist? = nil) {
        do {
            try realm.write {
                if idea != nil { ideaObject.idea = idea! }
                if explanation != nil { ideaObject.explanation = explanation! }
                if playlist != nil { ideaObject.playlist = playlist! }
            }
        } catch {
            print("Error updating idea.playlist: \(error)")
        }
    }
    
    func delete(idea: Idea) {
        do {
            try realm.write {
                realm.delete(idea)
            }
        } catch {
            print("Error deleting idea: \(error)")
        }
    }
    
    func createBackup(idea: Idea) -> Idea {
        let backup = Idea()
        backup.idea = idea.idea
        backup.explanation = idea.explanation
        backup.playlist = idea.playlist
        backup.dateCreated = idea.dateCreated
        
        return backup
    }
    
    func restoreFromBackup(idea: Idea, backup: Idea) {
        update(ideaObject: idea,
               idea: backup.idea,
               explanation: backup.explanation,
               playlist: backup.playlist)
    }
}
