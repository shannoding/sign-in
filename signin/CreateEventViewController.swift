//
//  CreateEventViewController.swift
//  signin
//
//  Created by Shannon Ding on 7/25/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    
    @IBOutlet weak var createEventButton: UIButton!
    var DatePickerView  : UIDatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        eventDateTextField.inputView = DatePickerView
        DatePickerView.addTarget(self, action: #selector(CreateEventViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        eventNameTextField.addTarget(self, action: #selector(checkNameMaxLength(_ :)), for: .editingChanged)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkNameMaxLength(_ textField: UITextField!) {
        if (textField.text!.characters.count > 50) {
            textField.deleteBackward()
        }
    }
    
    func handleDatePicker()
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd hh:mm a"
        
        dateFormatterGet.amSymbol = "AM"
        dateFormatterGet.pmSymbol = "PM"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, hh:mm a"
        dateFormatterPrint.amSymbol = "AM"
        dateFormatterPrint.pmSymbol = "PM"
        
        
        
        eventDateTextField.text =  dateFormatterPrint.string(from: DatePickerView.date)
    }
    @IBAction func createEventButtonTapped(_ sender: UIButton) {
        guard let eventName = eventNameTextField.text,
            let eventDate = eventDateTextField.text,
            !eventName.isEmpty,
            !eventDate.isEmpty
            else {
                
                let alertController = UIAlertController(title: "Incomplete Fields", message:
                    "Please do not leave the event fields blank.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
        }
        
        EventService.create(eventName: eventName, groupKey: HomeViewController.groupSelected!.key, uid: User.current.uid, eventTime: eventDate)
        self.createEventButton.setTitle("Created Event!", for: .normal)
        self.createEventButton.backgroundColor = RandomColor.green
        performSegue(withIdentifier: "unwindToCreateEventHomeSegue", sender: self)
    }
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
         self.view.endEditing(true)
    }
    
}
