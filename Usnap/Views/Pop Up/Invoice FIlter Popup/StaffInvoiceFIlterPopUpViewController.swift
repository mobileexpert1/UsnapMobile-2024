//
//  StaffInvoiceFIlterPopUpViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol invoiceFilterDelegate: class{
    func invoiceFilter(_ data : NSDictionary, _ clearButton: String)
}

class StaffInvoiceFIlterPopUpViewController: AbstractControl, DateChangedDelegate, pickerChangedvalueDelegate {
   
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        if pickerButtonType == "catagories" {
            categoryButton.setTitle(pickerValue, for: .normal)
            selectedCatagory = pickerValue as NSString
            selectedCatagoryId = valueId
        }
        else {
            statusButton.setTitle(pickerValue, for: .normal)
            selectedCatagoryStatusName = pickerValue as NSString
            if selectedCatagoryStatusName == "Paid" {
                selectedCatagoryStatusId = "0"
            }
            else {
                selectedCatagoryStatusId = "1"
            }
        }
    }
    

    
    func dateSelected(_ date: String) {
        if dateButtonType == "start" {
            startDateTF.text = date
if DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "start date is greater then end date" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "empty" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "same" {
                startDateTF.text = ""
                SVProgressHUD.showError(withStatus: Constants.STARTDATE)
            } else {
                
            }
            
        }
        else {
            endDateTf.text = date
            if DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "start date is greater then end date" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "empty" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "same" {
                endDateTf.text = ""
                SVProgressHUD.showError(withStatus: Constants.ENDDATE)
            }
            else {
                
            }
            
        }
    }
    
    
    
    
    
//    func dateSelected(_ date: String) {
//        print(date)
//        if dateButtonType == "start" {
//            startDateTF.text = date
//        }
//        else {
//            endDateTf.text = date
//        }
//    }
    
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var categoryButton: UIButton!
    @IBOutlet var endDateTf: UITextField!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var memberNameTF: UITextField!
    @IBOutlet var campaignNameTF: UITextField!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    var dateButtonType = String()
    var pickerButtonType = String()
    var selectedCatagory = NSString()
    var selectedCatagoryId = String()
    
    var selectedCatagoryStatusName = NSString()
    var selectedCatagoryStatusId = String()
    
    weak var delegate: invoiceFilterDelegate?
    
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4) {
            self.holderView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        backButton.touchUpInsideBlock {
            UIView.animate(withDuration: 0.4, animations: {
                self.holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }, completion: { (completed) in
                self.dismiss(animated: true, completion: nil)
//                self.view.removeFromSuperview()
            })
        }
    }
    //_ =  CustomPickerViewController.showControl("Catagories")
    func setUI()  {
        campaignNameTF.addBorder(pinkBorderColor)
        memberNameTF.addBorder(pinkBorderColor)
        startDateTF.addBorder(UIColor.black)
        endDateTf.addBorder(UIColor.black)
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
    
    @IBAction func categoryButtonClick(_ sender: Any) {
        pickerButtonType = "catagories"
        MiscDetailStore.sharedInstance.pickerTye = "Catagories"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
    }
    
    @IBAction func statusButtonClick(_ sender: Any) {
        pickerButtonType = "status"
        MiscDetailStore.sharedInstance.pickerTye = "campaignStatus"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    @IBAction func startButton(_ sender: Any) {
        dateButtonType = "start"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    @IBAction func endButton(_ sender: Any) {
        dateButtonType = "end"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        var tempDict = NSDictionary()
        if campaignNameTF.text?.count != 0{
            tempDict = ["campaignCategoryId":selectedCatagoryId, "campaignName": campaignNameTF.text!, "staffMemberName" : memberNameTF.text!, "status" : selectedCatagoryStatusId, "startDate" : startDateTF.text!, "endDate" : endDateTf.text!]
            delegate?.invoiceFilter(tempDict, "No")
            self.dismiss(animated: true, completion: nil)
        }else{
            SVProgressHUD.showInfo(withStatus: Constants.COMPAIGN_NAME)
        }
    }
    
    @IBAction func clearClick(_ sender: Any) {
        let tempDict = NSDictionary()
        delegate?.invoiceFilter(tempDict, "Yes")
        self.dismiss(animated: true, completion: nil)
    }
    
}

