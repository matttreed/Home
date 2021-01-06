//
//  IdeaTableViewCell.swift
//  Home
//
//  Created by Matthew Reed on 12/31/20.
//

import UIKit
import SwipeCellKit

class IdeaCell: SwipeTableViewCell {

    @IBOutlet weak var topRow: UIStackView!
    @IBOutlet weak var playlistViewContainer: UIView!
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateViewContainer: UIView!
    
    var parentVC: ideaCellParentVC?
    var idea: Idea?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewContainer.layer.cornerRadius = 10
        backgroundColor = UIColor.clear
    }
    
    
    
  
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        
        if idea?.explanation != nil {
            if parentVC!.expandedIdeas.contains(idea!.id) {
                cellImage.image = UIImage(systemName: "chevron.down")
                parentVC!.expandedIdeas.remove(idea!.id)
            } else {
                cellImage.image = UIImage(systemName: "chevron.up")
                parentVC!.expandedIdeas.insert(idea!.id)
            }
            UIView.transition(with: explanationContainer, duration: 0.3,
                              options: .curveEaseInOut,
                              animations: {
                                self.explanationContainer.isHidden.toggle()
                          })
            self.parentVC?.ideasTable.beginUpdates()
            self.parentVC?.ideasTable.endUpdates()
        }
    }
    
}
