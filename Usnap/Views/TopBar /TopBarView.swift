//
//  TopBarView.swift
//  Usnap
//
//  Created by Mobile on 09/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

protocol TopBarDelegate {
    func backButtonClicked()
    func leftButtonClicked1()
    func leftButtonClicked2()
}

@IBDesignable
open class TopBarView: UIView {
    
    static let shared = TopBarView()
    var rightButtonAction = String()
    
    
    
    //STORE VARIABLE
    var count = 1
    var delegate: TopBarDelegate!
    
//    @IBInspectable
//    public var backButtonImage: UIImage = UIImage() {
//        didSet {
//            backButton.setImage(backButtonImage, for: .normal)
//            if self.backButton.currentImage == #imageLiteral(resourceName: "TopBarMenu") {
//                self.backButton.addTarget(SlideNavigationController.sharedInstance(), action: #selector(SlideNavigationController.toggleLeftMenu), for: .touchUpInside)
//            }
//        }
//    }
    
    @IBInspectable
    public var LeftButton1Image: UIImage = UIImage() {
        didSet {
            leftButton1.setImage(LeftButton1Image, for: .normal)
        }
    }
    
    @IBInspectable
    public var LeftButton2Image: UIImage = UIImage() {
        didSet {
            leftButton2.setImage(LeftButton2Image, for: .normal)
        }
    }
    
    @IBInspectable
    public var logoImage: UIImage = UIImage() {
        didSet {
            logo.image = logoImage
            logo.contentMode = .scaleAspectFit
        }
    }
    
    @IBInspectable
    public var showleftButton1: Bool = true {
        didSet {
            leftButton1.isHidden = !showleftButton1
        }
    }
    
    @IBInspectable
    public var showleftButton2: Bool = true {
        didSet {
            leftButton2.isHidden = !showleftButton2
        }
    }
    
    @IBInspectable
    public var showBackButton: Bool = true {
        didSet {
//            backButton.isHidden = !showBackButton
        }
    }
    
    @IBInspectable
    public var showBorder: Bool = true {
        didSet {
            lineView.isHidden = !showBorder
            
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
//        addSubviews([backButton, logo, leftButton1, leftButton2, lineView])
    }
    
    func updateView(_ newCount: Int) {
        count = newCount
        print(count)
//        backButton.image = count > 1 ? #imageLiteral(resourceName: "BackIcon") : #imageLiteral(resourceName: "TopBarMenu")
    }
    
    // MARK: - Setter getter methods
    
    var _backButton: UIButton!
//    var backButton: UIButton {
//        get {
//            if _backButton == nil {
////                _backButton = UIButton(type: .custom)
////                _backButton.touchUpInsideBlock({
////                    if self.backButton.currentImage == #imageLiteral(resourceName: "TopBarMenu") {
////                        print("qazxsedcfrvgtbyhynjmjuikk ")
////                        //NotificationCenter.default.post(name: "updateMenu", object: nil)
////                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMenu") , object: nil)
////                    } else {
////                        UIApplication.visibleViewController.popOrDismissViewController(true)
////                    }
////                })
//            }
////            return _backButton
//        }  set {
//            _backButton = newValue
//        }
//    }
    
    var _logo: UIImageView!
    var logo: UIImageView {
        get {
            if _logo == nil {
                _logo = UIImageView()
            }
            return _logo
        } set {
            _logo = newValue
        }
    }
    
    var _leftButton1: UIButton!
    var leftButton1: UIButton {
        get {
            if _leftButton1 == nil {
                _leftButton1 = UIButton(type: .custom)
                _leftButton1.touchUpInsideBlock {
                    self.delegate.leftButtonClicked1()
                }
            }
            return _leftButton1
        }
        set {
            _leftButton1 = newValue
        }
    }
    
    var _leftButton2: UIButton!
    var leftButton2: UIButton {
        get {
            if _leftButton2 == nil {
                _leftButton2 = UIButton(type: .custom)
                _leftButton2.touchUpInsideBlock {
                    self.delegate.leftButtonClicked2()
                }
            }
            return _leftButton2
        }
        set {
            _leftButton2 = newValue
        }
    }
    
    var _lineView: BorderLineView!
    var lineView: BorderLineView {
        get {
            if _lineView == nil {
                _lineView = BorderLineView()
            }
            return _lineView
        }
        set {
            _lineView = newValue
        }
    }
    
    // MARK: - Layout methods
    override open func layoutSubviews() {
        super.layoutSubviews()
//        let subviews: [String: UIView] = ["back": "backButton", "logo": logo, "leftButton1": leftButton1, "leftButton2": leftButton2, "line": lineView]
//        addVisualConstraints(["H:|-10-[back(30)]-(>=1)-[logo]-(>=1)-[leftButton1(45)]-5-[leftButton2(45)]-10-|", "V:|[back]|","V:|[logo]|", "V:[leftButton1(45)]", "V:[leftButton2(45)]", "V:[line]|", "H:|[line]|"], subviews: subviews)
//        addConstraintSameCenterXY(self, and: logo)
//        addConstraintSameCenterY(self, view2: leftButton1)
//        addConstraintSameCenterY(self, view2: leftButton2)
//        _ = addConstraintForHeight(50.0)
    }
    
    func leftButtonClicked2()  {
        
    }
    
//    func backButtonClicked() {
//        if count > 1 {
//            UIApplication.visibleViewController.popOrDismissViewController(true)
//        } else {
//            self.backButton.addTarget(SlideNavigationController.sharedInstance(), action: #selector(SlideNavigationController.toggleLeftMenu), for: .touchUpInside)
//        }
//    }
}
