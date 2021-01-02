//
//  IdeasTableViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit
import RealmSwift
import SwipeCellKit

class IdeasViewController: UIViewController {
    
    
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
        
        ideasTable.register(UINib(nibName: K.ideaCellNibName, bundle: nil), forCellReuseIdentifier: K.identifiers.idea)
        
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
        gradient.colors = [UIColor.white.cgColor, CGColor(red: 0.17, green: 0.73, blue: 1, alpha: 0.4)]

        rootView.layer.insertSublayer(gradient, at: 0)
        
        rootView.backgroundColor = UIColor.white

        
        updateUI()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        addDropShadow(view: newIdeaContainer)
//    }
//
    
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
        currentIdea?.dateCreated = Date().description
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
            addNewIdeaContainer.isHidden = false
            ideaContainer.isHidden = true
            addExplanationContainer.isHidden = true
            explanationContainer.isHidden = true
            playlistSelectContainer.isHidden = true
            addCancelContainer.isHidden = true
            ideaTextView.text = ""
            explanationTextView.text = ""
            
        } else {
            
            addNewIdeaContainer.isHidden = true
            ideaTextView.text = currentIdea?.idea
            playlistLabel.text = (currentIdea?.playlist == nil) ? "General" : currentIdea?.playlist?.name
            addNewIdeaContainer.isHidden = true
            ideaContainer.isHidden = false
            //ideaContainer.isHidden = false
            if currentIdea?.explanation == nil {
                addExplanationContainer.isHidden = false
                explanationContainer.isHidden = true
                explanationTextView.text = nil
            } else {
                addExplanationContainer.isHidden = true
                explanationContainer.isHidden = false
                explanationTextView.text = currentIdea?.explanation
            }
            playlistSelectContainer.isHidden = false
            
            addCancelContainer.isHidden = false
        }
        
        ideasTable.reloadData()
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
        
        cell.backgroundColor = UIColor.clear
        
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
            self.expandedIdeas.remove(self.ideasArray![indexPath.row].id)
            self.realmInterface.delete(idea: self.ideasArray![indexPath.row])
            self.updateUI()
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
        
        editAction.image = UIImage(named: "pencil")

        return [deleteAction, editAction]
    }

    func visibleRect(for tableView: UITableView) -> CGRect? {
        return tableView.safeAreaLayoutGuide.layoutFrame
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
