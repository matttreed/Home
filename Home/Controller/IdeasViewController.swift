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
    
    // RAM storage for list of ideas
    var ideasArray: Results<Idea>?
    
    var currentIdea: Idea? = nil
    
    var backupIdea: Idea? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.delegate = self
        ideasTable.dataSource = self
        
        newIdeaContainer.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        playlistLabelContainer.layer.cornerRadius = 10
        
//        NewIdeaContainer.layer.borderWidth = 1
//        NewIdeaContainer.layer.borderColor = UIColor.systemGray2.cgColor
        
        ideasArray = realmInterface.loadIdeas()
        
        componentsOfAddIdea.frame.size.height = 70
        
        ideasTable.estimatedRowHeight = 100
        ideasTable.rowHeight = UITableView.automaticDimension
        
        reloadUI()
    }
    
    
    @IBAction func addNewIdeaPressed(_ sender: UIButton) {
        currentIdea = Idea()
        currentIdea?.dateCreated = Date().description
        realmInterface.saveNew(idea: currentIdea!)
        reloadUI()
    }
    

    @IBAction func addExplanationPressed(_ sender: UIButton) {
        realmInterface.update(ideaObject: currentIdea!, idea: ideaTextView.text, explanation: "")
        reloadUI()
    }
    
    @IBAction func addToPlaylistPressed(_ sender: Any) {
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
        reloadUI()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        if backupIdea == nil {
            realmInterface.delete(idea: currentIdea!)
        } else {
            realmInterface.restoreFromBackup(idea: currentIdea!, backup: backupIdea!)
        }
        currentIdea = nil
        backupIdea = nil
        reloadUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == K.segues.editIdea) {
            let destination = segue.destination as! EditIdeaViewController
            destination.parentVC = self
        } else if (segue.identifier == K.segues.pickPlaylist) {
            let destination = segue.destination as! PlaylistPickerViewController
            destination.parentVC = self
            destination.idea = currentIdea
        }
    }
    
    func reloadUI() {
        
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
            ideaContainer.isHidden = false
            ideaTextView.text = currentIdea?.idea
            playlistLabel.text = (currentIdea?.playlist == nil) ? "General" : currentIdea?.playlist?.name
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
        return ideasArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.protoypes.idea, for: indexPath)
        
        if currentIdea?.dateCreated == ideasArray?[indexPath.row].dateCreated {
            cell.textLabel?.text = "EDITING"
        } else {
            cell.textLabel?.text = ideasArray?[indexPath.row].idea ?? "No Ideas Yet"
        }
        return cell
    }
}
    

//MARK: - Tableview Delegate

extension IdeasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIdea == nil {
            currentIdea = ideasArray?[indexPath.row] ?? Idea()
            backupIdea = realmInterface.createBackup(idea: currentIdea!)
            reloadUI()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
