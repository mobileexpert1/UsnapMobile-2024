//
//  UIAlertController.swift
//
//  Created by Bikramjit Singh on 23/02/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // Shows alert view with completion block
    class func alert(_ title: String, message: String, buttons: [String], completion: ((_ : UIAlertController, _ : Int) -> Void)?) -> UIAlertController {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        // Add all other buttons
        return alertView! 
    }
    
    // Shows alert view with completion block
    class func showAlert(_ title: String, message: String, buttons: [String], completion: ((UIAlertController, Int) -> Void)?) {
        let alertView: UIAlertController? = self.init(title: title, message: message, preferredStyle: .alert)
        for i in 0..<buttons.count {
            alertView?.addAction(UIAlertAction(title: buttons[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i)
                }
            }))
        }
        UIApplication.visibleViewController.present(alertView!, animated: true, completion: nil)
    }
    
    //! Shows action sheet with completion block
    class func showActionSheet(_ title: String!, cbTitle: String!, dbTitle: String!, obTitles: [String]!, holdView: UIView!, completion: ((_ alert: UIAlertController, _ buttonIndex: Int) -> Void)?) {
        let alertView: UIAlertController? = self.init(title: title, message: nil, preferredStyle: .actionSheet)
        
        var inc: Int = 0
        if (dbTitle.count != 0) {
            inc += 1
            alertView?.addAction(UIAlertAction(title: dbTitle, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, 0)
                }
            })) // Destructive button
        }
        if (cbTitle.count != 0) {
            inc += 1
            alertView?.addAction(UIAlertAction(title: cbTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, dbTitle.count != 0 ? 1 : 0)
                }
            })) // Cancel button
        }
        
        for i in 0..<obTitles.count {
            alertView?.addAction(UIAlertAction(title: obTitles[i], style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if completion != nil {
                    completion!(alertView!, i + inc)
                }
            }))
        } // Add all other buttons
        
        if let popoverPresentationController = alertView!.popoverPresentationController {
            popoverPresentationController.sourceView = holdView
            popoverPresentationController.sourceRect = holdView.bounds
        }
        UIApplication.visibleViewController.present(alertView!, animated: true, completion: nil)
    }
    
    static func notifyUser(_ title: String, message: String, alertButtonTitles: [String], alertButtonStyles: [UIAlertActionStyle], vc: UIViewController, completion: @escaping (Int)->Void) -> Void {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        for title in alertButtonTitles {
            let actionObj = UIAlertAction(title: title,
                                          style: alertButtonStyles[alertButtonTitles.index(of: title)!], handler: { action in
                                            completion(alertButtonTitles.index(of: action.title!)!)
            })
            alert.addAction(actionObj)
        }
        
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
}


