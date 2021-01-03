//
//  EditPlaylistViewController.swift
//  Home
//
//  Created by Grant Sheen on 12/30/20.
//

import UIKit

class EditPlaylistViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playlistNameTextField: UITextField!
    @IBOutlet weak var ideaFrequency: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var createOrDeleteButton: UIButton!
    
    @IBOutlet weak var sunday: DayButton!
    @IBOutlet weak var monday: DayButton!
    @IBOutlet weak var tuesday: DayButton!
    @IBOutlet weak var wednesday: DayButton!
    @IBOutlet weak var thursday: DayButton!
    @IBOutlet weak var friday: DayButton!
    @IBOutlet weak var saturday: DayButton!
    
    
    let realmInterface = RealmInterface()
    
    var create: Bool = true
    var playlist: Playlist = Playlist()
    var startTimes = [String]()
    var endTimes = [String]()
    var buttonsDict: [String: DayButton]?
    
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

    }
    
    func initialize() {
        buttonsDict = ["Sun": sunday, "Mon": monday, "Tue": tuesday, "Wed": wednesday, "Thu": thursday, "Fri": friday, "Sat": saturday]
        
        if create {
            doneButton.isHidden = true
            titleLabel.text = "New Playlist"
            createOrDeleteButton.setTitle("Create Playlist", for: .normal)
        } else {
            titleLabel.text = "Edit Playlist"
            createOrDeleteButton.setTitle("Delete Playlist", for: .normal)
            name = playlist.name
            frequency = playlist.frequency
            startTime = playlist.startTime
            endTime = playlist.endTime
            days = playlist.days
        }
        
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
        if create {
            performSegue(withIdentifier: K.segues.editToPlaylists, sender: self)
        } else {
            performSegue(withIdentifier: K.segues.editToViewPlaylist, sender: self)
        }
    }
    
    // MARK: - Update Playlist
    @IBAction func doneButtonPressed(_ sender: Any) {
        if !create {
            realmInterface.update(playlistObject: playlist, name: name, frequency: frequency, startTime: startTime, endTime: endTime, days: days)
            performSegue(withIdentifier: K.segues.editToViewPlaylist, sender: self)
        }
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
            days = days & (K.data.and - K.data.dayToInt[button.titleLabel!.text!]!)
        } else {
            selectButton(button)
            days = days | K.data.dayToInt[button.titleLabel!.text!]!
        }
    }
    
    func deselectButton(_ button: DayButton) {
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        button.backgroundColor = .white
        button.on = false
    }
    
    func selectButton(_ button: DayButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGray2
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
            realmInterface.saveNew(playlist: playlist)
            realmInterface.update(playlistObject: playlist, name: name, frequency: frequency, startTime: startTime, endTime: endTime, days: days)
        } else {
            realmInterface.delete(playlist: playlist)
        }
        
        performSegue(withIdentifier: K.segues.editToPlaylists, sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.editToViewPlaylist {
            let destinationVC = segue.destination as! ViewPlaylistViewController
            destinationVC.selectedPlaylist = playlist
        }
    }

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


