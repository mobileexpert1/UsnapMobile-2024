//
//  InviteStaffPopUpViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD


class InviteStaffPopUpViewController: AbstractControl {

    @IBOutlet var holderView: UIView!
    @IBOutlet var memberEmailTF: UITextField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var noteLabel: UILabel!
    // MARK: - Class Functions
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
        holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4) {
            self.holderView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        
        backButton.touchUpInsideBlock {
            UIView.animate(withDuration: 0.4, animations: {
                self.holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }, completion: { (completed) in
                self.view.removeFromSuperview()
            })
        }
        setUI()
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
    
    func setUI()  {
        memberEmailTF.addBorder(pinkBorderColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        if (memberEmailTF.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Email is Required")
        } else if memberEmailTF.isValidEmail {
            StaffStore.sharedInstance.inviteStaffMember(UserStore.sharedInstance.userInfo, memberEmailTF.text!, completion: { (resposne) in
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: String(format: "%@ %@", "Invitation has been sent to ", self.memberEmailTF.text!))
                     self.memberEmailTF.text = ""
                } else if responseData["status"] as! String == "2" {
                     SVProgressHUD.showInfo(withStatus: String(format: "%@ %@", self.memberEmailTF.text!, "this email id is already registered" ))
                    self.memberEmailTF.text = ""
                } else if responseData["status"] as! String == "3" {
                    SVProgressHUD.showInfo(withStatus: String(format: "Staff member limit is reached"))
                    self.memberEmailTF.text = ""
                } else {
                    SVProgressHUD.showInfo(withStatus: String(format: "Some server error" ))
                    self.memberEmailTF.text = ""
                }})} else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
        }
    }
    
    
    @IBAction func clearButtonClick(_ sender: Any) {
        memberEmailTF.text = ""
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
