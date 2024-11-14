//
//  UserProfileViewController.swift
//  Usnap
//
//  Created by CSPC141 on 09/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMarketingKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

@available(iOS 13.0, *)
class UserProfileViewController: AbstractControl {
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
//        if topView.leftButton2.currentImage == #imageLiteral(resourceName: "EditIcon")
        if sender.image == UIImage(named: "EditIcon")  {
            for CurrentTF in cardTextFields {
                AddBorder(targetTF: CurrentTF)
            }
//            topView.leftButton2.setImage(#imageLiteral(resourceName: "SaveIcon"), for: .normal)
            sender.image = UIImage(named: "SaveIcon")
        } else {
            for CurrentTF in cardTextFields {
                RemoveBorder(targetTF: CurrentTF)
            }
//            topView.leftButton2.setImage(#imageLiteral(resourceName: "EditIcon"), for: .normal)
            sender.image = UIImage(named: "EditIcon")
            self.updateProfile()
        }
    }
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
    }
    
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var inviteMember: UIButton!
    @IBOutlet var creditAmount: UILabel!
    @IBOutlet var agentCode: UILabel!
    @IBOutlet var topView: TopBarView!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var mobileNumberTF: UITextField!
    @IBOutlet var address1TF: UITextField!
    @IBOutlet var address2TF: UITextField!
    @IBOutlet var stateTF: UITextField!
    @IBOutlet var countryTF: UITextField!
    @IBOutlet var companyNameTF: UITextField!
    @IBOutlet var mediaTF: UITextField!
    @IBOutlet var invoiceTF: UITextField!
    @IBOutlet weak var deleteAccBtn: UIButton!
    
    var cardTextFields  = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        centeredNavBarImageView()
        let button = UIButton(type: .custom)
               button.setImage(UIImage(named: "BackIcon"), for: .normal)
               button.addTarget(self, action: #selector(LeftButtonpressed), for: .touchUpInside)
               button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
               let barButton = UIBarButtonItem(customView: button)
               self.navigationItem.leftBarButtonItem = barButton
        
        
        
        let closeButtonImage = UIImage(named: "EditIcon")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(UserProfileViewController.barButtonDidTap(_:)))
        
        
        
        deleteAccBtn.actionBlock {
            UIAlertController.showAlert("Alert!", message: Constants.ACCOUNT_DELETE, buttons: ["Cancel", "Delete"], completion: { (alert, index) in
                if index == 1 {
                    UserStore.sharedInstance.disableUser(self.userEmail.text!) { response in
                        let responseData = response?["response"] as! NSDictionary
                        if responseData["status"] as! String == "1" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                SVProgressHUD.showSuccess(withStatus: "Your account deleted successfully")
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                UserStore.sharedInstance.userInfo = "logout"
                                 GIDSignIn.sharedInstance()?.signOut()
                                 FBSDKLoginManager().logOut()
                                var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
                                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
                                
//                                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                 appDelegate.loginVC()
                            }
                        } else {
                            SVProgressHUD.showError(withStatus: "Unable to delete account")
                        }
                    }
                }
            })
        }
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
        getUserProfile()
    }
    
    
    @objc func LeftButtonpressed() {
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
    
    
    
    
    
    func getUserProfile() {
        UserStore.sharedInstance.requestUserProfile(UserStore.sharedInstance.userInfo, "", completion: { (resposne) in
            if resposne?.userProfile?.status == "1" {
                let profileResponse = resposne?.userProfile?.profileresult![0]
                self.firstNameTF.text = profileResponse?.userFirstName
                self.lastNameTF.text = profileResponse?.userLastName
                self.userEmail.text = profileResponse?.userEmail
                self.mobileNumberTF.text = profileResponse?.userMobile
                self.address1TF.text = profileResponse?.userAdd1
                self.address2TF.text = profileResponse?.userAdd2
                self.stateTF.text = profileResponse?.userState
                self.countryTF.text = profileResponse?.userCountry
                self.companyNameTF.text = profileResponse?.userCompanyName
                self.mediaTF.text = profileResponse?.userAllMediaTo
                self.invoiceTF.text = profileResponse?.userAllInvoiceTo
                self.agentCode.text = profileResponse?.userMyrefCode
                self.creditAmount.text = profileResponse?.creditAmount
                
                if profileResponse?.userProfileType == "staff_member" {
                    self.inviteMember.isHidden = true
                }
                else {
                  self.inviteMember.isHidden = false
                }
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        })
    }
    
    func updateProfile()  {
        UserStore.sharedInstance.UpdateUserProfile(UserStore.sharedInstance.userInfo, "", firstNameTF.text!, lastNameTF.text!, mobileNumberTF.text!, address1TF.text!, address2TF.text!, stateTF.text!, countryTF.text!, companyNameTF.text!, mediaTF.text!, invoiceTF.text!) { (resposne) in
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Your profile is updated successfully")
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func setUI()  {
//        topView.delegate = self
        cardTextFields  = [firstNameTF, lastNameTF, mobileNumberTF, address1TF, address2TF, stateTF, countryTF, companyNameTF, mediaTF, invoiceTF]
        for CurrentTF in cardTextFields {
            RemoveBorder(targetTF: CurrentTF)
        }
//        if UserStore.sharedInstance.userRole == "3" {
//            inviteMember.isHidden = false
//        }
//        else {
//            inviteMember.isHidden = true
//        }

    }
    
    
    func RemoveBorder(targetTF : UITextField)  {
        targetTF.addBorder(UIColor.clear)
        targetTF.isUserInteractionEnabled = false
    }

    func AddBorder(targetTF : UITextField)  {
        targetTF.addBorder(pinkBorderColor)
        targetTF.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func inviteButtonClicked(_ sender: Any) {
         InviteStaffPopUpViewController.showControl()
    }
    
    @IBAction func creditCardDetail(_ sender: Any) {
        navigationController?.pushViewController(CreditCardDetailsViewController.control, animated: true)
    }
    
    @IBAction func presetCampaigns(_ sender: Any) {
        navigationController?.pushViewController(CampaignPresentViewController.control, animated: true)

    }
}
