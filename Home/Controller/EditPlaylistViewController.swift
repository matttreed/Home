//
//  EditPlaylistViewController.swift
//  Home
//
//  Created by Grant Sheen on 12/30/20.
//

import UIKit

class EditPlaylistViewController: UIViewController {
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playlistNameTextField: UITextField!
    @IBOutlet weak var ideaFrequency: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var createOrDeleteButton: UIButton!
    @IBOutlet weak var settingsStackView: UIStackView!
    
    @IBOutlet weak var daysContainer: UIView!
    @IBOutlet weak var sunday: DayButton!
    @IBOutlet weak var monday: DayButton!
    @IBOutlet weak var tuesday: DayButton!
    @IBOutlet weak var wednesday: DayButton!
    @IBOutlet weak var thursday: DayButton!
    @IBOutlet weak var friday: DayButton!
    @IBOutlet weak var saturday: DayButton!
    
    @IBOutlet weak var gray: UIButton!
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var orange: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var purple: UIButton!
    
    
    let realmInterface = RealmInterface()
    
    var parentVC: PlaylistsViewController? = nil
    var create: Bool = true
    var playlist: Playlist = Playlist()
    var startTimes = [String]()
    var endTimes = [String]()
    var buttonsDict: [String: DayButton]?
    var selectedColorButton: UIButton?
    
    var name: String = ""
    var frequency: Int = 2
    var startTime: String = "9:00 AM"
    var endTime: String = "10:00 PM"
    var days: Int8 = 127
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        playlistNameTextField.delegate = self
        
        initialize()
        
        let gradient = CAGradientLayer()
        gradient.frame = rootView.bounds
        gradient.colors = [UIColor.white.cgColor, CGColor(red: 0.17, green: 0.73, blue: 1, alpha: 0.4)]

        rootView.layer.insertSublayer(gradient, at: 0)
        daysContainer.layer.cornerRadius = 10
        settingsStackView.layer.cornerRadius = 10
        createOrDeleteButton.layer.cornerRadius = 10
        sunday.layer.cornerRadius = 10
        monday.layer.cornerRadius = 10
        tuesday.layer.cornerRadius = 10
        wednesday.layer.cornerRadius = 10
        thursday.layer.cornerRadius = 10
        friday.layer.cornerRadius = 10
        saturday.layer.cornerRadius = 10
        
        gray.layer.cornerRadius = 5
        red.layer.cornerRadius = 5
        orange.layer.cornerRadius = 5
        yellow.layer.cornerRadius = 5
        green.layer.cornerRadius = 5
        blue.layer.cornerRadius = 5
        purple.layer.cornerRadius = 5
    }
    
    func initialize() {
        buttonsDict = ["Sun": sunday, "Mon": monday, "Tue": tuesday, "Wed": wednesday, "Thu": thursday, "Fri": friday, "Sat": saturday]
        let colorsDict = ["" : gray, "playlistRed": red, "playlistOrange": orange, "playlistYellow": yellow, "playlistGreen": green, "playlistBlue": blue, "playlistPurple": purple]
        
        if create {
            doneButton.isHidden = true
            titleLabel.text = "New Playlist"
            createOrDeleteButton.setTitle("Create Playlist", for: .normal)
        } else {
            titleLabel.text = "Edit Playlist"
            createOrDeleteButton.setTitle("Delete Playlist", for: .normal)
            createOrDeleteButton.setTitleColor(UIColor.systemRed, for: .normal)
            name = playlist.name
            frequency = playlist.frequency
            startTime = playlist.startTime
            endTime = playlist.endTime
            days = playlist.days
        }
        
        colorSelected(colorsDict[playlist.color]!!)
        playlistNameTextField.text = name
        ideaFrequency.text = "\(frequency)x"
        startTimes = getTimeList(start: 0)
        endTimes = getTimeList(start: 0)
        pickerView.selectRow(K.data.timeToRow[startTime]!, inComponent: 0, animated: false)
        pickerView.selectRow(K.data.timeToRow[endTime]!, inComponent: 1, animated: false)
        loadDays(days)
    }
    
    
    // MARK: - Cancel Playlist
    
    @IBAction func cancelPlaylistPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update Playlist
    @IBAction func doneButtonPressed(_ sender: Any) {
        if !create {
            realmInterface.update(playlistObject: playlist, name: name, color: selectedColorButton?.accessibilityLabel, frequency: frequency, startTime: startTime, endTime: endTime, days: days)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose Color
    
    @IBAction func colorSelected(_ sender: UIButton) {
        selectedColorButton?.layer.borderWidth = 0
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.black.cgColor
        selectedColorButton = sender
    }
    
    
    // MARK: - Choose Frequency
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if frequency > 0 {
            frequency -= 1
        }
        ideaFrequency.text = "\(frequency)x"
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        frequency += 1
        ideaFrequency.text = "\(frequency)x"
    }
    
    
    // MARK: - Select Days
    
    @IBAction func dayButtonPressed(_ button: DayButton) {
        if button.on {
            deselectButton(button)
            days = days & (K.data.and - K.data.dayToInt[button.accessibilityLabel!]!)
        } else {
            selectButton(button)
            days = days | K.data.dayToInt[button.accessibilityLabel!]!
        }
    }
    
    func deselectButton(_ button: DayButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.on = false
    }
    
    func selectButton(_ button: DayButton) {
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.on = true
    }
    
    func loadDays(_ days: Int8) {
        for (day, num) in K.data.dayToInt {
            if days & num == 0 {
                deselectButton(buttonsDict![day]!)
            }
        }
    }
    
    
    // MARK: - Create Playlist
    
    @IBAction func createOrDeleteButtonPressed(_ sender: Any) {
        if create {
            name = playlistNameTextField.text!
            startTime = startTimes[pickerView.selectedRow(inComponent: 0)]
            endTime = endTimes[pickerView.selectedRow(inComponent: 1)]
            let color = selectedColorButton?.accessibilityLabel
            realmInterface.saveNew(playlist: playlist)
            realmInterface.update(playlistObject: playlist, name: name, color: color, frequency: frequency, startTime: startTime, endTime: endTime, days: days)
            
            //print(playlist)
            
            let parentVC = presentingViewController as! PlaylistsViewController
            parentVC.updateUI()
            self.dismiss(animated: true) {
                //parentVC.performSegue(withIdentifier: K.segues.playlistsToView, sender: parentVC)
            }
        } else {
            realmInterface.delete(playlist: playlist)
            let parentVC = presentingViewController as! ViewPlaylistViewController
            self.dismiss(animated: true) {
                parentVC.handlePlaylistDeleted()
            }
        }
    }
    
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.segues.editToViewPlaylist {
//            let destinationVC = segue.destination as! ViewPlaylistViewController
//            destinationVC.selectedPlaylist = playlist
//        }
//    }

}


// MARK: - Playlist Name

extension EditPlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playlist.name = playlistNameTextField.text!
        playlistNameTextField.endEditing(true)
        return true
    }
}


// MARK: - Time Picker

extension EditPlaylistViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func initializeTimes() {
        startTimes = getTimeList(start: 0)
        endTimes = getTimeList(start: 0)
        pickerView.selectRow(8, inComponent: 0, animated: false)
        pickerView.selectRow(21, inComponent: 1, animated: false)
    }
    
    func getTimeList(start: Int) -> [String] {
        let timeList: [String] = K.data.timeList
        var list: [String] = []
        for i in start...timeList.count-1 {
            list.append(timeList[i])
        }
        return list
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return startTimes.count
            case 1:
                return endTimes.count
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        
        var text = ""
        switch component {
            case 0:
                text = startTimes[row]
            case 1:
                text = endTimes[row]
            default:
                break
        }
        label.text = text
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            endTimes = getTimeList(start: row)
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: false)
        }
    }
    
}


