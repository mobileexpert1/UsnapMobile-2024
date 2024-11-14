//
//  CustomDateViewController.swift
//  Usnap
//
//  Created by CSPC141 on 13/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

//custom delegate method to pass the date selected to view controllers
@objc protocol DateChangedDelegate : class {
    func dateSelected(_ date : String)
}

class CustomDateViewController: AbstractControl {
    
    @IBOutlet var datePickerHolder: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    
    var selectedDate: String!
    var dateFormat = String()
     var delegate: DateChangedDelegate?
    
    var screenType = String()
    
    
    // Class Function
    class func showControl() {
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()

    }

    
    class func showControl(_ pickerType : String) -> CustomDateViewController {
        let control = self.control as! CustomDateViewController
        control.screenType = pickerType
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
        return control
    }
    
    override func viewDidLoad() {
       // self.bgImageBool = false
        super.viewDidLoad()
        datePicker.backgroundColor = UIColor.white
        datePicker.setValue(solidPinkBorderColor, forKeyPath: "textColor")
        backButton.touchUpInsideBlock {
            self.dismiss(animated: true, completion: nil)
          //  self.view.removeFromSuperview()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("datePicked = ",datePicked as Any)
        if selectedDate != nil{
            delegate?.dateSelected(selectedDate!)
        }else{
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let crntDate  = dateFormatter.string(from: Date())
            //datePicked = crntDate
            delegate?.dateSelected(crntDate)
        }
//        let dateDoneObserver = NotificationCenter.default
//        dateDoneObserver.post(name:Notification.Name(rawValue:ConstantsKeys.DATEPICKERNOTIFICATION_KEY),
//                object: nil,
//                userInfo: ["date":datePicked!])
    }
    
    @IBAction func cancelButton(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Apply date format
        selectedDate = dateFormatter.string(from: sender.date)
        //datePicked = selectedDate
    }
}
