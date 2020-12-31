//
//  IdeaTableViewCell.swift
//  Home
//
//  Created by Matthew Reed on 12/31/20.
//

import UIKit

class IdeaCell: UITableViewCell {

    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet weak var cellStackView: UIStackView!
    @IBOutlet weak var ideaLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    
    var delegate: IdeasViewController?
    var rowNum: Int = -1
    
  
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        if delegate!.expandedIdeas.contains(rowNum) {
            delegate!.expandedIdeas.remove(rowNum)
        } else {
            delegate!.expandedIdeas.insert(rowNum)
        }
        delegate?.updateUI()
    }
    
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
