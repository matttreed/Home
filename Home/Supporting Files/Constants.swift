//
//  Constants.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import Foundation

struct K {
    struct protoypes {
        static let idea = "ideaPrototype"
        static let playlistCell = "PlaylistCell"
        static let viewPlaylistCell = "viewPlaylistCell"
        static let createIdea = "createIdeaPrototype"
        static let playlist = "playlistCellPrototype"
    }
    struct segues {
        static let titleToIdeas = "titleToIdeasSegue"
        static let editIdea = "editIdeaSegue"
        static let pickPlaylist = "pickPlaylistSegue"
        static let createPlaylist = "createPlaylist"
        static let editToPlaylists = "editToPlaylistsSegue"
        static let ideasToPlaylists = "ideasToPlaylists"
        static let playlistsToIdeas = "playlistsToIdeas"
        static let playlistsToView = "playlistsToView"
        static let viewToPlaylists = "viewToPlaylists"
        static let editWithinPlaylist = "editWithinPlaylist"
        static let editToViewPlaylist = "editToViewPlaylist"
    }
    struct data {
        static let timeList = ["1:00 AM","2:00 AM","3:00 AM","4:00 AM","5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM","10:00 AM","11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 AM"]
        static let timeToRow = ["1:00 AM": 0, "2:00 AM": 1, "3:00 AM": 2, "4:00 AM": 3,"5:00 AM": 4, "6:00 AM": 5, "7:00 AM": 6, "8:00 AM": 7, "9:00 AM": 8,"10:00 AM": 9, "11:00 AM": 10, "12:00 PM": 11, "1:00 PM": 12, "2:00 PM": 13, "3:00 PM": 14, "4:00 PM": 15, "5:00 PM": 16, "6:00 PM": 17, "7:00 PM": 18, "8:00 PM": 19, "9:00 PM": 20, "10:00 PM": 21, "11:00 PM": 22, "12:00 AM": 23]
        static let dayToInt: [String: Int8] = ["Sun": 64, "Mon": 32, "Tue": 16, "Wed": 8, "Thu": 4, "Fri": 2, "Sat": 1]
        static let and: Int8 = 127
    }
}
