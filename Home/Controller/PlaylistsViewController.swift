//
//  PlaylistsViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/30/20.
//

import UIKit
import RealmSwift

class PlaylistsViewController: UIViewController {
    
    @IBOutlet weak var createPlaylistButton: UIButton!
    @IBOutlet weak var playlistTable: UITableView!
    
    let realmInterface = RealmInterface()
    
    var playlistArray: Results<Playlist>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playlistTable.delegate = self
        playlistTable.dataSource = self
        
        playlistArray = realmInterface.loadPlaylists()
        
        createPlaylistButton.layer.cornerRadius = 10
    }
    
    @IBAction func ideasTabPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.playlistsToIdeas, sender: self)
    }
    
    @IBAction func createPlaylistPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.createPlaylist, sender: self)
    }
    
   
    
}
    
// MARK: - Tableview Data Source

extension PlaylistsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistArray?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: K.protoypes.playlistCell, for: indexPath)
        
        cell.textLabel?.text = playlistArray?[indexPath.row].name ?? "No Playlists Yet"
        
        return cell
    }
}


// MARK: - Tableview Delegate

extension PlaylistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segues.playlistsToView, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.playlistsToView {
            let destinationVC = segue.destination as! ViewPlaylistViewController
            
            if let indexPath = playlistTable.indexPathForSelectedRow {
                destinationVC.selectedPlaylist = playlistArray?[indexPath.row]
            }
        }
    }

}




    
    
   


