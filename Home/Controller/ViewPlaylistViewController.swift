//
//  ViewPlaylistViewController.swift
//  Home
//
//  Created by Grant Sheen on 1/2/21.
//

import Foundation
import UIKit
import RealmSwift

class ViewPlaylistViewController: UIViewController {
    
    @IBOutlet var ideasTable: UITableView! = UITableView()
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var fullIdeaContainer: UIStackView!
    @IBOutlet weak var newIdeaContainer: UIView!
    @IBOutlet weak var newIdeaButton: UIButton!
    @IBOutlet weak var ideaContainer: UIView!
    @IBOutlet weak var ideaField: UITextView!
    @IBOutlet weak var addExplanationContainer: UIView!
    @IBOutlet weak var explanationContainer: UIView!
    @IBOutlet weak var explanationField: UITextView!
    @IBOutlet weak var doneCancelContainer: UIStackView!
    
    let realmInterface = RealmInterface()
    
    var ideas: Results<Idea>?
    var newIdea: Idea? = nil
    var selectedPlaylist: Playlist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideasTable.dataSource = self
        ideasTable.delegate = self
        
        initializeUI()
    }
    
    func initializeUI() {
        ideas = selectedPlaylist?.ideas.sorted(byKeyPath: "dateCreated", ascending: true)
        ideasTable.reloadData()
        
        playlistName.text = selectedPlaylist?.name
        newIdeaContainer.isHidden = false
        ideaContainer.isHidden = true
        addExplanationContainer.isHidden = true
        explanationContainer.isHidden = true
        doneCancelContainer.isHidden = true
        ideaField.text = ""
        explanationField.text = ""
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let parentVC = presentingViewController as! PlaylistsViewController
        parentVC.updateUI()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.segues.editWithinPlaylist, sender: self)
    }
    
    @IBAction func addNewIdeaPressed(_ sender: Any) {
        newIdea = Idea()
        ideaContainer.isHidden = false
        addExplanationContainer.isHidden = false
        doneCancelContainer.isHidden = false
    }
    
    @IBAction func addExplanationPressed(_ sender: Any) {
        explanationContainer.isHidden = !explanationContainer.isHidden
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        newIdea?.dateCreated = Date().description
        realmInterface.saveNew(idea: newIdea!)
        realmInterface.update(ideaObject: newIdea!, idea: ideaField.text!, explanation: explanationField.text!)
        realmInterface.update(ideaObject: newIdea!, playlist: selectedPlaylist)
        
        initializeUI()
        ideasTable.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        initializeUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.editWithinPlaylist {
            let destination = segue.destination as! EditPlaylistViewController
            destination.create = false
            destination.playlist = selectedPlaylist!
        }
    }
    
    func handlePlaylistDeleted() {
        let parentVC = presentingViewController as! PlaylistsViewController
        dismiss(animated: true) {
            parentVC.updateUI()
        }
    }
}


// MARK: - Tableview Data Source

extension ViewPlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideas?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ideasTable.dequeueReusableCell(withIdentifier: K.identifiers.viewPlaylistCell, for: indexPath)

        cell.textLabel?.text = ideas?[indexPath.row].idea ?? "No ideas added yet"
        
        return cell
    }

}


// MARK: - Tableview Delegate

extension ViewPlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
