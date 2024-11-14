//
//  CampaignRatingViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD

class CampaignRatingViewController: AbstractControl {

    @IBOutlet var CampaignRatingView: CosmosView!
    
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    
    var localCompaign: LocalCampaignStore?
    
    
    
    // MARK: - Class Functions
    class func showControl(_ model: LocalCampaignStore) -> CampaignRatingViewController {
        let control = self.control as! CampaignRatingViewController
        control.localCompaign = model
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
        return control
    }
    
    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
        SetUI()
        holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4) {
            self.holderView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        backButton.touchUpInsideBlock {
            UIView.animate(withDuration: 0.4, animations: {
                self.holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }, completion: { (completed) in
                self.view.removeFromSuperview()
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
    
    func SetUI() {
        commentTextView.addBorder(pinkBorderColor)
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        CampaignStore.sharedInstance.rateCampaign(UserStore.sharedInstance.userInfo, (localCompaign?.targetId)!, String(CampaignRatingView.rating), commentTextView.text!) { (resposne) in
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Thanks For Rating")
                self.view.removeFromSuperview()
            } else {
                self.view.removeFromSuperview()
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }

}
