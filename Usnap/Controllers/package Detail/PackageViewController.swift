//
//  PackageViewController.swift
//  Usnap
//
//  Created by CSPC141 on 15/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class PackageViewController: AbstractControl {

    @IBOutlet var subscribeButton: UIButton!
    @IBOutlet var DescText: UITextView!
    @IBOutlet var titleLabel: UILabel!
    var selectedPackage :  MemberShipResult!
    
    class func control(_ package : MemberShipResult) -> PackageViewController {
        let control = self.control as! PackageViewController
        control.selectedPackage = package
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var desc = selectedPackage.benefits
        desc = desc?.replaceString(selectedPackage.benefits!, "\\n-", "\n-")
        DescText.text = desc
        if selectedPackage.youAreSubscribedTo == "nothing" {
            subscribeButton.setTitle("Subscribe", for: UIControlState.normal)
        }
        else {
            subscribeButton.setTitle("Unsubscribe", for: UIControlState.normal)
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
         AppUtility.lockOrientation(.all)
   }
    
    @IBAction func subscribeClick(_ sender: Any) {
        if subscribeButton.titleLabel?.text == "Unsubscribe" {
            hitApi("0")
        }
        else {
            if selectedPackage.cardExist == "0" {
                UIAlertController.showAlert("Alert!", message: Constants.ENTERCARD, buttons: ["OK"], completion: { (alert, index) in
                })
            }
            else {
                hitApi("1")
            }
        }
    }
    
    func hitApi(_ action : String) {
        UserStore.sharedInstance.purchaseMembership(UserStore.sharedInstance.userInfo, selectedPackage.internalIdentifier!, action) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: responseData["message"] as? String)
                 self.performSegueToReturnBack()
            } else {
                SVProgressHUD.showError(withStatus: responseData["status"] as? String)
            }
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
