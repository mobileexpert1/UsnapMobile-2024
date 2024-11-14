//
//  CustomPickerViewController.swift
//  Usnap
//
//  Created by CSPC141 on 22/03/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

@objc protocol pickerChangedvalueDelegate : class {
    func pickerValueSelected(_ pickerValue : String, _ valueId : String)
}

class CustomPickerViewController: AbstractControl, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    var userOldCampaigns = [NewCampaignDatacampaign]()
    var campaignStaffMembers = [NewCampaignDatastaffMembers]()
    var allCatagories = [BaseAllCatagoriesresult]()
    var campaignStatus = [String]()
    var selectedValue: String! = ""
    var SelectedIndex: String! = ""
    var currentDataType: String!
    var delegate: pickerChangedvalueDelegate?
    
    // Class Function
    class func showControl(_ pickerType : String) -> CustomPickerViewController {
        let control = self.control as! CustomPickerViewController
        control.currentDataType = pickerType
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
        return control
    }

    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
       currentDataType = MiscDetailStore.sharedInstance.pickerTye
        
        pickerView.backgroundColor = UIColor.white
        pickerView.setValue(solidPinkBorderColor, forKeyPath: "textColor")
        backButton.touchUpInsideBlock {
             self.dismiss(animated: true, completion: nil)
//            self.view.removeFromSuperview()
        }
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        userOldCampaigns = MiscDetailStore.sharedInstance.pickerDataOldCampaigns
        campaignStaffMembers = MiscDetailStore.sharedInstance.staffMembers
        allCatagories = MiscDetailStore.sharedInstance.allCatories
        campaignStatus = MiscDetailStore.sharedInstance.statusArray
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }

    //The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //The number of rows of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
  
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // FOR STAFF MEMBERS
        if currentDataType == "StaffMembers" {
            return "\(String(describing: campaignStaffMembers[row].userFirstName!)) \(String(describing: campaignStaffMembers[row].userLastName!))"
        }//FOR CAMPGAINS CATAGORIES
       else if currentDataType == "Catagories" {
            return allCatagories[row].categoryName
        }
        
            // FOR CAMPGAINS CATAGORIES
        else if currentDataType == "campaignStatus" {
            return campaignStatus[row]
        }
        return userOldCampaigns[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentDataType == "StaffMembers" {
            return campaignStaffMembers.count
        }//FOR CAMPGAINS CATAGORIES
        else if currentDataType == "Catagories" {
            return allCatagories.count
        }// FOR CAMPGAINS Status
        else if currentDataType == "campaignStatus" {
            return campaignStatus.count
        }
        return userOldCampaigns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentDataType == "StaffMembers" {
            selectedValue =  "\(String(describing: campaignStaffMembers[row].userFirstName!)) \(String(describing: campaignStaffMembers[row].userLastName!))"
            SelectedIndex = campaignStaffMembers[row].userId
        }// FOR CAMPGAINS CATAGORIES
        else if currentDataType == "Catagories" {
            selectedValue = allCatagories[row].categoryName
            SelectedIndex = allCatagories[row].categoryId
        }// FOR CAMPGAINS CATAGORIES
        else if currentDataType == "campaignStatus" {
            selectedValue = campaignStatus[row]
            SelectedIndex = campaignStatus[row]
        } else {
            selectedValue = userOldCampaigns[row].title
            SelectedIndex = userOldCampaigns[row].internalIdentifier
        }
    }
    
     //ITEMPICKERNOTIFICATION_KEY_ALLCATAGORIES
    @IBAction func doneButtonClick(_ sender: Any) {
        var targetStringKey = String()
        // SET DATA FOR STAFF MEMBERS
        if currentDataType == "StaffMembers" {
           targetStringKey = ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_STAFF
            if campaignStaffMembers.count == 0 {
               self.view.removeFromSuperview()
                return
            }
            if selectedValue == "" {
                selectedValue =  "\(String(describing: campaignStaffMembers[0].userFirstName!)) \(String(describing: campaignStaffMembers[0].userLastName!))"
                SelectedIndex = campaignStaffMembers[0].userId
            }
        } // SET DATA FOR SORTING CAMPAIGNS
        else if currentDataType == "Catagories"{
            targetStringKey = ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_ALLCATAGORIES
            if allCatagories.count == 0 {
                self.view.removeFromSuperview()
                return
            }
            if selectedValue == "" {
                selectedValue =  allCatagories[0].categoryName
                SelectedIndex = allCatagories[0].categoryId
            }
        } else if currentDataType == "campaignStatus" {
            targetStringKey = ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_CAMPAIGNSTATUS
            if campaignStatus.count == 0 {
                self.view.removeFromSuperview()
                return
            }
            if selectedValue == "" {
                selectedValue =  campaignStatus[0]
                SelectedIndex = campaignStatus[0]
            }
        } else {
          targetStringKey = ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_CAMPAIGN
            if userOldCampaigns.count == 0 {
                self.view.removeFromSuperview()
                return
            }
            if selectedValue == "" {
            selectedValue = userOldCampaigns[0].title
            SelectedIndex = userOldCampaigns[0].internalIdentifier
            }
        }
        delegate?.pickerValueSelected(selectedValue, SelectedIndex)
        self.dismiss(animated: true, completion: nil)
//        let Observer = NotificationCenter.default
//        Observer.removeObserver(self, name: NSNotification.Name(rawValue: targetStringKey), object: nil)
//
//        Observer.post(name:Notification.Name(rawValue:targetStringKey),
//                              object: nil,
//                              userInfo: ["selectedValue":selectedValue!, "SelectedIndex": SelectedIndex! ])
//         self.view.removeFromSuperview()
    }
}
