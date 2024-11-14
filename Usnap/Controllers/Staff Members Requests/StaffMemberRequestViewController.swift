//
//  StaffMemberRequestViewController.swift
//  Usnap
//
//  Created by CSPC141 on 04/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class StaffMemberRequestViewController: AbstractControl, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var requestsTableView: UITableView!
    @IBOutlet weak var topBarViews: TopBarView!
    var staffResponse = [StaffRequestresult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        requestsTableView.register(UINib(nibName: "StaffMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffMemberTableViewCell")
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
        getAllRequests()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staffResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffMemberTableViewCell", for: indexPath) as! StaffMemberTableViewCell
        cell.arrowImage.isHidden = true
        cell.staffMemberName.text = String(format: "%@ %@", self.staffResponse[indexPath.row].userFirstName!, self.staffResponse[indexPath.row].userLastName!)
        cell.staffMemberEmail.text = self.staffResponse[indexPath.row].userEmail
        cell.staffMemberPhone.text = self.staffResponse[indexPath.row].userMobile
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let Accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            self.userRequestAction(self.staffResponse[index.row].userEmail!, _action: "1")
        }
        Accept.backgroundColor = acceptBgColor
        let Decline = UITableViewRowAction(style: .normal, title: "Decline") { action, index in
            self.userRequestAction(self.staffResponse[index.row].userEmail!, _action: "0")
        }
        Decline.backgroundColor = declineBgColor
        return [Decline, Accept]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Data Methods
    func getAllRequests()  {
        StaffStore.sharedInstance.getStaffRequests(UserStore.sharedInstance.userInfo) { (response) in
            if response?.staffRequestresponse?.status == "1" {
                self.staffResponse = (response?.staffRequestresponse?.staffRequestresult!)!
                if self.staffResponse.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else {
                    UIAlertController.showAlert("Information", message: "Swipe left on staff member to accept or deny their request", buttons: ["OK"], completion: { (alert, index) in
                    })
                    self.requestsTableView.reloadData()
                }
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func userRequestAction( _ emailID : String, _action : String )  {
        StaffStore.sharedInstance.getStaffRequestsAction(UserStore.sharedInstance.userInfo, emailID, _action, "", completion: { (resposne) in
            print(resposne as Any)
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                if _action == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Request accepted")
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Request rejected")
                }
                self.getAllRequests()
            } else {
                SVProgressHUD.showError(withStatus: responseData["message"] as? String)
                self.getAllRequests()
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
