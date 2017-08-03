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
    var DatePickerView  : UIDatePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatePickerView.datePickerMode = UIDatePickerMode.date
        eventDateTextField.inputView = DatePickerView
        DatePickerView.addTarget(self, action: #selector(CreateEventViewController.handleDatePicker), for: UIControlEvents.valueChanged)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleDatePicker()
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy hh:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
//        let date: NSDate? = dateFormatterGet.date(from: "2016-02-29 12:24:26")
//        print(dateFormatterPrint.stringFromDate(date!))
        
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
        performSegue(withIdentifier: "unwindToCreateEventHomeSegue", sender: self)
    }
    
}
