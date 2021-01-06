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
        return realm.objects(Playlist.self).sorted(byKeyPath: "lastEdited", ascending: false)
    }
    
    func update(ideaObject: Idea, idea: String? = nil, explanation: String? = nil) {
        do {
            try realm.write {
                if idea != nil { ideaObject.idea = idea! }
                if explanation != nil { ideaObject.explanation = explanation! }
            }
        } catch {
            print("Error updating idea: \(error)")
        }
    }
    
    func update(ideaObject: Idea, playlist: Playlist?) {
        do {
            if let currentPlaylist = ideaObject.playlist {
                removeIdeaFromPlaylist(playlistObject: currentPlaylist, idea: ideaObject)
            }
            if playlist != nil {
                addIdeaToPlaylist(playlistObject: playlist!, idea: ideaObject)
            }
            try realm.write {ideaObject.playlist = playlist}
        } catch {
            print("Error updating idea.playlist: \(error)")
        }
    }
    
    func update(playlistObject: Playlist, name: String? = nil, color: String? = nil, frequency: Int? = nil, startTime: String? = nil,
                endTime: String? = nil, days: Int8? = nil, isOn: Bool? = nil, lastEdited: String? = nil) {
        do {
            try realm.write {
                if name != nil { playlistObject.name = name! }
                if color != nil { playlistObject.color = color! }
                if frequency != nil { playlistObject.frequency = frequency! }
                if startTime != nil { playlistObject.startTime = startTime! }
                if endTime != nil { playlistObject.endTime = endTime! }
                if days != nil { playlistObject.days = days! }
                if isOn != nil { playlistObject.isOn = isOn! }
                if lastEdited != nil { playlistObject.lastEdited = lastEdited! }
            }
        } catch {
            print("Error updating playlist: \(error)")
        }
    }
    
    private func addIdeaToPlaylist(playlistObject: Playlist, idea: Idea) {
        do {
            try realm.write {
                playlistObject.ideas.append(idea)
            }
        } catch {
            print("Error adding idea to playlist: \(error)")
        }
        
    }
    
    private func removeIdeaFromPlaylist(playlistObject: Playlist, idea: Idea) {
        do {
            try realm.write {
                playlistObject.ideas.remove(at: playlistObject.ideas.index(of: idea)!)
            }
        } catch {
            print("Error adding idea to playlist: \(error)")
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
    
    func delete(playlist: Playlist) {
        do {
            try realm.write {
                realm.delete(playlist)
            }
        } catch {
            print("Error deleting playlist: \(error)")
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
               explanation: backup.explanation)
        update(ideaObject: idea, playlist: backup.playlist)
    }

    
    func validateData() {
        let playlists = loadPlaylists()
        let ideas = loadIdeas()
        
        for playlist in playlists {
            for idea in playlist.ideas {
                var found = false
                
                for i in ideas {
                    if i.id == idea.id {found = true}
                }
                
                if !found {
                    print("\(idea.id) in \(playlist.name), but not in general list")
                    return
                }
            }
        }
        
        for idea in ideas {
            if let parentPlaylist = idea.playlist {
                var found = false
                
                for i in parentPlaylist.ideas {
                    if i.id == idea.id { found = true }
                }
                
                if !found {
                    print("\(idea.id) lists \(parentPlaylist.name) as parent playlist, but is not contained within it")
                }
            }
        }
    }
}

