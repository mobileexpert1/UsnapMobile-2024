//
//  MenuSliderButton.swift
//  Planet
//
//  Created by CSPC141 on 24/11/16.
//  Copyright © 2016 CSPC141. All rights reserved.
//

import UIKit

class MenuSliderButton: UIButton {
    
    func initMethod(targetView: UIViewController)   {
    let status_height = UIApplication.shared.statusBarFrame.size.height
        
        //let screenHeight = targetView.view.frame.size.height
        
        let yAxis = 0.05281690140845 * self.ScreenSize().height
        
        let button: UIButton = UIButton()
        button.frame = CGRect(x: 10, y: yAxis, width:  30, height: 30)
        button.setImage(UIImage(named:"Menu"), for: .normal)
        
        button.addTarget(SlideNavigationController.sharedInstance(), action: #selector(SlideNavigationController.toggleLeftMenu), for: .touchUpInside)
        targetView.view .addSubview(button)
        
    }

    func ScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
}
