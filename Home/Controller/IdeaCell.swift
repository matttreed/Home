//
//  IdeaTableViewCell.swift
//  Home
//
//  Created by Matthew Reed on 12/31/20.
//

import UIKit
import SwipeCellKit

class IdeaCell: SwipeTableViewCell {

    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    
    var parentVC: IdeasViewController?
    var idea: Idea?
    
  
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        if idea?.explanation != nil {
            if parentVC!.expandedIdeas.contains(idea!.id) {
                parentVC!.expandedIdeas.remove(idea!.id)
            } else {
                parentVC!.expandedIdeas.insert(idea!.id)
            }
            parentVC?.updateUI()
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackViewContainer.layer.cornerRadius = 10
        
//        stackViewContainer.layer.shadowOpacity = 1
//        stackViewContainer.layer.shadowPath = UIBezierPath(rect: stackViewContainer.bounds).cgPath
//        stackViewContainer.layer.shadowRadius = 5
//        stackViewContainer.layer.shadowOffset = .zero
//        stackViewContainer.layer.shadowOpacity = 1
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
