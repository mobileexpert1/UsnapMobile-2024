//
//  CampaignFilterViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol campaignFilterDelegate: class{
    func CampaignFilterData(_ data : NSDictionary, _ clearClick: String)
}

class CampaignFilterViewController: AbstractControl, DateChangedDelegate, pickerChangedvalueDelegate {
   

    @IBOutlet var backButton: UIButton!
    @IBOutlet var selectCategoryButton: UIButton!
    @IBOutlet var campaignNameTF: UITextField!
    @IBOutlet var retoucherNameTf: UITextField!
    @IBOutlet var statusButtonTf: UIButton!
    @IBOutlet var campaignTitleTF: UITextField!
    @IBOutlet var staffMemberName: UITextField!
    @IBOutlet var startDateTf: UITextField!
    @IBOutlet var endDateTf: UITextField!
    @IBOutlet var holderView: UIView!
    weak var delegate: campaignFilterDelegate?
    var selectedCatagory = NSString()
    var selectedCatagoryId = String()
    
    var selectedCatagoryStatusName = NSString()
    var selectedCatagoryStatusId = String()
    var dateButtonType = String()
    var pickerButtonType = String()
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        if pickerButtonType == "catagories" {
            selectCategoryButton.setTitle(pickerValue, for: .normal)
            selectedCatagory = pickerValue as NSString
            selectedCatagoryId = valueId
        }
        else {
            statusButtonTf.setTitle(pickerValue, for: .normal)
            selectedCatagoryStatusName = pickerValue as NSString
            if selectedCatagoryStatusName == "Paid" {
                selectedCatagoryStatusId = "0"
            }
            else {
                selectedCatagoryStatusId = "1"
            }
        }
    }
    
    
    
    
  //  start date is smaller then end date
   // start date is greater then end date
    
    
    func dateSelected(_ date: String) {
        if dateButtonType == "start" {
            startDateTf.text = date
            if DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "start date is greater then end date" ||  DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "empty" ||  DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "same" {
                startDateTf.text = ""
                SVProgressHUD.showError(withStatus: Constants.STARTDATE)
            }else {}}else {
            endDateTf.text = date
            if DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "start date is greater then end date" ||  DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "empty" ||  DateStore.sharedDate.compareDates(startDate:startDateTf.text! , endDate: endDateTf.text!) == "same" {
                endDateTf.text = ""
                SVProgressHUD.showError(withStatus: Constants.ENDDATE)
            } else {
            }
        }
    }
    
    // MARK: - Class Functions
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        //self.bgImageBool = false
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
                //self.view.removeFromSuperview()
            })
        }
//        let nc = NotificationCenter.default // Note that default is now a property, not a method call
//        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_ALLCATAGORIES),
//                       object:nil, queue:nil,
//                       using:catchNotification)
//
//        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_CAMPAIGNSTATUS),
//                       object:nil, queue:nil,
//                       using:catchNotification_CampaignStatus)
    }

    
//    func catchNotification(notification:Notification) -> Void {
//        print("Catch notification")
//        guard let userInfo = notification.userInfo,
//            let selectedValue  = userInfo["selectedValue"] as? String else {
//                return
//        }
//        selectCategoryButton.setTitle(selectedValue, for: .normal)
//        selectedCatagory = selectedValue as NSString
//        selectedCatagoryId = userInfo["SelectedIndex"]! as! String
//    }
    
    
//    func catchNotification_CampaignStatus(notification:Notification) -> Void {
//        print("Catch notification")
//        guard let userInfo = notification.userInfo,
//            let selectedValue  = userInfo["selectedValue"] as? String else {
//                return
//        }
//        statusButtonTf.setTitle(selectedValue, for: .normal)
//        selectedCatagoryStatusName = selectedValue as NSString
//        if selectedCatagoryStatusName == "Paid" {
//            selectedCatagoryStatusId = "0"
//        }
//        else {
//            selectedCatagoryStatusId = "1"
//        }
//    }
    
    
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
    
    func setUI()  {
        campaignNameTF.addBorder(pinkBorderColor)
        retoucherNameTf.addBorder(pinkBorderColor)
        campaignTitleTF.addBorder(pinkBorderColor)
        staffMemberName.addBorder(pinkBorderColor)
        startDateTf.addBorder(UIColor.black)
        endDateTf.addBorder(UIColor.black)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectButtonClick(_ sender: Any) {
        pickerButtonType = "catagories"
        MiscDetailStore.sharedInstance.pickerTye = "Catagories"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
          //  _ =  CustomPickerViewController.showControl("Catagories")
    }
    @IBAction func statusButtonClick(_ sender: Any) {
        pickerButtonType = "status"
        MiscDetailStore.sharedInstance.pickerTye = "campaignStatus"
        let control = CustomPickerViewController.control as! CustomPickerViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
       // _ =  CustomPickerViewController.showControl("campaignStatus")
        
    }
    @IBAction func startDateButton(_ sender: Any) {
        dateButtonType = "start"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
      // _ = CustomDateViewController.showControl("campaignFilter")
    }
    
    @IBAction func endDateButton(_ sender: Any) {
        dateButtonType = "end"
        let control = CustomDateViewController.control as! CustomDateViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
      //  _ = CustomDateViewController.showControl("campaignFilter")
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
      //  self.view.removeFromSuperview()
        let tempDict = NSDictionary()
        delegate?.CampaignFilterData(tempDict, "Yes")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        var tempDict = NSDictionary()
        tempDict = ["campaignCategoryId":selectedCatagoryId, "campaignName": campaignNameTF.text!, "retoucherName" : retoucherNameTf.text!, "status" : selectedCatagoryStatusId, "campaignTitle" : campaignTitleTF.text!, "staffMemberDetail" : staffMemberName.text!, "startDate" : startDateTf.text!, "endDate" : endDateTf.text!]
        
       delegate?.CampaignFilterData(tempDict, "No")
        
//        let Observer = NotificationCenter.default
//        Observer.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.CampaignFilter_KEY_Result), object: nil)
//        Observer.post(name:Notification.Name(rawValue:ConstantsKeys.CampaignFilter_KEY_Result),
//                      object: nil,
//                      userInfo: ["campaignCategoryId":selectedCatagoryId, "campaignName": campaignNameTF.text!, "retoucherName" : retoucherNameTf.text!, "status" : statusButtonTf.currentTitle!, "campaignTitle" : campaignTitleTF.text!, "staffMemberDetail" : staffMemberName.text!])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
