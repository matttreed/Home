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
//        let shadowSize: CGFloat = 20
//        let contactRect = CGRect(x: -shadowSize, y: testDropShadow.frame.height - (shadowSize * 0.4), width: testDropShadow.frame.width + shadowSize * 2, height: shadowSize)
//        testDropShadow.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
//        testDropShadow.layer.shadowRadius = 5
//        testDropShadow.layer.shadowOpacity = 0.4
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // next button goes to ideas screen
        performSegue(withIdentifier: K.segues.titleToIdeas, sender: self)
    }
    
    
}

