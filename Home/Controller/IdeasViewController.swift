//
//  IdeasTableViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit
import RealmSwift
import SwipeCellKit


protocol ideaCellParentVC {
    var expandedIdeas: Set<String> { get set }
    var ideasTable: UITableView! { get set }
}

class IdeasViewController: UIViewController, ideaCellParentVC {
    
    
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var AddStackViewContainer: UIView!
    @IBOutlet weak var componentsOfAddIdea: UIView!
    @IBOutlet weak var ideasTable: UITableView!
    @IBOutlet weak var newIdeaContainer: UIStackView!
    @IBOutlet weak var addNewIdeaContainer: UIView!
    @IBOutlet weak var ideaContainer: UIView!
    @IBOutlet weak var addExplanationContainer: UIView!
    @IBOutlet weak var explanationContainer: UIView!
    @IBOutlet weak var playlistSelectContainer: UIView!
    @IBOutlet weak var addCancelContainer: UIStackView!
    @IBOutlet weak var ideaTextView: UITextView!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var addExplanationButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var playlistLabelContainer: UIView!
    @IBOutlet weak var playlistLabel: UILabel!
    
    
    let realmInterface = RealmInterface()
    
    var ideasArray: Results<Idea>?
    
    var currentIdea: Idea? = nil
    var backupIdea: Idea? = nil
    
    var expandedIdeas = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.register(UINib(nibName: K.nibs.ideaCellNib, bundle: nil), forCellReuseIdentifier: K.identifiers.idea)
        
        ideasTable.delegate = self
        ideasTable.dataSource = self
        ideaTextView.delegate = self
        
        newIdeaContainer.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        playlistLabelContainer.layer.cornerRadius = 10
        
        ideasArray = realmInterface.loadIdeas()
        
        ideasTable.estimatedRowHeight = 100
        ideasTable.rowHeight = UITableView.automaticDimension
        
        let gradient = CAGradientLayer()
        gradient.frame = rootView.bounds
        gradient.colors = [UIColor(named: "blueGradient")!.cgColor, UIColor(named: "homeBlue6")!.cgColor]

        rootView.backgroundColor = UIColor.white
        rootView.layer.insertSublayer(gradient, at: 0)
        
        // used for testing Realm
//        realmInterface.validateData()
        
        
        updateUI()
    }
    
    
    @IBAction func playlistTabPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.ideasToPlaylists, sender: self)
    }
    
    func addDropShadow(view: UIView) {
        let shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    @IBAction func addNewIdeaPressed(_ sender: UIButton) {
        currentIdea = Idea()
        realmInterface.saveNew(idea: currentIdea!)
        updateUI()
    }
    
    
    @IBAction func addExplanationPressed(_ sender: UIButton) {
        realmInterface.update(ideaObject: currentIdea!, idea: ideaTextView.text, explanation: "")
        updateUI()
    }
    
    @IBAction func addToPlaylistPressed(_ sender: Any) {
        realmInterface.update(ideaObject: currentIdea!,
                              idea: ideaTextView.text,
                              explanation: (explanationTextView.text == "") ? nil : explanationTextView.text)
        performSegue(withIdentifier: K.segues.pickPlaylist, sender: self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let safeIdea = currentIdea {
            if ideaTextView.text == "" {
                errorLabel.text = "Write an idea"
            } else {
                var explanation = explanationTextView.text
                if explanation == "" { explanation = nil }
                realmInterface.update(ideaObject: safeIdea,
                                      idea: ideaTextView.text,
                                      explanation: explanation)
                currentIdea = nil
                errorLabel.text = ""
                backupIdea = nil
                updateUI()
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        if backupIdea == nil {
            realmInterface.delete(idea: currentIdea!)
        } else {
            realmInterface.restoreFromBackup(idea: currentIdea!, backup: backupIdea!)
        }
        currentIdea = nil
        backupIdea = nil
        errorLabel.text = ""
        updateUI()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.segues.pickPlaylist {
            let destination = segue.destination as! PlaylistPickerViewController
            destination.parentVC = self
            destination.idea = currentIdea
        }
    }
    
    func updateUI() {
        if currentIdea == nil {
            self.addNewIdeaContainer.isHidden = false
            self.ideaContainer.isHidden = true
            self.addExplanationContainer.isHidden = true
            self.explanationContainer.isHidden = true
            self.playlistSelectContainer.isHidden = true
            self.addCancelContainer.isHidden = true
            self.ideaTextView.text = ""
            self.explanationTextView.text = ""
            
        } else {
            self.playlistLabelContainer.backgroundColor = K.colors.getColorFromString(currentIdea!.playlist?.color)
            self.addNewIdeaContainer.isHidden = true
            self.ideaTextView.text = self.currentIdea?.idea
            self.playlistLabel.text = (self.currentIdea?.playlist == nil) ? "General" : self.currentIdea?.playlist?.name
            self.addNewIdeaContainer.isHidden = true
            self.ideaContainer.isHidden = false
            if self.currentIdea?.explanation == nil {
                self.addExplanationContainer.isHidden = false
                self.explanationContainer.isHidden = true
                self.explanationTextView.text = nil
            } else {
                self.addExplanationContainer.isHidden = true
                self.explanationContainer.isHidden = false
                self.explanationTextView.text = self.currentIdea?.explanation
            }
            self.playlistSelectContainer.isHidden = false
            
            self.addCancelContainer.isHidden = false
            self.ideasTable.reloadData()
            
        }
        self.ideasTable.reloadData()
    }
}












// MARK: - Tableview Data Source

extension IdeasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideasArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.idea, for: indexPath) as! IdeaCell
        let cellIdea = ideasArray![indexPath.row]
        
        cell.idea = cellIdea
        
        cell.parentVC = self
        cell.delegate = self
        
        cell.ideaLabel.text = cellIdea.idea.trimmingCharacters(in: [" ", "\n"])
        
        cell.explanationContainer.isHidden = true
        
        if cellIdea.explanation == nil {
            cell.cellImage.isHidden = true
        } else {
            cell.cellImage.isHidden = false
            cell.explanationLabel.text = cellIdea.explanation
            
            if expandedIdeas.contains(cellIdea.id) {
                // cell should be expanded
                cell.explanationContainer.isHidden = false
                cell.cellImage.image = UIImage(systemName: "chevron.up")
            } else {
                cell.cellImage.image = UIImage(systemName: "chevron.down")
            }
        }
        
        cell.playlistLabel.text = cellIdea.playlist?.name ?? "General"
        cell.playlistViewContainer.backgroundColor = K.colors.getColorFromString(cellIdea.playlist?.color)
        
        
        cell.dateLabel.text = K.text.getNiceDate(date: cellIdea.dateCreated)
        
        return cell
    }
}

extension IdeasViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ideasArray?[indexPath.row].id == currentIdea?.id { return 0 }
        return ideasTable.rowHeight
    }
}

extension IdeasViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteCheck(idea: self.ideasArray![indexPath.row])
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            if self.currentIdea == nil {
                self.currentIdea = self.ideasArray?[indexPath.row] ?? Idea()
                self.backupIdea = self.realmInterface.createBackup(idea: self.currentIdea!)
                self.updateUI()
            }
        }
        
        editAction.backgroundColor = K.colors.border
        
        editAction.image = UIImage(named: "pencil")
        
        return [deleteAction, editAction]
    }
    
    func visibleRect(for tableView: UITableView) -> CGRect? {
        return tableView.safeAreaLayoutGuide.layoutFrame
    }
    
    func deleteCheck(idea: Idea) {
        // create the alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure you would like to delete this idea?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (alertAction) in
            self.realmInterface.delete(idea: idea)
            self.updateUI()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


extension IdeasViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (ideaTextView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count < 200 {
            if text == "\n" {
                let lines = newText.components(separatedBy: "\n")
                if lines.count > 5 {
                    errorLabel.text = "Max lines = 5"
                    return false
                }
            }
            return true
        }
        errorLabel.text = "Max characters = 200"
        return false
    }
}
