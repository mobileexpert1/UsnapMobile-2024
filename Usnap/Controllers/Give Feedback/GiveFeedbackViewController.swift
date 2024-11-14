//
//  GiveFeedbackViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class GiveFeedbackViewController: AbstractControl {

    @IBOutlet var screenTitleLabel: UILabel!
    @IBOutlet var messageTV: UITextView!
    @IBOutlet var campaignName: UITextField!
    @IBOutlet weak var topBarViews: TopBarView!
    var requestType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
               
               let closeButtonImage = UIImage(named: "BackIcon")
                       navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(GiveFeedbackViewController.barButtonDidTap(_:)))
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
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
    
    
    
    func setUI() {
        messageTV.addBorder(pinkBorderColor)
        campaignName.addBorder(pinkBorderColor)
        screenTitleLabel.text = UserStore.sharedInstance.requestStatus
    }

    @IBAction func sendButtonClick(_ sender: Any) {
        if (campaignName.text?.isEmpty)! || (messageTV.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "All fields are required")
            return
        }
        else  {
            var formTypeTempString = String()
            if screenTitleLabel.text == "Give Feedback" {
                formTypeTempString = "2"
            }
            else {
                formTypeTempString = "3"
            }
            
            MiscStore.sharedInstance.contactToAdmin(UserStore.sharedInstance.userInfo, campaignName.text!, messageTV.text!, formTypeTempString, "", "",  completion: { (resposne) in
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Message sent successfully")
                     self.popOrDismissViewController(true)
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
