//
//  SettingViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

@available(iOS 13.0, *)
class SettingViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var propertAgentButton: UIButton!
    @IBOutlet var generalUserButton: UIButton!
    @IBOutlet var bothButton: UIButton!
    @IBOutlet var setingListView: UITableView!
    @IBOutlet weak var topBarViews: TopBarView!
    
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    var settingsList = NSArray()
    var controllersArray = [AbstractControl]()
    var switchCurrentValue = String()
    var availableCredits = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        centeredNavBarImageView()
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
    setingListView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
       initDataItems()
        setingListView.alwaysBounceVertical = false
        propertAgentButton.setImage(UIImage(named: "RadioOn"), for: .normal)
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
    
    
    
    
    func initDataItems()  {
        if UserStore.sharedInstance.userRole == "3" {
          //  settingsList = ["Profile", "Staff Member", "Change Password", "Terms & Conditions", "Privacy Policy", "Pricing", "Rate the App", "Keep data after 90 days", "Total Available Points"]
            settingsList = ["Profile", "Staff Member", "Change Password", "Terms & Conditions", "Privacy Policy", "Pricing", "Rate the App", "Keep data after 90 days"]
            controllersArray = [UserProfileViewController.getViewController(), StaffMembersViewController.getViewController(), ChangePasswordViewController.getViewController(), TermsAndConditionsViewController.getViewController(), PrivacyPolicyViewController.getViewController(),  PriceListViewController.getViewController()]
        } else {
          //  settingsList = ["Profile", "Change Password", "Terms & Conditions", "Privacy Policy", "Pricing", "Rate the App", "Keep data after 90 days", "Total Available Points"]
            settingsList = ["Profile", "Change Password", "Terms & Conditions", "Privacy Policy", "Pricing", "Rate the App", "Keep data after 90 days"]
            controllersArray = [UserProfileViewController.getViewController(),  ChangePasswordViewController.getViewController(), TermsAndConditionsViewController.getViewController(), PrivacyPolicyViewController.getViewController(),  PriceListViewController.getViewController()]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserProfileType()
        propertAgentButton.isUserInteractionEnabled = false
        generalUserButton.isUserInteractionEnabled = false
    }

    @IBAction func propertyAgentClicked(_ sender: UIButton) {
//        propertAgentButton.setImage(UIImage(named: "RadioOn"), for: .normal)
//        generalUserButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        bothButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        changeUserRole("34")
        
    }
    @IBAction func generalUserClick(_ sender: UIButton) {
//        propertAgentButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        generalUserButton.setImage(UIImage(named: "RadioOn"), for: .normal)
//        bothButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        changeUserRole("5")
    }
    @IBAction func bothClick(_ sender: UIButton) {
//        propertAgentButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        generalUserButton.setImage(UIImage(named: "RadioOff"), for: .normal)
//        bothButton.setImage(UIImage(named: "RadioOn"), for: .normal)
//        changeUserRole("6")
    }
    
    func changeCheckBox(targetButton: UIButton)  {
        if targetButton.currentImage == #imageLiteral(resourceName: "RadioOff") {
            targetButton.setImage(UIImage(named: "RadioOn"), for: .normal)
        }
        else {
            targetButton.setImage(UIImage(named: "RadioOff"), for: .normal)
        }
    }
    
    
    func changeUserRole(_ value: String)   {
        UserStore.sharedInstance.chnageUserRole(UserStore.sharedInstance.userInfo, value) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                print(response as Any)
                UserStore.sharedInstance.userRole = (responseData["role"] as? String)!
                self.initDataItems()
                self.setingListView.reloadData()
                 SVProgressHUD.showSuccess(withStatus: responseData["message"] as? String)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.DELAYTIME) { // change 2 to desired number of seconds
                    self.getUserProfileType()
                }
            } else {
                SVProgressHUD.showError(withStatus: responseData["message"] as? String)
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.DELAYTIME) { // change 2 to desired number of seconds
                    self.getUserProfileType()
                }
            }
        }
    }
    
    func getUserProfileType()  {
            UserStore.sharedInstance.getUserProfileType(UserStore.sharedInstance.userInfo, completion: { (resposne) in
                print(resposne as Any)
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.switchCurrentValue = responseData["user_switch"] as! String
                    self.availableCredits = responseData["TotalCreditAvailable"] as! String
                    
                   let userTypeArray = (responseData["result"] as! NSDictionary).value(forKey: "user_role")   as! NSArray
                    if userTypeArray.count == 2 {
                        self.propertAgentButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                        self.generalUserButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                        self.bothButton.setImage(UIImage(named: "RadioOn"), for: .normal)
                    }
                    else {
                        if userTypeArray[0] as! String == "3" || userTypeArray[0] as! String == "4"  {
                            self.propertAgentButton.setImage(UIImage(named: "RadioOn"), for: .normal)
                            self.generalUserButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                            self.bothButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                        }
                        else {
                            self.propertAgentButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                            self.generalUserButton.setImage(UIImage(named: "RadioOn"), for: .normal)
                            self.bothButton.setImage(UIImage(named: "RadioOff"), for: .normal)
                        }
                    }
                     self.setingListView.reloadData()
                }
                else {
                }
            })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        cell.titleLabel.text = (settingsList[indexPath.row] as! String)
        
        if settingsList[indexPath.row] as! String == "Keep data after 90 days" {
            cell.membershipSwitch.isHidden = false
            cell.nextIconImg.isHidden = true
        }
            
//        else if settingsList[indexPath.row] as! String == "Total Available Points"
//        {
//            cell.nextIconImg.isHidden = true
//            cell.titleLabel.text = (settingsList[indexPath.row] as! String + " - " + availableCredits)
//        }
        
        else {
          cell.membershipSwitch.isHidden = true
          cell.nextIconImg.isHidden = false
        }
        
        
        
        if self.switchCurrentValue == "0" {
               cell.membershipSwitch.setOn(false, animated:true)
        }
        else {
                cell.membershipSwitch.setOn(true, animated:true)
        }
        cell.membershipSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        return cell
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            UIAlertController.showAlert("Alert!", message: "Are you sure you wish to keep all media after 90 days.", buttons: ["No", "Yes"], completion: { (alert, index) in
                if index == 0 {
                  self.switchCurrentValue = "0"
                    self.setingListView.reloadData()
                } else {
                    self.submitDataRequest("1")
                }
            })
          
        } else {
            UIAlertController.showAlert("Alert!", message: "Are you sure you wish to delete the all media after 90 days? This will also delete current campaigns older than 90 days", buttons: ["No", "Yes"], completion: { (alert, index) in
                if index == 0 {
                   self.switchCurrentValue = "1"
                    self.setingListView.reloadData()
                } else {
                    self.submitDataRequest("0")
                }
            })
        }
    }
    
    func submitDataRequest(_ userAction : String) {
        UserStore.sharedInstance.keepData(UserStore.sharedInstance.userInfo, userAction) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: responseData["message"] as? String)
                self.switchCurrentValue = responseData["user_switch"] as! String
                self.setingListView.reloadData()
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                self.switchCurrentValue = responseData["user_switch"] as! String
                self.setingListView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settingsList[indexPath.row] as! String == "Keep data after 90 days" {
            
        }
            
//        else if settingsList[indexPath.row] as! String == "Total Available Points" {
//
//        }
            
        else if settingsList[indexPath.row] as! String == "Rate the App" {
            rateApp(appId: "id1453974860") { success in
            }
        }
        else {
            navigationController?.pushViewController((controllersArray[indexPath.row] as AbstractControl), animated: true)
        }
    }
//https://itunes.apple.com/us/app/usnap/id1453974860?ls=1&mt=8
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
