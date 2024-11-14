//
//  StaffMemberDetailViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class StaffMemberDetailViewController: AbstractControl, StaffPermissionDelegate {
    
    @IBOutlet weak var topBarViews: TopBarView!
    @IBOutlet var staffMemberName: UILabel!
    @IBOutlet var staffEmail: UILabel!
    @IBOutlet var staffPhoneNumber: UILabel!
    @IBOutlet var campaignCreated: UILabel!
    @IBOutlet var campaignUploaded: UIButton!
    @IBOutlet var currentCampaign: UILabel!
    @IBOutlet var invoicePaidBy: UILabel!
    var selectedStaffDetail :  Staffresult!
    @IBOutlet var currentInvoices: UIButton!
    var staffResponse : StaffMemberDetailresult!
    
    class func control(_ selectedStaffDetail : Staffresult) -> StaffMemberDetailViewController {
        let control = self.control as! StaffMemberDetailViewController
        control.selectedStaffDetail = selectedStaffDetail
        return control
    }
    
    func popUpButtonClicked(string: String) {
        fetchMemberDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchMemberDetails()
    }
    
    func fetchMemberDetails()  {
        StaffStore.sharedInstance.getStaffMemberDetail(self.selectedStaffDetail.userId!) { (response) in
            if response?.staffMemberDetailresponse?.status == "1" {
                
                self.staffResponse = response?.staffMemberDetailresponse?.staffMemberDetailresult
                self.staffMemberName.text = String(format: "%@ %@", (response?.staffMemberDetailresponse?.staffMemberDetailresult?.userFirstName!)!, (response?.staffMemberDetailresponse?.staffMemberDetailresult?.userLastName!)!)
                self.staffEmail.text = response?.staffMemberDetailresponse?.staffMemberDetailresult?.userEmail
                self.staffPhoneNumber.text = response?.staffMemberDetailresponse?.staffMemberDetailresult?.userMobile
                self.campaignCreated.text = NSString(format:"%d", (response?.staffMemberDetailresponse?.staffMemberDetailresult?.campaignCreated!)!) as String
                self.campaignUploaded.setTitle(NSString(format:"%@", (response?.staffMemberDetailresponse?.staffMemberDetailresult?.campaignUploaded!)!) as String, for: .normal)
                self.currentInvoices.setTitle(NSString(format:"%@", (response?.staffMemberDetailresponse?.staffMemberDetailresult?.currentInvoices!)!) as String, for: .normal)
                self.currentCampaign.text = response?.staffMemberDetailresponse?.staffMemberDetailresult?.currentCampaigns
                if response?.staffMemberDetailresponse?.staffMemberDetailresult?.invoiceBy == "1" {
                    self.invoicePaidBy.text = "Admin"
                }
                else {
                    self.invoicePaidBy.text = "Staff"
                }
                
                StaffPermissionsModel.saveUserPermissions(invoicePaidBy:(response?.staffMemberDetailresponse?.staffMemberDetailresult?.invoiceBy!)! , viewAllMedia: (response?.staffMemberDetailresponse?.staffMemberDetailresult?.allMedia!)!, viewAllInvoices: (response?.staffMemberDetailresponse?.staffMemberDetailresult?.allInvoice!)!, staffid: (response?.staffMemberDetailresponse?.staffMemberDetailresult?.internalIdentifier!)!)
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func currentInvoices(_ sender: Any) {
        
        
        navigationController?.pushViewController(StaffInvoicesViewController.control(self.selectedStaffDetail.internalIdentifier!), animated: true)
        
        //  navigationController?.pushViewController(StaffInvoicesViewController.control, animated: true)
    }
    
    @IBAction func manageSettingClick(_ sender: Any) {
        ManageStaffMemberViewController.showCustomControl(controller: self)
    }
    
    @IBAction func uploadedCampaigns(_ sender: Any) {
    }
    
    @IBAction func deleteMember(_ sender: Any) {
        
        UIAlertController.notifyUser("Alert!", message: "Are You Sure", alertButtonTitles: ["Yes", "No"], alertButtonStyles: [.default,.default,.cancel], vc: self, completion: { indexOfTappedButton in
            if indexOfTappedButton == 0 {
                StaffStore.sharedInstance.deleteStaffMember(self.selectedStaffDetail.internalIdentifier!) { (resposne) in
                    print(resposne as Any)
                    let responseData = resposne?["response"] as! NSDictionary
                    if responseData["status"] as! String == "1" {
                        SVProgressHUD.showSuccess(withStatus: "Deleted successfully")
                        self.popOrDismissViewController(true)
                    } else {
                        SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                    }
                }
            }
            else {
                
            }
        })
        
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
