//
//  MemberInvoicesFilterViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol memberInvoiceDelegate: class{
    func memberInvoiceFilter(_ data : NSDictionary, _ clearButton: String)
}

class MemberInvoicesFilterViewController: AbstractControl, DateChangedDelegate, pickerChangedvalueDelegate {
    
    
    
    @IBOutlet var statusBtn: UIButton!
    @IBOutlet var campaignCatagoryButton: UIButton!
    @IBOutlet var endDateTf: UITextField!
    @IBOutlet var startDateTF: UITextField!
    @IBOutlet var campaignNameTF: UITextField!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    var dateButtonType = String()
    var pickerButtonType = String()
    var selectedCatagory = NSString()
    var selectedCatagoryId = String()
    var selectedCatagoryStatusName = NSString()
    var selectedCatagoryStatusId = String()
    weak var delegate: memberInvoiceDelegate?
    
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        if pickerButtonType == "catagories" {
            campaignCatagoryButton.setTitle(pickerValue, for: .normal)
            selectedCatagory = pickerValue as NSString
            selectedCatagoryId = valueId
        }
        else {
            statusBtn.setTitle(pickerValue, for: .normal)
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
            }
            else {  }   }  else {
            endDateTf.text = date
            if DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "start date is greater then end date" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "empty" ||  DateStore.sharedDate.compareDates(startDate:startDateTF.text! , endDate: endDateTf.text!) == "same" {
                endDateTf.text = ""
                SVProgressHUD.showError(withStatus: Constants.ENDDATE)
            }  else {
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func dateSelected(_ date: String) {
    //        if dateButtonType == "start" {
    //            startDateTF.text = date
    //        }
    //        else {
    //            endDateTf.text = date
    //        }
    //    }
    
    
    override func viewDidLoad() {
        //self.bgImageBool = false
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
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        var tempDict = NSDictionary()
        tempDict = ["campaignCategoryId":selectedCatagoryId, "campaignName": campaignNameTF.text!, "status" : selectedCatagoryStatusId,  "startDate" : startDateTF.text!, "endDate" : endDateTf.text!]
        delegate?.memberInvoiceFilter(tempDict, "No")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func clearButtonClick(_ sender: Any) {
        let tempDict = NSDictionary()
        delegate?.memberInvoiceFilter(tempDict, "Yes")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryButtonClick(_ sender: Any) {
        pickerButtonType = "catagories"
        MiscDetailStore.sharedInstance.pickerTye = "Catagories"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    @IBAction func statusButton(_ sender: Any) {
        pickerButtonType = "status"
        MiscDetailStore.sharedInstance.pickerTye = "campaignStatus"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    @IBAction func startDate(_ sender: Any) {
        dateButtonType = "start"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    @IBAction func endDate(_ sender: Any) {
        dateButtonType = "end"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    func setUI()  {
        campaignNameTF.addBorder(pinkBorderColor)
        startDateTF.addBorder(UIColor.black)
        endDateTf.addBorder(UIColor.black)
    }
}
