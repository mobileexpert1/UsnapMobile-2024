//
//  ContactUsViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class ContactUsViewController: AbstractControl {

    @IBOutlet var userDetailHolder: UIView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var emailViewHeight: NSLayoutConstraint!
    @IBOutlet var emailID: UITextField!
    @IBOutlet var campaignTF: UITextField!
    @IBOutlet var textTF: UITextView!
    
    @IBOutlet weak var topBarViews: TopBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(ContactUsViewController.barButtonDidTap(_:)))
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        setUI()
        if UserStore.sharedInstance.userInfo == "logout" {
           emailViewHeight.constant = 70
            userDetailHolder.isHidden = false
        }
        else {
            emailViewHeight.constant = 0
            userDetailHolder.isHidden = true
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

    func setUI()  {
        campaignTF.addBorder(pinkBorderColor)
        textTF.addBorder(pinkBorderColor)
        emailID.addBorder(pinkBorderColor)
        nameTF.addBorder(pinkBorderColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    
    
    
    @IBAction func callClick(_ sender: Any) {
        var phnNumber = String()
        phnNumber = "0428303587"
        
        if let url = NSURL(string: "tel://\(phnNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url as URL)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        
    }
    
    
    @IBAction func sendButtonClick(_ sender: Any) {
        
        if UserStore.sharedInstance.userInfo == "logout" {
            if (textTF.text?.isEmpty)! || (campaignTF.text?.isEmpty)! || (emailID.text?.isEmpty)! || (nameTF.text?.isEmpty)! {
                SVProgressHUD.showError(withStatus: "All fields are required")
                return
            }
            else if emailID.isValidEmail {
                sendDataToServer()
            }
            else  {
                SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
            }
        }
        else {
            if (textTF.text?.isEmpty)! || (campaignTF.text?.isEmpty)! {
                SVProgressHUD.showError(withStatus: "All fields are required")
                return
            }
            else  {
                sendDataToServer()
            }
        }
    }
    
    
    func sendDataToServer()  {
        var dynamicUserId = String()
        if UserStore.sharedInstance.userInfo == "logout" {
            dynamicUserId = ""
        }
        else {
            dynamicUserId = UserStore.sharedInstance.userInfo
        }
        
        MiscStore.sharedInstance.contactToAdmin(dynamicUserId, campaignTF.text!, textTF.text!, "1", emailID.text!, nameTF.text!,  completion: { (resposne) in
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Message sent successfully")
                self.popOrDismissViewController(true)
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
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
