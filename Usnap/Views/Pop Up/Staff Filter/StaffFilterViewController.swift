//
//  StaffFilterViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit


protocol staffFilterDelegate: class{
    func filterData(_ data : NSDictionary, _ clearButton: String)
}

class StaffFilterViewController: AbstractControl {

    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var mobileNumberTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var staffMemberNameTF: UITextField!
    weak var delegate: staffFilterDelegate?

    // MARK: - Class Functions
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
       // self.bgImageBool = false
        super.viewDidLoad()
        holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4) {
            self.holderView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        
        
        backButton.touchUpInsideBlock {
            UIView.animate(withDuration: 0.4, animations: {
                self.holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            }, completion: { (completed) in
                self.dismiss(animated: true, completion: nil)
            })
        }
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
        staffMemberNameTF.addBorder(pinkBorderColor)
        emailTF.addBorder(pinkBorderColor)
        mobileNumberTF.addBorder(pinkBorderColor)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        let tempDict = NSDictionary()
        delegate?.filterData(tempDict, "Yes")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
//        let Observer = NotificationCenter.default
//        Observer.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.STAFFFILTER_KEY), object: nil)
//
//        Observer.post(name:Notification.Name(rawValue:ConstantsKeys.STAFFFILTER_KEY),
//                      object: nil,
//                      userInfo: ["MemberName":staffMemberNameTF.text!, "EmailAddress": emailTF.text!, "mobileNumber" : mobileNumberTF.text!])
//
//        self.view.removeFromSuperview()
        
        var tempDict = NSDictionary()
        tempDict = ["MemberName":staffMemberNameTF.text!, "EmailAddress": emailTF.text!, "mobileNumber" : mobileNumberTF.text!]
        
        delegate?.filterData(tempDict, "No")
        self.dismiss(animated: true, completion: nil)
        
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
