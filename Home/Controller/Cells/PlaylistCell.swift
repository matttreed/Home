//
//  PlaylistCell.swift
//  Home
//
//  Created by Matthew Reed on 1/3/21.
//

import UIKit
import SwipeCellKit

class PlaylistCell: SwipeTableViewCell {

    @IBOutlet weak var playlistNameContainer: UIView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playlistContainer: UIView!
    @IBOutlet weak var playlistSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var parentVC: PlaylistsViewController? = nil
    var playlist: Playlist? = nil
    
    let realmInterface = RealmInterface()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playlistContainer.layer.cornerRadius = 10
        backgroundColor = UIColor.clear
        
        let stateChanged = UIAction { (action) in
            self.switchValueDidChange()
        }
        playlistSwitch.addAction(stateChanged, for: .valueChanged)
    }
    
    func switchValueDidChange() {
        realmInterface.update(playlistObject: playlist!, isOn: playlistSwitch.isOn)
        realmInterface.refreshNotifications(for: playlist!)
    }
    
}
