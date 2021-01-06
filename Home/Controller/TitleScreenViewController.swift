//
//  ViewController.swift
//  Home
//
//  Created by Matthew Reed on 12/28/20.
//

import UIKit

class TitleScreenViewController: UIViewController {

    @IBOutlet weak var welcomeToYoursLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 10
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // next button goes to ideas screen
        performSegue(withIdentifier: K.segues.titleToIdeas, sender: self)
    }
    
    
}

