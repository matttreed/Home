//
//  PlaylistPickerViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/29/20.
//

import UIKit
import RealmSwift

class PlaylistPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var playlistPickerTable: UITableView!
    
    let realm = try! Realm()
    
    let realmInterface = RealmInterface()
    
    var parentVC: IdeasViewController? = nil
    
    var playlistArray: Results<Playlist>?
    
    var idea: Idea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistPickerTable.layer.cornerRadius = 10
        
        playlistPickerTable.dataSource = self
        playlistPickerTable.delegate = self
        
        let playlist = Playlist()
        playlist.name = Date().description
        realmInterface.saveNew(playlist: playlist)
        
        playlistArray = realmInterface.loadPlaylists()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.playlist, for: indexPath)
        
        if let selectedPlaylist = playlistArray?[indexPath.row] {
            if selectedPlaylist.name == idea?.playlist?.name {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        cell.textLabel?.text = playlistArray?[indexPath.row].name ?? "No Playlists Yet"
        return cell
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        parentVC?.updateUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if idea?.playlist == playlistArray?[indexPath.row] {
            realmInterface.update(ideaObject: idea!, playlist: nil)
        } else {
            realmInterface.update(ideaObject: idea!, playlist: playlistArray?[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        playlistPickerTable.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
