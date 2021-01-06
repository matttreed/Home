//
//  PlaylistsViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/30/20.
//

import UIKit
import RealmSwift
import SwipeCellKit

class PlaylistsViewController: UIViewController {
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var createPlaylistButton: UIButton!
    @IBOutlet weak var playlistTable: UITableView!
    
    let realmInterface = RealmInterface()
    
    var playlistArray: Results<Playlist>?
    
    var selectedPlaylist: Playlist? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playlistTable.delegate = self
        playlistTable.dataSource = self
        playlistTable.rowHeight = 120
        
        playlistTable.register(UINib(nibName: K.playlistCellNibName, bundle: nil), forCellReuseIdentifier: K.identifiers.playlistCellFull)
        
        playlistArray = realmInterface.loadPlaylists()
        
        createPlaylistButton.layer.cornerRadius = 10
        
        let gradient = CAGradientLayer()
        gradient.frame = rootView.bounds
        gradient.colors = [UIColor(named: "homeGreen5")!.cgColor, CGColor(red: 0.17, green: 0.73, blue: 1, alpha: 0.4)]

        rootView.layer.insertSublayer(gradient, at: 0)
    }
    
    func updateUI() {
        playlistTable.reloadData()
    }
    
    @IBAction func ideasTabPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createPlaylistPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.createPlaylist, sender: self)
    }
    
   
    
}
    
// MARK: - Tableview Data Source

extension PlaylistsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.playlistCellFull, for: indexPath) as! PlaylistCell
        
        let playlist = playlistArray![indexPath.row]
        
        cell.delegate = self
        cell.parentVC = self
        cell.playlistNameLabel.text = playlist.name
        cell.playlistNameContainer.backgroundColor = K.colors.getColorFromString(playlist.color)
        cell.playlistSwitch.isOn = playlist.isOn
        cell.playlist = playlist
        cell.dateLabel.text = K.text.getNiceDate(date: playlist.lastEdited)
        
        return cell
    }
}


// MARK: - Tableview Delegate

extension PlaylistsViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.playlistsToView {
            let destinationVC = segue.destination as! ViewPlaylistViewController
            
            if let playlist = selectedPlaylist {
                destinationVC.selectedPlaylist = playlist
            }
        }
    }

}

//MARK: - SwipeCell Delegate

extension PlaylistsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete playlist")
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
//        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
//            self.performSegue(withIdentifier: K.segues.playlistsToView, sender: self)
//        }
//
//        editAction.image = UIImage(named: "pencil")

        return [deleteAction]
    }

//    func visibleRect(for tableView: UITableView) -> CGRect? {
//        return tableView.safeAreaLayoutGuide.layoutFrame
//    }
}




    
    
   


