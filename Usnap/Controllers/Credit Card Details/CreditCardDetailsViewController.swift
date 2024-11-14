//
//  CreditCardDetailsViewController.swift
//  Usnap
//
//  Created by CSPC141 on 09/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import CreditCardValidator

class CreditCardDetailsViewController: AbstractControl, DateChangedDelegate, UITextFieldDelegate {
  
    @IBOutlet var dateDropButton: UIButton!
    @IBOutlet var topView: TopBarView!
    @IBOutlet var holderNameTF: UITextField!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var cvvNumberTF: UITextField!
    @IBOutlet var expireDateTF: UITextField!
    @IBOutlet weak var monthHolder: UIView!
    @IBOutlet weak var cardDetailsHolderView: UIView!
    
    
    var cardTextFields = [UITextField]()
    var dateSelected = String()
    
    var creditCardString = String()
    var screenMode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
               let closeButtonImage = UIImage(named: "BackIcon")
                       navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(CreditCardDetailsViewController.barButtonDidTaps(_:)))
        
        
        
        
        screenMode = "save"
//        topView.delegate = self
        
        let closeButtonImages = UIImage(named: "SaveIcon")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImages, style: .plain, target: self, action:  #selector(CreditCardDetailsViewController.barButtonDidTap(_:)))
       
        cardTextFields = [holderNameTF, cardNumberTF, cvvNumberTF, expireDateTF]
        expireDateTF.isUserInteractionEnabled = false
        
        for CurrentTF in cardTextFields {
            RemoveBorder(targetTF: CurrentTF)
        }
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.DATEPICKERNOTIFICATION_KEY),
                       object:nil, queue:nil,
                       using:catchNotification)
        getCardDetails()

    }
    
    @objc func barButtonDidTaps(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func centeredNavBarImageView() {
        if let navcontroller = navigationController {
            let image = #imageLiteral(resourceName: "TopBarLogo")
            let imageView = UIImageView(image: image)
            
            let bannerWidth = navcontroller.navigationItem.accessibilityFrame.size.width
            let bannerHeight = navcontroller.navigationBar.frame.size.height
            let bannerX = bannerWidth / 2 - image.size.width / 2
            let bannerY = bannerHeight / 2 - image.size.height / 2
            
            imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
            imageView.contentMode = .scaleAspectFit
            
            self.navigationItem.titleView = imageView
        }
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == expireDateTF {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for v in monthHolder.subviews{
            v.removeFromSuperview()
        }
      //  monthHolder.backgroundColor = UIColor.yellow
        let expiryDatePicker = MonthYearPickerView()
        //monthHolder.backgroundColor = UIColor.green
        expiryDatePicker.center = CGPoint(x: monthHolder.frame.size.width  / 2,
                                          y: monthHolder.frame.size.height / 2)
        monthHolder.addSubview(expiryDatePicker)
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let dateString = String(format: "%02d/%d", month, year)
            NSLog(dateString) // should show something like 05/2015
            self.creditCardString = dateString
        }
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func catchNotification(notification:Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let date  = userInfo["date"] as? String else {
                return
        }
        self.expireDateTF.text = DateStore.sharedDate.formarDate(requreidFormat: "MM/dd", finalDate: date)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func getCardDetails() {
        PaymentStore.sharedInstance.getCreditCardDetails(UserStore.sharedInstance.userInfo) { (resposne) in
            if resposne?.cradresponse?.status == "1" {
                self.holderNameTF.text = resposne?.cradresponse?.cardResult![0].cardHolderName
                self.cardNumberTF.text = resposne?.cradresponse?.cardResult![0].cardNo
                self.cvvNumberTF.text = resposne?.cradresponse?.cardResult![0].cvvNo
                self.expireDateTF.text = "\(String(describing: (resposne?.cradresponse?.cardResult![0].expMonth!)!))/\(String(describing: (resposne?.cradresponse?.cardResult![0].expYear!)!))"
            }
            else if resposne?.cradresponse?.status == "2" {
                SVProgressHUD.showError(withStatus: "Currently you have not registered Credit card")
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    //delegate function to get selected date from date picker
    func dateSelected(_ date: String) {
        
        
      
        self.expireDateTF.text = DateStore.sharedDate.formarDateForCard(requreidFormat: "MM/YYYY", finalDate: date)
    }
    
    func updateCreditCard()  {
        if (holderNameTF.text?.isEmpty)! || (cardNumberTF.text?.isEmpty)! || (cvvNumberTF.text?.isEmpty)! || (expireDateTF.text?.isEmpty)! {
            SVProgressHUD.showInfo(withStatus: "All fields are required")
            return
        } else {
                PaymentStore.sharedInstance.UpdateCreditCard(UserStore.sharedInstance.userInfo, holderNameTF.text!, cardNumberTF.text!, cvvNumberTF.text!, expireDateTF.text!) { (resposne) in
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: (responseData["message"] as! String))
                }  else {
                    for CurrentTF in self.cardTextFields {
                        CurrentTF.text = ""
                    }
                    SVProgressHUD.showInfo(withStatus: (responseData["message"] as! String))
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dummyButton(_ sender: Any) {
        for CurrentTF in cardTextFields {
            RemoveBorder(targetTF: CurrentTF)
        }
        
    }
    @IBAction func dateDropDown(_ sender: Any) {
//        let control = CustomDateViewController.control as! CustomDateViewController
//        control.delegate = self
//        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        holderNameTF.resignFirstResponder()
        cardNumberTF.resignFirstResponder()
        cvvNumberTF.resignFirstResponder()
        cardDetailsHolderView.isHidden = false
               
       
    }
    
    func RemoveBorder(targetTF : UITextField)  {
        targetTF.addBorder(UIColor.clear)
        targetTF.isUserInteractionEnabled = false
        dateDropButton.isHidden = true
    }
    
    func AddBorder(targetTF : UITextField)  {
        targetTF.addBorder(pinkBorderColor)
        targetTF.isUserInteractionEnabled = true
        dateDropButton.isHidden = false
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem)
    {
         if screenMode == "save" {
             for CurrentTF in cardTextFields {
                 AddBorder(targetTF: CurrentTF)
                 CurrentTF.text = ""
             }
             screenMode = "edit"
             sender.image = UIImage(named: "SaveIcon")
//             topView.leftButton2.setImage(#imageLiteral(resourceName: "SaveIcon"), for: .normal)
         }
         else {
             for CurrentTF in cardTextFields {
                 RemoveBorder(targetTF: CurrentTF)
             }
             screenMode = "save"
             sender.image = UIImage(named: "EditIcon")
//             topView.leftButton2.setImage(#imageLiteral(resourceName: "EditIcon"), for: .normal)
             updateCreditCard()
         }
     }
    
 
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        
    }
    @IBAction func pickerDoneBt(_ sender: Any) {
       cardDetailsHolderView.isHidden = true
        if creditCardString == "" {
            let year = Calendar.current.component(.year, from: Date())
            let month = Calendar.current.component(.month, from: Date())
            
              self.expireDateTF.text = String(format: "%02d/%d",month, year)
        }
        else {
              self.expireDateTF.text = creditCardString
        }
        
        
    }
    
    @IBAction func pickerCancelBT(_ sender: Any) {
         cardDetailsHolderView.isHidden = true
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
