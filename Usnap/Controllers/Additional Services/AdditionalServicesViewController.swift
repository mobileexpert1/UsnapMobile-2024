//
//  AdditionalServicesViewController.swift
//  Usnap
//
//  Created by CSPC141 on 03/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class AdditionalServicesViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var servicesListView: UITableView!
     @IBOutlet weak var topBars: TopBarView!
    var additionalListResponse = [AdditionalServicesresult]()
    var localCompaign: LocalCampaignStore?
    
    
    
    // MARK: - Class Functions
    class func Control(_ model: LocalCampaignStore) -> AdditionalServicesViewController {
        let control = self.control as! AdditionalServicesViewController
        control.localCompaign = model
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBars.leftButton1.isUserInteractionEnabled = false
               topBars.leftButton2.isUserInteractionEnabled = false
     servicesListView.register(UINib(nibName: "AdditionalServicesTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServicesTableViewCell")
        
        UIAlertController.showAlert("Information", message: "Swipe to accept or decline the additional request", buttons: ["OK"], completion: { (alert, index) in
        })
        
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
        fetchCampaignList()
    }
    
    func fetchCampaignList()  {
        CampaignStore.sharedInstance.getAdditionalServicesList(UserStore.sharedInstance.userInfo, (localCompaign?.targetId)!) { (response) in
            if response?.additionalServicesresponse?.status == "1" {
                self.additionalListResponse = (response?.additionalServicesresponse?.additionalServicesresult)!
                if self.additionalListResponse.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                    self.servicesListView.reloadData()
                }
                else {
                    self.servicesListView.reloadData()
                }
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                self.servicesListView.reloadData()
            }
        }
    }
    

    func serviceRequestAction( _ serviceId : String, _ action : String )  {
        CampaignStore.sharedInstance.AdditionalServiceUserAction(UserStore.sharedInstance.userInfo, serviceId, action, "", completion: { (resposne) in
            print(resposne as Any)
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                if  action == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Request accepted")
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: "Request rejected")
                }
                self.fetchCampaignList()
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                self.fetchCampaignList()
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalListResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServicesTableViewCell", for: indexPath) as! AdditionalServicesTableViewCell
        
        
        
        cell.campTitle.text = additionalListResponse[indexPath.row].campaignTitle!
        cell.totalPrice.text = additionalListResponse[indexPath.row].amountPayable
        cell.serviceTitle.text = additionalListResponse[indexPath.row].title!
        cell.serviceComment.text = additionalListResponse[indexPath.row].comment!
        
        
        
//        cell.serviceName.text = additionalListResponse[indexPath.row].title!
//        cell.minutePrice.text = additionalListResponse[indexPath.row].campaignPrice!
//        cell.totalTime.text  = additionalListResponse[indexPath.row].timeTaken!
//        cell.payableAmount.text = additionalListResponse[indexPath.row].amountPayable!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let Accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            self.serviceRequestAction(self.additionalListResponse[index.row].serviceId!, "1")
        }
        Accept.backgroundColor = acceptBgColor
        
        let Decline = UITableViewRowAction(style: .normal, title: "Decline") { action, index in
            self.serviceRequestAction(self.additionalListResponse[index.row].serviceId!, "0")

        }
        Decline.backgroundColor = declineBgColor
        return [Decline, Accept]
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
