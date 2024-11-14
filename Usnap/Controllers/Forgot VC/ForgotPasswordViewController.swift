//
//  ForgotPasswordViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: AbstractControl {

    @IBOutlet var emailTF: UITextField!
   @IBOutlet var thoughtLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var lodingBg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
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

    func setUI() {
        dayLabel.text = String(format: "%@ %@!", "Happy", DateStore.sharedDate.fetchLocalDay())
        emailTF.addLeftImage(#imageLiteral(resourceName: "EmailIcon"))
        emailTF.addBottomLabel(UIColor.lightGray)
    }
    
    @IBAction func backClick(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    @IBAction func forgotButtonClick(_ sender: Any) {
        if (emailTF.text?.isEmpty)!  {
            SVProgressHUD.showError(withStatus: Constants.EMAILREQURIED)
            return
        }
        else if emailTF.isValidEmail {
            UserStore.sharedInstance.forgotPassword(emailTF.text!, completion: { (resposne) in
                print(resposne as Any)
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: String(format: "%@ %@ %@", "Email is sent to", self.emailTF.text!, "to reset your password!"))
                     self.performSegueToReturnBack()
                } else {
                    SVProgressHUD.showError(withStatus: String(format: "%@ %@", self.emailTF.text!,"is not found"))
                }
            })
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
        }
        
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
