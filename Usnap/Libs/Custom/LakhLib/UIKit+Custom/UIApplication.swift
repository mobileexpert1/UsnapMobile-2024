//
//  UIApplication.swift
//
//  Created by Bikramjit Singh on 23/02/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class var appWindow: UIWindow! {
        return (UIApplication.shared.delegate?.window!)!
    }
    
    class var rootViewController: UIViewController! {
        return self.appWindow.rootViewController!
    }
    
    class var visibleViewController: UIViewController! {
        return self.rootViewController.findContentViewControllerRecursively()
    }
    
    class var visibleNavigationController: UINavigationController! {
        return self.visibleViewController.navigationController!
    }
    
    class var visibleTabBarController: UITabBarController! {
        return self.visibleViewController.tabBarController!
    }
    
    class var visibleSplitViewController: UISplitViewController! {
        return self.visibleViewController.splitViewController!
    }

    class func pushOrPresent(_ viewController: UIViewController, animated: Bool) {
        if self.visibleNavigationController != nil {
            self.visibleNavigationController.pushViewController(viewController, animated: animated)
        } else {
            self.visibleViewController.present(viewController, animated: animated, completion: nil)
        }
    }
    
    class var appWindowFrame: CGRect {
        return self.appWindow.frame
    }
    
    class var navigationBarFrame: CGRect {
        return self.visibleNavigationController.navigationBar.frame
    }
    
    class var navigationBarHeight: CGFloat {
        return self.navigationBarFrame.size.height
    }
    
    class var statusBarHeight: CGFloat {
        return self.shared.statusBarFrame.size.height
    }
    
    class var tabBarFrame: CGRect {
        return self.visibleTabBarController.tabBar.frame
    }
    
    class var tabBarHeight: CGFloat {
        return self.tabBarFrame.size.height
    }

    class var interfaceOrientation: UIInterfaceOrientation {
        return self.shared.statusBarOrientation
    }
    
    class var interfaceOrientationIsLandscape: Bool {
        return self.interfaceOrientation == .landscapeLeft || self.interfaceOrientation == .landscapeRight
    }
    
    class var interfaceOrientationIsPortrait: Bool {
        return self.interfaceOrientation == .portrait
    }
    
    class var interfaceOrientationIsPortraitOrUpsideDown: Bool {
        return self.interfaceOrientation == .portrait || self.interfaceOrientation == .portraitUpsideDown
    }
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    class ErrorReporting {
        static func showMessage(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}


