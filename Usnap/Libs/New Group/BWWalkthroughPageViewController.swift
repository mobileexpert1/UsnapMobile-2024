/*
The MIT License (MIT)

Copyright (c) 2015 Yari D'areglia @bitwaker

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


import UIKit

public enum WalkthroughAnimationType:String{
    case Linear = "Linear"
    case Curve = "Curve"
    case Zoom = "Zoom"
    case InOut = "InOut"
    
    init(_ name:String){
        
        if let tempSelf = WalkthroughAnimationType(rawValue: name){
            self = tempSelf
        }else{
            self = .Linear
        }
    }
}

open class BWWalkthroughPageViewController: UIViewController, BWWalkthroughPage {
    @IBOutlet var tutorialImage1: UIImageView!
    
    @IBOutlet var tutorialImage2: UIImageView!
    @IBOutlet var tutorialImage3: UIImageView!
    private var animation:WalkthroughAnimationType = .Linear
    private var subviewsSpeed:[CGPoint] = Array()
    private var notAnimatableViews:[Int] = [] // Array of views' tags that should not be animated during the scroll/transition
    
    // MARK: Inspectable Properties
    // Edit these values using the Attribute inspector or modify directly the "User defined runtime attributes" in IB
    @IBInspectable var speed:CGPoint = CGPoint(x: 0.0, y: 0.0);            // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
    @IBInspectable var speedVariance:CGPoint = CGPoint(x: 0.0, y: 0.0)     // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
    @IBInspectable var animationType:String {
        set(value){
            self.animation = WalkthroughAnimationType(rawValue: value)!
        }
        get{
            return self.animation.rawValue
        }
    }
    @IBInspectable var animateAlpha:Bool = false
    @IBInspectable var staticTags:String {                                 // A comma separated list of tags that you don't want to animate during the transition/scroll 
        set(value){
            self.notAnimatableViews = value.components(separatedBy: ",").map{Int($0)!}
        }
        get{
            return notAnimatableViews.map{String($0)}.joined(separator: ",")
        }
    }
    
    
    // MARK: BWWalkthroughPage Implementation

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //AppUtility.lockOrientation(.portrait)
        self.view.layer.masksToBounds = true
        subviewsSpeed = Array()
           NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
        for v in view.subviews{
            speed.x += speedVariance.x
            speed.y += speedVariance.y
            if !notAnimatableViews.contains(v.tag) {
                subviewsSpeed.append(speed)
            }
        }
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            setLandscapeImages()
        }
            
        else {
            print("Portrait")
            setPortraitImages()
            
        }
    }
    
//    override open var shouldAutorotate: Bool {
//        tutorialImage2.image = #imageLiteral(resourceName: "T3")
//        return false
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            setLandscapeImages()
           
        } else {
            print("Portrait")
            setPortraitImages()
        }
    }
    
    
    func setLandscapeImages()  {
        for view in self.view.subviews as [UIView] {
            if let currentImage = view as? UIImageView {
                print(currentImage.tag)
                if currentImage.tag == 1 {
                  currentImage.image = #imageLiteral(resourceName: "T1Landscape")
                }
                if currentImage.tag == 2 {
                   currentImage.image = #imageLiteral(resourceName: "T2Landscape")
                }
                if currentImage.tag == 3 {
                    currentImage.image = #imageLiteral(resourceName: "T3Landscape")
                }
            }
        }
    }
    
    func setPortraitImages()  {
        for view in self.view.subviews as [UIView] {
            if let currentImage = view as? UIImageView {
                print(currentImage.tag)
                if currentImage.tag == 1 {
                    currentImage.image = #imageLiteral(resourceName: "T1")
                }
                if currentImage.tag == 2 {
                    currentImage.image = #imageLiteral(resourceName: "T2")
                }
                if currentImage.tag == 3 {
                    currentImage.image = #imageLiteral(resourceName: "T3")
                }
            }
        }
    }
    
    
//    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//             tutorialImage2.image = #imageLiteral(resourceName: "T3")
//        } else {
//            print("Portrait")
//            //imageView.image = UIImage(named: const)
//        }
//    }
    
    
    open func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        
        for i in 0 ..< subviewsSpeed.count {
            
            // Perform animations
            switch animation{
                
            case .Linear:
                animationLinear(i, offset)
                
            case .Zoom:
                animationZoom(i, offset)
                
            case .Curve:
                animationCurve(i, offset)
                
            case .InOut:
                animationInOut(i, offset)
            }
            
            // Animate alpha
            if(animateAlpha){
                animationAlpha(i, offset)
            }
        }
    }

    // MARK: Animations
    
    private func animationAlpha(_ index:Int, _ offset:CGFloat) {
        let cView = view.subviews[index]
        var mutableOffset = offset
        if(mutableOffset > 1.0){
            mutableOffset = 1.0 + (1.0 - mutableOffset)
        }
        cView.alpha = (mutableOffset)
    }
    
    private func animationCurve(_ index:Int, _ offset:CGFloat) {
        var transform = CATransform3DIdentity
        let x:CGFloat = (1.0 - offset) * 10
        transform = CATransform3DTranslate(transform, (pow(x,3) - (x * 25)) * subviewsSpeed[index].x, (pow(x,3) - (x * 20)) * subviewsSpeed[index].y, 0 )
        applyTransform(index, transform: transform)
    }
    
    private func animationZoom(_ index:Int, _ offset:CGFloat) {
        var transform = CATransform3DIdentity

        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        let scale:CGFloat = (1.0 - tmpOffset)
        transform = CATransform3DScale(transform, 1 - scale , 1 - scale, 1.0)
        applyTransform(index, transform: transform)
    }
    
    private func animationLinear(_ index:Int, _ offset:CGFloat) {
        var transform = CATransform3DIdentity
        let mx:CGFloat = (1.0 - offset) * 100
        transform = CATransform3DTranslate(transform, mx * subviewsSpeed[index].x, mx * subviewsSpeed[index].y, 0 )
        applyTransform(index, transform: transform)
    }
    
    private func animationInOut(_ index:Int, _ offset:CGFloat) {
        var transform = CATransform3DIdentity
        
        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        transform = CATransform3DTranslate(transform, (1.0 - tmpOffset) * subviewsSpeed[index].x * 100, (1.0 - tmpOffset) * subviewsSpeed[index].y * 100, 0)
        applyTransform(index, transform: transform)
    }
    
    private func applyTransform(_ index:Int, transform:CATransform3D){
        let subview = view.subviews[index]
        if !notAnimatableViews.contains(subview.tag){
            view.subviews[index].layer.transform = transform
        }
    }
}
