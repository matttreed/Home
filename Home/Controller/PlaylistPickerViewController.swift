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
    @IBOutlet weak var pickerContainer: UIView!
    
    let realm = try! Realm()
    
    let realmInterface = RealmInterface()
    
    var parentVC: IdeasViewController? = nil
    
    var parentBlur: UIVisualEffectView?
    
    var playlistArray: Results<Playlist>?
    
    var idea: Idea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistPickerTable.register(UINib(nibName: K.nibs.playlistPickerCellNib, bundle: nil), forCellReuseIdentifier: K.identifiers.playlistCellSelectable)
        
        pickerContainer.layer.cornerRadius = 10
        
        playlistPickerTable.dataSource = self
        playlistPickerTable.delegate = self
        
//        let playlist = Playlist()
//        playlist.name = K.text.randomPlaylist
//        playlist.color = K.text.randomColorString
//        realmInterface.saveNew(playlist: playlist)
        
        playlistArray = realmInterface.loadPlaylists()
        
        let blurEffect = UIBlurEffect(style: .regular)
        parentBlur = UIVisualEffectView(effect: blurEffect)
        parentBlur!.frame = parentVC!.rootView.bounds
        parentVC!.rootView.addSubview(parentBlur!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.playlistCellSelectable, for: indexPath) as! PlaylistPickerCell
        
        if let playlist = playlistArray?[indexPath.row] {
            if playlist.id == idea?.playlist?.id {
                cell.playlistContainer.layer.borderWidth = 3
                cell.playlistContainer.layer.borderColor = UIColor.black.cgColor
            } else {
                cell.playlistContainer.layer.borderWidth = 0
            }
            cell.playlistContainer.layer.backgroundColor = K.colors.getColorFromString(playlist.color).cgColor
        }
        
        cell.playlistLabel.text = playlistArray?[indexPath.row].name ?? "No Playlists Yet"
        return cell
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let newPlaylist = idea?.playlist {
            realmInterface.update(playlistObject: newPlaylist, lastEdited: Date().description)
        }
        
        parentVC?.updateUI()
        parentBlur!.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if idea?.playlist?.id == playlistArray?[indexPath.row].id {
            realmInterface.update(ideaObject: idea!, playlist: nil)
        } else {
            realmInterface.update(ideaObject: idea!, playlist: playlistArray![indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        playlistPickerTable.reloadData()
    }

}
