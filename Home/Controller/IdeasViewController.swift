//
//  IdeasTableViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit
import RealmSwift

class IdeasViewController: UIViewController {
    
    
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
    
    var expandedIdeas = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.register(UINib(nibName: K.ideaCellNibName, bundle: nil), forCellReuseIdentifier: K.identifiers.idea)
        
        //ideasTable.delegate = self
        ideasTable.dataSource = self
        
        newIdeaContainer.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        playlistLabelContainer.layer.cornerRadius = 10
        
        ideasArray = realmInterface.loadIdeas()
        
        ideasTable.estimatedRowHeight = 100
        ideasTable.rowHeight = UITableView.automaticDimension
        
        updateUI()
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
            }
        }
        updateUI()
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
        
        cell.delegate = self
        cell.rowNum = indexPath.row
        
        cell.ideaLabel.text = cellIdea.idea
        
        cell.explanationContainer.isHidden = true
        if cellIdea.explanation != nil {
            cell.explanationLabel.text = cellIdea.explanation
        }
        if expandedIdeas.contains(indexPath.row) {
            // cell should be expanded
            cell.explanationContainer.isHidden = false
            cell.cellImage.image = UIImage(systemName: "chevron.up")
        } else {
            cell.cellImage.image = UIImage(systemName: "chevron.down")
        }
        
        cell.stackViewContainer.layer.cornerRadius = 10
        return cell
    }
}


    

//MARK: - Tableview Delegate

//extension IdeasViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if currentIdea == nil {
//            currentIdea = ideasArray?[indexPath.row] ?? Idea()
//            backupIdea = realmInterface.createBackup(idea: currentIdea!)
//            updateUI()
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}








//extension UIView {
//
//    func fadeIn(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
//        self.alpha = 0
//        self.isHidden = false
//        UIView.animate(withDuration: duration!,
//                       animations: { self.alpha = 1 },
//                       completion: { (value: Bool) in
//                          if let complete = onCompletion { complete() }
//                       }
//        )
//    }
//
//    func fadeOut(_ duration: TimeInterval? = 0.2, onCompletion: (() -> Void)? = nil) {
//        UIView.animate(withDuration: duration!,
//                       animations: { self.alpha = 0 },
//                       completion: { (value: Bool) in
//                           self.isHidden = true
//                           if let complete = onCompletion { complete() }
//                       }
//        )
//    }
//
//}
