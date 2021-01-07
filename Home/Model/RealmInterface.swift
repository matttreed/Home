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
    
    let notificationHandler = NotificationHandler()
    
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
                refreshNotifications(for: currentPlaylist)
                removeIdeaFromPlaylist(playlistObject: currentPlaylist, idea: ideaObject)
            }
            if playlist != nil {
                addIdeaToPlaylist(playlistObject: playlist!, idea: ideaObject)
                refreshNotifications(for: playlist!)
            }
            try realm.write {ideaObject.playlist = playlist}
        } catch {
            print("Error updating idea.playlist: \(error)")
        }
    }
    
    func update(playlistObject: Playlist, name: String? = nil, color: String? = nil, frequency: Int? = nil, startTime: String? = nil,
                endTime: String? = nil, days: Int? = nil, isOn: Bool? = nil, lastEdited: String? = nil) {
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
//        print("here")
        refreshNotifications(for: playlistObject)
    }
    
    func refreshNotifications(for playlist: Playlist) {
        
        notificationHandler.removeNotifications(IDs: Array(playlist.pendingNotifications))
        clearNotifications(playlistObject: playlist)
        
        if playlist.frequency == 0 || !playlist.isOn { return }
        
        let startTime = K.data.timeToRow[playlist.startTime]! + 1
        let endTime = K.data.timeToRow[playlist.endTime]! + 1
        let period: Float = Float(endTime - startTime) / Float(playlist.frequency)

        
        let dayToBitMask: [Int: Int] = [1: 64, 2: 32, 3: 16, 4: 8, 5: 4, 6: 2, 7: 1]
        
        for day in 1...7 {
            if (playlist.days & dayToBitMask[day]! != 0) {
                for i in 0..<playlist.frequency {
                    let hour = Int(Float(startTime) + (Float(i) * period))
                    let minutes = Int((Float(i) * period).truncatingRemainder(dividingBy: 1.0) * 60.0)
                    let id = notificationHandler.createNotification(hour: hour, minutes: minutes, day: day, playlist: playlist)
                    addNotification(playlistObject: playlist, ID: id)
                    //print("Notification created on day: \(day) at time: \(hour):\(minutes)")
                }
            }
        }
    }
    
    private func addNotification(playlistObject: Playlist, ID: String) {
        do {
            try realm.write {
                playlistObject.pendingNotifications.append(ID)
            }
        } catch {
            print("Error adding notification to Playlist: \(error)")
        }
    }
    
    private func clearNotifications(playlistObject: Playlist) {
        do {
            try realm.write {
                playlistObject.pendingNotifications.removeAll()
            }
        } catch {
            print("Error clearing notifications from Playlist: \(error)")
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
        refreshNotifications(for: playlistObject)
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
                notificationHandler.removeNotifications(IDs: Array(playlist.pendingNotifications))
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

