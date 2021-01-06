//
//  PlaylistPickerCell.swift
//  Home
//
//  Created by Matthew Reed on 1/6/21.
//

import UIKit

class PlaylistPickerCell: UITableViewCell {

    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var playlistContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playlistContainer.layer.cornerRadius = 10
    }
    
}
