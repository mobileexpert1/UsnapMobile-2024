//
//  CampareViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class CampareViewController: AbstractControl {

    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var alphaSlider: UISlider!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
   
    // Class Function
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
        
        backImageView.alpha = 0.5
        frontImageView.alpha = 0.5
        
        let leftTrackImage = UIImage(named: "SlidThumb")
        alphaSlider.setThumbImage( leftTrackImage, for: UIControlState.normal)
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
        
        var backImageString = String(format: "%@%@", APIs.KIMAGEBASEURL, CompletedCampaignStore.sharedInstance.firstImageUrl)
        backImageString = backImageString.addPercentValue(backImageString)
        backImageView.sd_setImage(with: URL(string: backImageString), placeholderImage: UIImage(named: "DummySmallImage"))
        
        var frontImageString = String(format: "%@%@", APIs.KIMAGEBASEURL, CompletedCampaignStore.sharedInstance.lastImageUrl)
        frontImageString = backImageString.addPercentValue(frontImageString)
        frontImageView.sd_setImage(with: URL(string: frontImageString), placeholderImage: UIImage(named: "DummySmallImage"))
        
        AppUtility.lockOrientation(.all)
    }
    
    @IBAction func sliderChanges(_ sender: UISlider) {
        backImageView.alpha = CGFloat(1.01-sender.value)
        frontImageView.alpha = CGFloat(sender.value)
    }
}
