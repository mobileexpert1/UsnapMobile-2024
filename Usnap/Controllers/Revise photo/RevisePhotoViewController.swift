//
//  RevisePhotoViewController.swift
//  Usnap
//
//  Created by CSPC141 on 03/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import CoreFoundation
import ACEDrawingView
import AVFoundation
import SVProgressHUD



class RevisePhotoViewController: AbstractControl, ACEDrawingViewDelegate, UINavigationControllerDelegate, TopBarDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backView: UIView!
    @IBOutlet var drawingHolderView: UIView!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var redoButton: UIButton!
    @IBOutlet var drawButton: UIButton!
    @IBOutlet var writeTextButton: UIButton!
    @IBOutlet var drawingView: ACEDrawingView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var commentTF: UITextView!
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var topImageHeightConstraint: NSLayoutConstraint!
    
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var applyToAllBool = String()
    
    var selectedCategoryId = "0"
    
//    var selectedCategoryQuantity = ""
//    var selectedCategoryAddOn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        centeredNavBarImageView()
               let closeButtonImage = UIImage(named: "BackIcon")
                       navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(RevisePhotoViewController.barButtonDidTaps(_:)))
        
        
        let closeButtonImage1 = UIImage(named: "ReviceDone")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage1, style: .plain, target: self, action:  #selector(RevisePhotoViewController.barButtonDidTap(_:)))
        
        topBar.delegate = self
        drawingView.delegate = self
        topImageView.image = CompletedCampaignStore.sharedInstance.mediaImage
        
        applyToAllBool = "0"
        self.drawingView.draggableTextFontName = "MarkerFelt-Thin";
        commentTF.text = CompletedCampaignStore.sharedInstance.mediaComment
        manageTopHeight(CompletedCampaignStore.sharedInstance.imageHeight, CompletedCampaignStore.sharedInstance.imageWidth)
        drawingView.isUserInteractionEnabled = false
        self.drawingView.lineColor = UIColor.red
        drawingView.drawTool = ACEDrawingToolTypePen
        self.drawingView.lineWidth = 3.0
        AppUtility.lockOrientation(.all)
        
        selectedCategoryId = CompletedCampaignStore.sharedInstance.selectedCategoryId
        print("RevisePhotoViewController = ",selectedCategoryId)
        
        
        
        
        
        
        scrollView.isScrollEnabled = true
        writeTextButton.isUserInteractionEnabled = true
        drawButton.isUserInteractionEnabled = true
        redoButton.isUserInteractionEnabled = true
        undoButton.isUserInteractionEnabled = true
        setButtonImages()
        
        //btnCategory.centerVertically()
    }
    
    
    @objc func barButtonDidTaps(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func centeredNavBarImageView() {
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
    
    
    
    
    
    
    
    func setButtonImages()  {
        writeTextButton.setImage(#imageLiteral(resourceName: "UnselectedWriteButton"), for: .normal)
        drawButton.setImage(#imageLiteral(resourceName: "UnselectedEditButton"), for: .normal)
    }
    
    
    func manageTopHeight(_ serverHeight : Float, _ serverWidth : Float)   {
        //        var backendHeight = Float()
        //        var backendWidth = Float()
        //        var screenWidth = Float()
        //        var widthRatio = Float()
        //        backendHeight = serverHeight
        //        backendWidth = serverWidth
        //        screenWidth = Float(self.view.frame.size.width)
        //        widthRatio = screenWidth / backendWidth
        topImageHeightConstraint.constant = 420
        //topImageHeightConstraint.constant = CGFloat(backendHeight * widthRatio)
    }
    
    
    
    func leftButtonClicked1() {
        
    }
    
    func leftButtonClicked2() {
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
        
        drawingView.isUserInteractionEnabled = false
        if topBar.leftButton2.currentImage == #imageLiteral(resourceName: "ReviceDone") {
            topBar.leftButton2.setImage(#imageLiteral(resourceName: "ReviceEdit"), for: .normal)
            scrollView.isScrollEnabled = true
            writeTextButton.isUserInteractionEnabled = false
            drawButton.isUserInteractionEnabled = false
            redoButton.isUserInteractionEnabled = false
            undoButton.isUserInteractionEnabled = false
        }
        else {
            topBar.leftButton2.setImage(#imageLiteral(resourceName: "ReviceDone"), for: .normal)
            scrollView.isScrollEnabled = false
            writeTextButton.isUserInteractionEnabled = true
            drawButton.isUserInteractionEnabled = true
            redoButton.isUserInteractionEnabled = true
            undoButton.isUserInteractionEnabled = true
        }
    }
    
    
    func killScroll() {
        
        if scrollView.isScrollEnabled == false {
            
        }
        else {
            
        }
    }
    
    func backButtonClicked() {
        
    }
    
    func setUI()  {
        let borderColor = UIColor(red: 0.8431, green: 0.5059, blue: 0.6784, alpha: 1)
        commentTF.addBorder(borderColor)
    }
    
    @IBAction func btnCategoryClick(_ sender: UIButton) {
        
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let home = storyBoard.instantiateViewController(withIdentifier: "CreditSubCategories") as! CreditSubCategories
//        home.delegate = self
//        home.selectedCategory = selectedCategoryId
//        navigationController?.pushViewController(home, animated: true);
        
//        let Campaign = SubCategories(dictionary: ["categoryId":selectedCategoryId])
//        navigationController?.pushViewController(CreditSubCategories.control(Campaign!), animated: true)
    }
    
    @IBAction func applyButtonClick(_ sender: Any) {
        if applyButton.currentImage == #imageLiteral(resourceName: "Tick") {
            applyButton.setImage(#imageLiteral(resourceName: "UnTick"), for: .normal)
        }
        else {
            applyButton.setImage(#imageLiteral(resourceName: "Tick"), for: .normal)
        }
        applyToAllBool = applyToAllBool.makeOppositeString(applyToAllBool)
    }
    
    func drawingView(_ view: ACEDrawingView?, didEndDrawUsing tool: ACEDrawingTool?) {
        updateButtonStatus()
    }
    
    func updateButtonStatus() {
        undoButton.isEnabled = drawingView.canUndo()
        redoButton.isEnabled = drawingView.canRedo()
    }
    
    
    @IBAction func writeTextButton(_ sender: Any) {
        
        writeTextButton.setImage(#imageLiteral(resourceName: "WriteIcon"), for: .normal)
        drawButton.setImage(#imageLiteral(resourceName: "UnselectedEditButton"), for: .normal)
        drawingView.isUserInteractionEnabled = true
        drawingView.draggableTextFontName = "MarkerFelt-Thin"
        self.drawingView.lineColor = UIColor.red
        self.drawingView.drawTool = ACEDrawingToolTypeDraggableText
        self.drawingView.lineWidth = 3.0
    }
    
    @IBAction func drawButton(_ sender: Any) {
        writeTextButton.setImage(#imageLiteral(resourceName: "UnselectedWriteButton"), for: .normal)
        drawButton.setImage(#imageLiteral(resourceName: "EditIconImage"), for: .normal)
        
        // set draggable text properties
        //        if drawingView.isUserInteractionEnabled == false{
        //            drawingView.isUserInteractionEnabled = true
        //            //scrollView.isUserInteractionEnabled = false
        //        }else{
        //            drawingView.isUserInteractionEnabled = false
        //            //scrollView.isUserInteractionEnabled = true
        //        }
        drawingView.isUserInteractionEnabled = true
        drawingView.draggableTextFontName = "MarkerFelt-Thin"
        self.drawingView.lineColor = UIColor.red
        drawingView.drawTool = ACEDrawingToolTypePen
        self.drawingView.lineWidth = 3.0
    }
    
    @IBAction func redoButton(_ sender: Any) {
        drawingView.redoLatestStep()
        updateButtonStatus()
    }
    
    @IBAction func undoButton(_ sender: Any) {
        drawingView.undoLatestStep()
        updateButtonStatus()
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if commentTF.text == "" {
            SVProgressHUD.showError(withStatus: "Please enter comment")
        }
        else {
            commentTF.resignFirstResponder()
            var image = UIImage()
            UIGraphicsBeginImageContext(backView.frame.size)
            let size = self.backView.frame.size
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backView.layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let tempArray = NSMutableArray()
            tempArray.add(ImageStore.sharedDate.ConvertImageToData(targetImage:image))
            
            CampaignStore.sharedInstance.sendCommentImage(CompletedCampaignStore.sharedInstance.CompletedCampaignId, CompletedCampaignStore.sharedInstance.CompletedcampaignImageId, commentTF.text!, applyToAllBool, tempArray) { (response) in
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus:"IMAGE INSTRUCTIONS SAVED TO CAMPAIGN.")
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.popOrDismissViewController(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//extension RevisePhotoViewController: UpdateSelectedCategoryModelDelegate {
//    func updateSelectedCategorResponse(inpuData: [SubCategorySelectedModel]) {
//        print("inpuData = ",inpuData)
//
//        var selectedyQuantity = [""]
//        var selectedCategoryAddOnServices = [""]
//
//        selectedyQuantity.removeAll()
//        selectedCategoryAddOnServices.removeAll()
//
//        for i in 0..<inpuData.count {
//            selectedyQuantity.append(inpuData[i].selectedQuantity ?? "")
//            selectedCategoryAddOnServices.append(inpuData[i].subcategoryId ?? "")
//        }
//
//        selectedCategoryQuantity = selectedyQuantity.joined(separator: ",")
//        selectedCategoryAddOn = selectedCategoryAddOnServices.joined(separator: ",")
//
//        print(selectedCategoryQuantity,selectedCategoryAddOn)
//
//    }
//}
