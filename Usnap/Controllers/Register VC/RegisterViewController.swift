//
//  RegisterViewController.swift
//  Usnap
//
//  Created by CSPC141 on 01/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import ADCountryPicker
import DropDown

class RegisterViewController: AbstractControl, ADCountryPickerDelegate {
    @IBOutlet var registerView: UIView!
    var list = [String]()
    var hearAbout  = String()
    
    @IBOutlet weak var hearAboutUs: UITableView!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var chooseRelation: UITextField!
    @IBOutlet var saveButtom: UIButton!
    @IBOutlet var termAndConditionsButton: UIButton!
    @IBOutlet var allInvoiceto: UITextField!
    @IBOutlet var allMediato: UITextField!
    @IBOutlet var companyName: UITextField!
    @IBOutlet var bothButton: UIButton!
    @IBOutlet var generalButton: UIButton!
    @IBOutlet var corporationButton: UIButton!
    @IBOutlet var agentCode: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var emailId: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var countryCode: UITextField!
    @IBOutlet var countryTF: UITextField!
    @IBOutlet weak var termsAndConditionBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    var roleCode = String()
    var loginData : LoginResponse! = nil
      let picker = ADCountryPicker()
     let locale = Locale.current
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hearAboutUs.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTableViewCell")
        hearAboutUs.delegate = self
        hearAboutUs.dataSource = self
        hearAboutUs.isHidden = true
        otherTextField.delegate = self
        chooseRelation.delegate = self
      
        roleCode = "34"
        setUI()
        agentCode.backgroundColor = UIColor.clear
        agentCode.isUserInteractionEnabled = true
        agentCode.text = ""
        saveButtom.isUserInteractionEnabled = false
       
         list = ["Freind", "Co-Worker", "Google search","Social media","Email","other"]
        otherTextField.isHidden = true

        chooseRelation.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
    
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//                   registerView.addGestureRecognizer(tap)
//       
        
       }

       //Calls this function when the tap is recognized.
//       @objc func dismissKeyboard() {
//           hearAboutUs.isHidden = true
//       }
  
    @objc func myTargetFunction(textField: UITextField) {
        hearAboutUs.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
         AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    

    @IBAction func countryCodeClick(_ sender: Any) {
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        
        picker.defaultCountryCode = code!
        picker.delegate = self
        picker.showFlags = true
        self.present(pickerNavigationController, animated: true, completion: nil)

    }
    
    @IBAction func termsAndConditionBtnTapped(_ sender: UIButton) {
        print("term")
        openUrl("https://usnap.com.au/register/Terms_and_conditions")
    }
    
    @IBAction func privacyPolicyBtnTapped(_ sender: UIButton) {
        print("policy")
        openUrl("https://usnap.com.au/register/Privacy_policy")
    }
    
    func openUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func setUI() {
        firstName.addLeftImage(#imageLiteral(resourceName: "UserIcon"))
        lastName.addLeftImage(#imageLiteral(resourceName: "UserIcon"))
        emailId.addLeftImage(#imageLiteral(resourceName: "EmailIcon"))
        password.addLeftImage(#imageLiteral(resourceName: "PasswordIcon"))
        //phoneNumber.addLeftImage(#imageLiteral(resourceName: "UserIcon"))
        agentCode.addLeftImage(#imageLiteral(resourceName: "UserIcon"))
        countryTF.addLeftImage(#imageLiteral(resourceName: "country"))
        companyName.addLeftImage(#imageLiteral(resourceName: "CompanyName"))
        allMediato.addLeftImage(#imageLiteral(resourceName: "MenuMessage"))
        allInvoiceto.addLeftImage(#imageLiteral(resourceName: "MenuMessage"))
        chooseRelation.addLeftImage(#imageLiteral(resourceName: "CompanyName"))
        firstName.addBottomLabel(UIColor.lightGray)
        lastName.addBottomLabel(UIColor.lightGray)
        emailId.addBottomLabel(UIColor.lightGray)
        password.addBottomLabel(UIColor.lightGray)
        phoneNumber.addBottomLabel(UIColor.lightGray)
        countryCode.addBottomLabel(UIColor.lightGray)
        agentCode.addBottomLabel(UIColor.lightGray)
        countryTF.addBottomLabel(UIColor.lightGray)
        companyName.addBottomLabel(UIColor.lightGray)
        allMediato.addBottomLabel(UIColor.lightGray)
        allInvoiceto.addBottomLabel(UIColor.lightGray)
        chooseRelation.addBottomLabel(UIColor.lightGray)
        otherTextField.addBottomLabel(UIColor.lightGray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Admin
    @IBAction func corporationClick(_ sender: Any) {
        corporationButton.setImage(UIImage(named: "RadioOn"), for: .normal)
        generalButton.setImage(UIImage(named: "RadioOff"), for: .normal)
        roleCode = "34"
        agentCode.backgroundColor = UIColor.lightGray
        agentCode.isUserInteractionEnabled = false
        agentCode.text = ""
    }
    
    // Staff
    @IBAction func generalClick(_ sender: Any) {
        corporationButton.setImage(UIImage(named: "RadioOff"), for: .normal)
        generalButton.setImage(UIImage(named: "RadioOn"), for: .normal)
        roleCode = "5"
        agentCode.backgroundColor = UIColor.clear
        agentCode.isUserInteractionEnabled = true
    }
    
    @IBAction func termsAndConditionsClick(_ sender: Any) {
        if termAndConditionsButton.image == UIImage(named: "untickButton") {
            termAndConditionsButton.setImage(UIImage(named: "tickButton"), for: .normal)
            saveButtom.isUserInteractionEnabled = true
            saveButtom.alpha = 1.0
        } else {
           termAndConditionsButton.setImage(UIImage(named: "untickButton"), for: .normal)
            saveButtom.isUserInteractionEnabled = false
            saveButtom.alpha = 0.5
        }
    }
    
    @IBAction func bothClick(_ sender: Any) {
        corporationButton.setImage(UIImage(named: "RadioOff"), for: .normal)
        generalButton.setImage(UIImage(named: "RadioOff"), for: .normal)
        roleCode = "6"
        agentCode.backgroundColor = UIColor.clear
        agentCode.isUserInteractionEnabled = false
    }
    
    @available(iOS 13.0, *)
    @IBAction func saveClick(_ sender: Any) {
        
        let trimmedAgentCode = agentCode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedAgentCode == "" {
            roleCode = "34"  // Admin
        }
        else {
            roleCode = "5"   // Staff
        }

        // Check for staff
        if generalButton.currentImage == UIImage(named: "RadioOn") {
            if (firstName.text?.isEmpty)! || (lastName.text?.isEmpty)! || (emailId.text?.isEmpty)! || (password.text?.isEmpty)! || (phoneNumber.text?.isEmpty)! || (countryTF.text?.isEmpty)! || (countryCode.text?.isEmpty)! || (agentCode.text?.isEmpty)! || (companyName.text?.isEmpty)! || (allMediato.text?.isEmpty)! ||  (chooseRelation .text?.isEmpty)! {
                if chooseRelation.text == "other" && (otherTextField.text?.isEmpty)! {
                    SVProgressHUD.showError(withStatus: "All fields are required")
                }
                SVProgressHUD.showError(withStatus: "All fields are required")
                return
            } 
            
        else {
                uploadDataToServer()
            }
        } else {
            if (firstName.text?.isEmpty)! || (lastName.text?.isEmpty)! || (emailId.text?.isEmpty)! || (password.text?.isEmpty)! || (phoneNumber.text?.isEmpty)! || (countryTF.text?.isEmpty)! || (countryCode.text?.isEmpty)! || (companyName.text?.isEmpty)! || (allMediato.text?.isEmpty)! || (allInvoiceto.text?.isEmpty)! || (allInvoiceto.text?.isEmpty)! || (chooseRelation.text?.isEmpty)!{
                if chooseRelation.text == "other" && (otherTextField.text?.isEmpty)! {
                    SVProgressHUD.showError(withStatus: "All fields are required")
                }
                SVProgressHUD.showError(withStatus: "All fields are required")
                return
            }
            else {
                uploadDataToServer()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func uploadDataToServer() {
        if chooseRelation.text == "other" {
            hearAbout = otherTextField.text ?? ""
        }
        if emailId.isValidEmail {
            UserStore.sharedInstance.requestRegister(roleCode, firstName.text!, lastName.text!, emailId.text!, password.text!, countryCode.text! + phoneNumber.text!, agentCode.text!, UserStore.sharedInstance.deviceToken, Constants.DEVICE_TYPE, countryTF.text!, companyName.text!, allMediato.text!, allInvoiceto.text!, hearAbout, completion: { (resposne) in
                if resposne?.loginResponse?.status == "1" {
                    if resposne?.loginResponse?.loginResult![0].loginPermission == "no" {
                        self.performSegueToReturnBack()
                        UIAlertController.showAlert("Alert!", message: (resposne?.loginResponse?.message)!, buttons: ["OK"], completion: { (alert, index) in
                        })
                    } else {
                        var userIdArray = NSArray()
                        userIdArray = (resposne?.loginResponse?.loginResult![0].userRoleId?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].userRoleId)!))!
                        
                        var roleArray = NSArray()
                        roleArray = (resposne?.loginResponse?.loginResult![0].roles?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].roles)!))!
                        UserStore.sharedInstance.userDetails = (resposne?.loginResponse?.loginResult![0])!
                        UserStore.sharedInstance.userInfo = (resposne?.loginResponse?.loginResult![0].userRoleId)!
                        UserStore.sharedInstance.userRole = (resposne?.loginResponse?.loginResult![0].roles)!
                        self.navigationController?.pushViewController(HomeViewController .control, animated: true)
                    }
                } else {
                    SVProgressHUD.showError(withStatus: resposne?.loginResponse?.message)
                }
                self.loginData = resposne?.loginResponse
            })
            
        } else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
        }
    }
    
    // MARK: - Country Picker Delegate
    private func countryPicker(picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        print(code)
        countryCode.text = code
        self.dismiss(animated: true, completion: nil)
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(dialCode)
        countryCode.text = dialCode
        self.dismiss(animated: true, completion: nil)
    }
}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == chooseRelation {
            hearAboutUs.isHidden = false
            hearAboutUs.reloadData()
            chooseRelation.endEditing(true)
           
        } else if textField == otherTextField {
            hearAbout = otherTextField.text ?? ""
        }
    }
}
//extension RegisterViewController: UIPickerViewDelegate ,UIPickerViewDataSource {
//    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
//        return 1
//
//    }
//
//    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//
//        return list.count
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        self.view.endEditing(true)
//        return list[row]
//
//    }

//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        
//        self.chooseRelation.text = self.list[row]
//        hearAbout = chooseRelation.text ?? ""
//        if chooseRelation.text == "other" {
//            otherTextField.isHidden = false
//        } else if chooseRelation.text == "How did you heaar about us" {
//            hearAbout = ""
//            otherTextField.isHidden = true
//        }else {
//            otherTextField.isHidden = true
//        }
//        self.dropBox.isHidden = true
//
//    }
//}
extension RegisterViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
        cell.hearAboutUsLbl.text = list[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseRelation.text = list[indexPath.row]
      
        if chooseRelation.text == "other" {
            otherTextField.isHidden = false
        } else if chooseRelation.text == "How did you heaar about us" {
            hearAbout = ""
            otherTextField.isHidden = true
        }else {
            otherTextField.isHidden = true
        }
        hearAboutUs.isHidden = true
    }
}
