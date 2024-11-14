//
//  AddStaffMemberViewController.swift
//  Usnap
//
//  Created by CSPC141 on 04/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddStaffMemberViewController: AbstractControl {

    @IBOutlet var termsButton: UIButton!
    @IBOutlet var viewAllInvoicesButton: UIButton!
    @IBOutlet var viewAllMediaButton: UIButton!
    @IBOutlet var invoicePaidByButton: UIButton!
    @IBOutlet var settingHolderView: UIView!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    
    @IBOutlet weak var topBarViews: TopBarView!
    var adminPaidStatus = String()
    var allMediaStatus = String()
    var allInvoicesStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(AddStaffMemberViewController.barButtonDidTap(_:)))
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        setUI()
        adminPaidStatus = "0"
        allMediaStatus = "0"
        allInvoicesStatus = "0"
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
    
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
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
    
    
    func setUI()  {
        let borderColor = UIColor(red: 0.8431, green: 0.5059, blue: 0.6784, alpha: 1)
        firstNameTF.addBorder(borderColor)
        lastNameTF.addBorder(borderColor)
        firstNameTF.addBorder(borderColor)
        emailTF.addBorder(borderColor)
        phoneNumberTF.addBorder(borderColor)
        settingHolderView.addShadow(0, 0, 0.5)
    }
    
    @IBAction func termsButton(_ sender: Any) {
      //  hitBrowser("http://www.google.com")
     
        navigationController?.pushViewController(TermsAndConditionsViewController.control, animated: true)
        
    }
    
    @IBAction func privacyButton(_ sender: Any) {
     //   hitBrowser("http://www.google.com")
        navigationController?.pushViewController(PrivacyPolicyViewController.control, animated: true)

    }
    
    @IBAction func invoicePaidButton(_ sender: UIButton) {
        changeCheckBox(targetButton: sender)
        adminPaidStatus = adminPaidStatus.makeOppositeString(adminPaidStatus)
    }
    
    @IBAction func allInvoicesButton(_ sender: UIButton) {
         changeCheckBox(targetButton: sender)
         allInvoicesStatus = allInvoicesStatus.makeOppositeString(allInvoicesStatus)
    }
    
    @IBAction func allMediaButton(_ sender: UIButton) {
         changeCheckBox(targetButton: sender)
         allMediaStatus = allMediaStatus.makeOppositeString(allMediaStatus)
    }
    
    @IBAction func agreeButton(_ sender: UIButton) {
        changeCheckBox(targetButton: sender)
    }
    
    func changeCheckBox(targetButton: UIButton)  {
        if targetButton.currentImage == #imageLiteral(resourceName: "UnTick") {
           targetButton.setImage(UIImage(named: "Tick"), for: .normal)
        }
        else {
          targetButton.setImage(UIImage(named: "UnTick"), for: .normal)
        }
    }
    
    func hitBrowser(_ urlString: String)  {
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if (firstNameTF.text?.isEmpty)! || (lastNameTF.text?.isEmpty)! || (emailTF.text?.isEmpty)! || (phoneNumberTF.text?.isEmpty)!  {
            SVProgressHUD.showError(withStatus: "All fields are required")
            return
        }
        else if termsButton.currentImage == #imageLiteral(resourceName: "UnTick") {
            SVProgressHUD.showError(withStatus: "Please agree to terms and conditions")
            return
        }
        else if emailTF.isValidEmail {
            if phoneNumberTF.isOnlyPhone {
                StaffStore.sharedInstance.addNewStaffMember(UserStore.sharedInstance.userInfo, "", firstNameTF.text!, lastNameTF.text!, phoneNumberTF.text!, emailTF.text!, adminPaidStatus, allMediaStatus, allInvoicesStatus, completion: { (resposne) in
                    print(resposne as Any)
                    let responseData = resposne?["response"] as! NSDictionary
                    if responseData["status"] as! String == "1" {
                        SVProgressHUD.showSuccess(withStatus: "Staff member added successfully")
                        self.popOrDismissViewController(true)
                    } else {
                        SVProgressHUD.showError(withStatus: responseData["message"] as? String)
                    }
                })
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.CONTAINSNUMBERONLY_ERROR)
                return
            }
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
            return
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.popOrDismissViewController(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
