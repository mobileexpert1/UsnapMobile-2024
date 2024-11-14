//
//  AbstractControl.swift
//  Usnap
//
//  Created by Mobile on 20/12/17.
//  Copyright © 2017 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UITextView_Placeholder


class AbstractControl: UIViewController {
    
    //MARK:- Get control from storyboard.
    class var control: AbstractControl {
        return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! AbstractControl
    }
    
    class func getViewController() -> AbstractControl{
     return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! AbstractControl
    }
    
    
    
    
    var bgImageBool : Bool = true
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
    
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        if bgImageBool == true {
          view.insertSubview(backGround, at: 0)
        }
        else {
            
        }
       
        self.navigationItem.setHidesBackButton(true, animated:true);
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    //MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    
//    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
    
    func centeredNavBarImageView() {
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backGround.addConstraintToFillSuperview()
    }
    
    //MARK:- STATUS BAR COLOR
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- SETTER GETTER METHOD
    @IBOutlet var listContainer: UIView!
    
    var navControl: UINavigationController! {
        return navigationController
    }
    
    var _backGround: UIImageView?
    var backGround: UIImageView {
        get {
            if _backGround == nil {
                _backGround = UIImageView.init(image: #imageLiteral(resourceName: "HomeBg"))
            }
            return _backGround!
        }
        set {
            _backGround = newValue
        }
    }

    //MARK:- FUNCTIONS
    
    //back button
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //alert
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "U SNAP", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- _____________________________
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
