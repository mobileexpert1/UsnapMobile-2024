//
//  AppUtilities.swift
//  Usnap
//
//  Created by CSPC141 on 17/07/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import Foundation


struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if #available(iOS 13.0, *) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
   
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
