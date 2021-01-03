//
//  Constants.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import Foundation
import UIKit

struct K {
    static let ideaCellNibName = "IdeaCell"
    
    struct identifiers {
        static let idea = "ideaPrototype"
        //static let createIdea = "createIdeaPrototype"
        static let playlist = "playlistCellPrototype"
    }
    struct segues {
        static let titleToIdeas = "titleToIdeasSegue"
        static let editIdea = "editIdeaSegue"
        static let pickPlaylist = "pickPlaylistSegue"
    }
    struct colors {
        static let playlistRed = UIColor(named: "playlistRed")
        static let playlistGreen = UIColor(named: "playlistGreen")
        static let playlistBlue = UIColor(named: "playlistBlue")
        static let playlistPurple = UIColor(named: "playlistPurple")
        static let playlistOrange = UIColor(named: "playlistOrange")
        static let playlistYellow = UIColor(named: "playlistYellow")
        static var randomColor: UIColor {
            get {
                return [playlistRed, playlistBlue, playlistGreen, playlistPurple, playlistOrange, playlistYellow].randomElement()!!
            }
        }
        static func getColorFromString(_ color: String?) -> UIColor {
            if color == nil {return UIColor.gray}
            return UIColor(named: color!) ?? UIColor.gray
        }
    }
    struct text {
        static var randomPlaylist: String {
            get {
                return ["Buddhism", "Self Help", "Astrology", "App Ideas", "Success"].randomElement()!
            }
        }
        static var randomColorString: String {
            get {
                return ["playlistRed", "playlistBlue", "playlistGreen", "playlistPurple", "playlistOrange", "playlistYellow"].randomElement()!
            }
        }
        
        static func getSubstring(of original: String, from start: Int, to end: Int) -> String {
            return String(original[original.index(original.startIndex, offsetBy: start)...original.index(original.startIndex, offsetBy: end)])
        }
        
        static func getNiceDate(date: String) -> String {
            let getFormatter = DateFormatter()
            getFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let printFormatter = DateFormatter()
            printFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let date = getFormatter.date(from: getSubstring(of: date, from: 0, to: 18))
            return printFormatter.string(from: date!)
        }
    }
}
