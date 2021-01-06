//
//  ControlContainableTableView.swift
//  Home
//
//  Created by Matthew Reed on 12/31/20.
//

import UIKit


// this class allows scrolling with buttons in custom cell types
final class ControlContainableTableView: UITableView {
 
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }
 
        return super.touchesShouldCancel(in: view)
    }
 
}
