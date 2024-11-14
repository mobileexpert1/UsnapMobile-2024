//
//  QuickAcessPopUpViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/03/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

protocol userSelectionButtonDelegate {
    func selectedButtonClicked(string: String)
}

class QuickAcessPopUpViewController: AbstractControl {
    var delegate: userSelectionButtonDelegate?
    
    // MARK: - Class Functions
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    class func showCustomControl(controller:UIViewController){
        let control = QuickAcessPopUpViewController.getViewController() as! QuickAcessPopUpViewController
        control.delegate = controller as? userSelectionButtonDelegate
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var holderView: UIView!
    
    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.removeObserver(self)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
    }

    
    @IBAction func TakePhotoClick(_ sender: Any) {
        addObserVer("Camera")
    }
    
    @IBAction func gallaryClick(_ sender: Any) {
        addObserVer("gallery")
    }
    
    @IBAction func createCamapaignClick(_ sender: Any) {
        self.addObserVer("createCampaign")
    }
    
    @IBAction func campaignListClick(_ sender: Any) {
        addObserVer("campaignList")
    }
    
    
    func addObserVer(_ buttonAction : String)  {
        NotificationCenter.default.removeObserver(self)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.DELAYTIME - 1.0 ) { // change 2 to desired number of seconds
            // Your code with delay
            //delegate?.selectedButtonClicked(string: buttonAction)
            self.view.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
            let Observer = NotificationCenter.default
            Observer.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
            Observer.post(name:Notification.Name(rawValue:ConstantsKeys.HOMEPOPNOTIFICATION_KEY),
                          object: nil,
                          userInfo: ["ButtonAction":buttonAction])
            
           
            
          //  self.view.removeFromSuperview()
           // self.dismiss(animated: true, completion: nil)
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
