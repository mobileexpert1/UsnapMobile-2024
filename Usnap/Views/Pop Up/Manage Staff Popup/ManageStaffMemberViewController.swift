//
//  ManageStaffMemberViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol StaffPermissionDelegate {
    func popUpButtonClicked(string: String)
}

class ManageStaffMemberViewController: AbstractControl {
    
    var delegate: StaffPermissionDelegate?

    @IBOutlet var invoicePaidButton: UIButton!
    @IBOutlet var allMediaButton: UIButton!
    @IBOutlet var allInvoiceButtons: UIButton!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    var invoicePaidStatus = String()
    var allMediaStatus = String()
    var allInvoiceStatus = String()
    var tempArray = Array<String>()
  
    // MARK: - Class Functions
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    class func showCustomControl(controller:UIViewController){
        let control = ManageStaffMemberViewController.getViewController() as! ManageStaffMemberViewController
        control.delegate = controller as? StaffPermissionDelegate
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
        
        
        
        tempArray = StaffPermissionsModel.returnUserPermissions()
        if tempArray[0] == "1" {
          invoicePaidButton.setImage(#imageLiteral(resourceName: "PinkCheck"), for: .normal)
             invoicePaidStatus = "1"
        }
        else {
          invoicePaidButton.setImage(#imageLiteral(resourceName: "PinkUncheck"), for: .normal)
             invoicePaidStatus = "0"
        }
        if tempArray[1] == "1" {
            allMediaButton.setImage(#imageLiteral(resourceName: "PinkCheck"), for: .normal)
            allMediaStatus = "1"
        }
        else {
            allMediaButton.setImage(#imageLiteral(resourceName: "PinkUncheck"), for: .normal)
            allMediaStatus = "0"
        }
        if tempArray[2] == "1" {
            allInvoiceButtons.setImage(#imageLiteral(resourceName: "PinkCheck"), for: .normal)
            allInvoiceStatus = "1"
        }
        else {
            allInvoiceButtons.setImage(#imageLiteral(resourceName: "PinkUncheck"), for: .normal)
            allInvoiceStatus = "0"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
           StaffStore.sharedInstance.setStaffMemberPermissions(tempArray[3], "", invoicePaidStatus, allInvoiceStatus, allMediaStatus,  completion: { (resposne) in
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Updated Successfully")
                    StaffPermissionsModel.saveUserPermissions(invoicePaidBy: self.invoicePaidStatus, viewAllMedia: self.allMediaStatus, viewAllInvoices: self.allInvoiceStatus, staffid: self.tempArray[3])
                    self.view.removeFromSuperview()
                    self.delegate?.popUpButtonClicked(string: "Clicked")
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                    self.view.removeFromSuperview()
                }
            })
    }
    
    @IBAction func invoicepaidButtonClick(_ sender: Any) {
        if invoicePaidButton.currentImage == #imageLiteral(resourceName: "PinkUncheck") {
            invoicePaidButton.setImage(#imageLiteral(resourceName: "PinkCheck") , for: .normal)
            invoicePaidStatus = "1"
        }
        else {
            invoicePaidButton.setImage(#imageLiteral(resourceName: "PinkUncheck") , for: .normal)
            invoicePaidStatus = "0"
        }
    }
    
    @IBAction func allMediaButtonClick(_ sender: Any) {
        if allMediaButton.currentImage == #imageLiteral(resourceName: "PinkUncheck") {
            allMediaButton.setImage(#imageLiteral(resourceName: "PinkCheck") , for: .normal)
            allMediaStatus = "1"
        }
        else {
            allMediaButton.setImage(#imageLiteral(resourceName: "PinkUncheck") , for: .normal)
            allMediaStatus = "0"
        }
    }
    
    @IBAction func allInvoicesButtonClick(_ sender: Any) {
        if allInvoiceButtons.currentImage == #imageLiteral(resourceName: "PinkUncheck") {
            allInvoiceButtons.setImage(#imageLiteral(resourceName: "PinkCheck") , for: .normal)
            allInvoiceStatus = "1"
        }
        else {
            allInvoiceButtons.setImage(#imageLiteral(resourceName: "PinkUncheck") , for: .normal)
            allInvoiceStatus = "0"
        }
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
