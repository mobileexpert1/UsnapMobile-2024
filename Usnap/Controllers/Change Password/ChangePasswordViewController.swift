//
//  ChangePasswordViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordViewController: AbstractControl {

    @IBOutlet var oldPasswordTF: UITextField!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var topBarViews: TopBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
               
               let closeButtonImage = UIImage(named: "BackIcon")
                       navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(ChangePasswordViewController.barButtonDidTap(_:)))
        
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
    
    func setUI()  {
        oldPasswordTF.addBorder(pinkBorderColor)
        newPasswordTF.addBorder(pinkBorderColor)
        confirmPasswordTF.addBorder(pinkBorderColor)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        oldPasswordTF.text = ""
        newPasswordTF.text = ""
        confirmPasswordTF.text = ""
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButtonClick(_ sender: Any) {
        if (oldPasswordTF.text?.isEmpty)! || (newPasswordTF.text?.isEmpty)! || (confirmPasswordTF.text?.isEmpty)!  {
            SVProgressHUD.showError(withStatus: "All fields are required")
            return
        }
        else if newPasswordTF.text == confirmPasswordTF.text {
            UserStore.sharedInstance.ChangePassword(UserStore.sharedInstance.userInfo, oldPasswordTF.text!, newPasswordTF.text!, completion: { (resposne) in
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Password updated successfully")
                    self.popOrDismissViewController(true)
                } else {
                    SVProgressHUD.showError(withStatus: Constants.PASSWORD_NOT_SAME)
                }
            })

        }
        else {
            SVProgressHUD.showError(withStatus: "New password and confirm password must be same")
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
