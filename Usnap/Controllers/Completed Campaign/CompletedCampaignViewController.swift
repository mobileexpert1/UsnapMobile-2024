//
//  CompletedCampaignViewController.swift
//  Usnap
//
//  Created by CSPC141 on 17/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import TUCAssetsHelper
import AVFoundation
import AVKit
import GSImageViewerController
import ImageScrollView
import Photos
import SVProgressHUD

//https://github.com/dogo/AKMediaViewer

@available(iOS 13.0, *)
class CompletedCampaignViewController: AbstractControl, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
//    func leftButtonClicked1() {
//        <#code#>
//    }
//
//    func leftButtonClicked2() {
//        <#code#>
//    }
    
    
    
    @IBOutlet weak var creditUsed: UILabel!
    @IBOutlet var topShareButton: UIButton!
    
    @IBOutlet var tabBarHolderView: UIView!
    @IBOutlet var topImageHeightConst: NSLayoutConstraint!
    
    @IBOutlet var topCollectionScroller: HorizontalFlowLayout!
    @IBOutlet var collectionViewHeightConstraint: UICollectionView!
    
    @IBOutlet var topNoDataLabel: UILabel!
    @IBOutlet var collectionViewNoData: UILabel!
    @IBOutlet var titileLabel: UILabel!
    @IBOutlet var topVideoPlayButton: UIButton!
    @IBOutlet var photoCommentTextView: UITextView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var markButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var additionalServices: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var jobStatus: UILabel!
    @IBOutlet var numberOfVideos: UILabel!
    @IBOutlet var numberOfPhotos: UILabel!
    @IBOutlet var assignedTo: UILabel!
    @IBOutlet var contentBy: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var propertyCatagory: UILabel!
    @IBOutlet var photosButton: UIButton!
    @IBOutlet var videosButton: UIButton!
    @IBOutlet var payableAmount: UILabel!
    @IBOutlet var creditAmount: UILabel!
    @IBOutlet var dataCollectionView: UICollectionView!
    
    @IBOutlet var downloadDeleteButton: UIButton!
    @IBOutlet var downloadDeleteButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet var totalSizeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalSizeValueHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalSizeLabel: UILabel!
    
    @IBOutlet var monthCostStaticLabelHeightConstarint: NSLayoutConstraint!
    @IBOutlet var monthlyCostPrice: UILabel!
    
    @IBOutlet var monthlyCostHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imageScrollerCollectionView: UICollectionView!
    @IBOutlet var selectedCountLabel: UILabel!
    @IBOutlet var imageScroller: UICollectionView!
    @IBOutlet var mediaActionHolderView: UIView!
    @IBOutlet var holderViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet var bottomTabImage: UIImageView!
    
    @IBOutlet var presetsTableView: UITableView!
    var presetVersions = [String]()
    
    @IBOutlet var presetHolderView: UIView!
    
    var viewerCurrentImageIndex = Int()
    var videoDownloadCounter = Int()
    var imageSelectionType = String()
    var collectionDataType = String()
    var localCompaign: LocalCampaignStore?
    var selectedCampaign :  CampaignListresult!
    var campaignMediaList = [CampaignDetailcampaignImages]()
    var selectedMediaItems = [CampaignDetailcampaignImages]()
    var rowsWhichAreChecked = NSMutableArray()
    var currentImageIndex = Int()
    var selectedImages = [UIImage]()
    var tempImagesLink = [String]()
    var tempVideosLink = [String]()
    var presetActionType = String()
    
    
    var printVersionStatus = String()
    var webVersionStatus = String()
    var watermarkStatus = String()
    var webVersionSizes = String()
    var loginUserName = String()
    var selectedCampaignId = String()
    var campDataType = String()
    var tagLine = String()
    var campaignTitle = String()
    var userRoleId = String()
    
    var selectedCampaignCategoryId = ""
    
    @IBOutlet var viewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var viewerCommentHolder: UIView!
    
    @IBOutlet var presetAlphaView: UIView!
    @IBOutlet var viewerTextView: UITextView!
    @IBOutlet var imgViewerHolder: UIView!
    @IBOutlet var imgViewerCollectionView: UICollectionView!
    var showHide: Bool = false{
        didSet {
            if showHide == true {
                editButton.isHidden = false
                historyButton.isHidden = false
                markButton.isHidden = false
            }
            else {
                editButton.isHidden = true
                markButton.isHidden = true
                historyButton.isHidden = true
            }
        }
    }
    
    class func control(_ selectedCampaign : CampaignListresult) -> CompletedCampaignViewController {
        let control = self.control as! CompletedCampaignViewController
        control.selectedCampaign = selectedCampaign
        control.selectedCampaignId = selectedCampaign.internalIdentifier!
        return control
    }
    
    
    class func controlFromNavigation(_ selectedCampaignId : String) -> CompletedCampaignViewController {
        let control = self.control as! CompletedCampaignViewController
        control.selectedCampaignId = selectedCampaignId
        return control
    }
    
    
    
    //    struct AppUtility {
    //
    //        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    //
    //            if let delegate = UIApplication.shared.delegate as? AppDelegate {
    //                delegate.orientationLock = orientation
    //            }
    //        }
    //
    //        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    //        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
    //
    //            self.lockOrientation(orientation)
    //
    //            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    //        }
    //
    //    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionDataType = "Photo"
//        topBar.delegate = self
        self.showHide = true
        photoCommentTextView.addBorder(UIColor.lightGray)
        holderViewHeightCons.constant = 0
        imgViewerHolder.isHidden = true
        viewFlowLayout.itemSize = UIScreen.main.bounds.size
        viewFlowLayout.scrollDirection = .horizontal
        viewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        viewFlowLayout.minimumInteritemSpacing = 0.0
        campDataType = "final"
        self.getCampaignDetails()
        presetsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        presetHolderView.isHidden = true
        presetAlphaView.isHidden = true
        crossButton.isHidden = true
        
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(barButtonDidTap(_:)))
        
        let button = UIButton(type: .custom)
               button.setImage(UIImage(named: "FinalDataPink"), for: .normal)
               button.addTarget(self, action: #selector(RightbButtonPressedTwo), for: .touchUpInside)
               button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
               let barButton = UIBarButtonItem(customView: button)
               self.navigationItem.rightBarButtonItem = barButton
        
        let button1 = UIButton(type: .custom)
               button1.setImage(UIImage(named: "OriginalDataBlack"), for: .normal)
               button1.addTarget(self, action: #selector(RightOnebButtonPressed), for: .touchUpInside)
               button1.frame = CGRect(x: 0, y: 50, width: 40, height: 40)
               let barButton1 = UIBarButtonItem(customView: button1)
               self.navigationItem.rightBarButtonItem = barButton1
        
//        topBar.leftButton1.setImage(#imageLiteral(resourceName: "OriginalDataBlack"), for: .normal)
//        topBar.leftButton2.setImage(#imageLiteral(resourceName: "FinalDataPink"), for: .normal)
//        topShareButton.isHidden = false
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageSelectionType = "normal"
        //        self.topImageView.actionBlock {
        //            if self.topVideoPlayButton.isHidden == true {
        //                let imageInfo      = GSImageInfo(image: self.topImageView.image!, imageMode: .aspectFit, imageHD: nil)
        //                let transitionInfo = GSTransitionInfo(fromView: self.topImageView)
        //                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        //                self.present(imageViewer, animated: true, completion: nil)
        //            }
        //
        //        }
        convertOrientation()
    }
    
    func getCampaignDetails()  {
        CampaignStore.sharedInstance.getCampaignDETAIL(selectedCampaignId, campDataType) { (response) in
            if response?.campaignDetailresponse?.status == "1" {
                self.campaignMediaList = (response?.campaignDetailresponse?.campaignDetailresult?.campaignDetailcampaignImages)!
                
                self.selectedCampaignCategoryId = response?.campaignDetailresponse?.campaignDetailresult?.campaign_category_id ?? ""
                
                self.userRoleId = (response?.campaignDetailresponse?.campaignDetailresult?.userRoleId)!
                
                // self.propertyCatagory.text = response?.campaignDetailresponse?.campaignDetailresult?.category
                self.propertyCatagory.text = response?.campaignDetailresponse?.campaignDetailresult?.paymentStaus
                self.creationDate.text = response?.campaignDetailresponse?.campaignDetailresult?.addDate!.removeTimeFromString((response?.campaignDetailresponse?.campaignDetailresult?.addDate!)!)
                
                // self.creationDate.text = response?.campaignDetailresponse?.campaignDetailresult?.addDate!
                self.numberOfPhotos.text = String(format: "%d", (response?.campaignDetailresponse?.campaignDetailresult?.totalImages!)!)
                self.numberOfVideos.text = String(format: "%d", (response?.campaignDetailresponse?.campaignDetailresult?.totalVideos!)!)
                self.jobStatus.text = response?.campaignDetailresponse?.campaignDetailresult?.status!
                self.contentBy.text = response?.campaignDetailresponse?.campaignDetailresult?.contentBy!
                self.assignedTo.text = response?.campaignDetailresponse?.campaignDetailresult?.assignedTo!
                // In this label we are showing remaning days.
                self.totalPrice.text = response?.campaignDetailresponse?.campaignDetailresult?.remaningDays!
                
                self.creditUsed.text = response?.campaignDetailresponse?.campaignDetailresult?.credit_used!
                self.creditAmount.text = response?.campaignDetailresponse?.campaignDetailresult?.creditAmount!
                
                if response?.campaignDetailresponse?.campaignDetailresult?.credits != nil {
                    self.payableAmount.text = response?.campaignDetailresponse?.campaignDetailresult?.credits!
                }
               
                //self.payableAmount.text = response?.campaignDetailresponse?.campaignDetailresult?.amountPayable!
                
                // self.titileLabel.text = response?.campaignDetailresponse?.campaignDetailresult?.title
                
                self.campaignTitle = (response?.campaignDetailresponse?.campaignDetailresult?.title!)!
                
                self.titileLabel.text =    String(format: "#%d- %@ \n%@",  Int((response?.campaignDetailresponse?.campaignDetailresult?.internalIdentifier!)!)! + 100, (response?.campaignDetailresponse?.campaignDetailresult?.title!)!, (response?.campaignDetailresponse?.campaignDetailresult?.address!)!)
                
                
                
                
                
                
                self.loginUserName = (response?.campaignDetailresponse?.campaignDetailresult?.contentBy)!
                
                if response?.campaignDetailresponse?.campaignDetailresult?.nintyDays == "yes" {
                    self.totalSizeHeightConstraint.constant = 13
                    self.totalSizeValueHeightConstraint.constant = 13
                    self.monthCostStaticLabelHeightConstarint.constant = 13
                    self.monthlyCostHeightConstraint.constant = 13
                    self.downloadDeleteButtonConstraint.constant = 32
                    self.totalSizeLabel.text = response?.campaignDetailresponse?.campaignDetailresult?.campaignSize
                    self.monthlyCostPrice.text = response?.campaignDetailresponse?.campaignDetailresult?.storagePrice
                    self.downloadDeleteButton.isHidden =  false
                }
                else {
                    self.totalSizeHeightConstraint.constant = 0
                    self.totalSizeValueHeightConstraint.constant = 0
                    self.monthCostStaticLabelHeightConstarint.constant = 0
                    self.monthlyCostHeightConstraint.constant = 0
                    self.downloadDeleteButtonConstraint.constant = 0
                    self.downloadDeleteButton.isHidden =  true
                }
                if self.campaignMediaList.count == 0  {
                    self.topImageView.isHidden = true
                    self.topNoDataLabel.isHidden = false
                    self.dataCollectionView.isHidden = true
                    self.collectionViewNoData.isHidden = false
                    // self.downloadButton.isUserInteractionEnabled = false
                    self.crossButton.isHidden = true
                    self.imageScrollerCollectionView.isHidden = true
                    CompletedCampaignStore.sharedInstance.CompletedCampaignId = self.selectedCampaignId
                }
                else {
                    self.imageScrollerCollectionView.isHidden = false
                    self.topImageView.isHidden = false
                    self.topNoDataLabel.isHidden = true
                    self.dataCollectionView.isHidden = false
                    self.collectionViewNoData.isHidden = true
                    self.crossButton.isHidden = true
                    // self.downloadButton.isUserInteractionEnabled = true
                    self.currentImageIndex = 0
                    CompletedCampaignStore.sharedInstance.CompletedCampaignId = self.selectedCampaignId
                    CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[0].internalIdentifier!
                    if self.campaignMediaList[0].type == "p" {
                        // self.topImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(self.campaignMediaList[0].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                        // self.topVideoPlayButton.isHidden = true
                    }
                    else {
                        //  self.topImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(self.campaignMediaList[0].media!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                        //  self.topVideoPlayButton.isHidden = false
                    }
                    self.photoCommentTextView.text = self.campaignMediaList[0].comment
                    self.viewerTextView.text = self.campaignMediaList[0].comment
                    
                    // self.manageTopHeight((self.campaignMediaList[0].height! as NSString).floatValue, (self.campaignMediaList[0].width! as NSString).floatValue)
                }
                
                
                self.printVersionStatus = (response?.campaignDetailresponse?.campaignDetailresult?.printVersion)!
                self.webVersionStatus = (response?.campaignDetailresponse?.campaignDetailresult?.webVersion)!
                self.watermarkStatus = (response?.campaignDetailresponse?.campaignDetailresult?.watermark)!
                self.webVersionSizes = (response?.campaignDetailresponse?.campaignDetailresult?.webSizes)!
                
                
                //                if response?.campaignDetailresponse?.campaignDetailresult?.camStatus == "0" {
                //                    self.topBar._leftButton2.isHidden = true
                //                }
                //                else {
                //                    self.topBar._leftButton2.isHidden = false
                //                }
                
                
                
                
                self.dataCollectionView.reloadData()
                self.imageScrollerCollectionView.reloadData()
                self.imgViewerCollectionView.reloadData()
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func topVideoPlayClick(_ sender: UIButton) {
        let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOBASEURL, campaignMediaList[sender.tag].media!))
        let player = AVPlayer(url: url! as URL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func viewerVideoPlayClick(_ sender: UIButton) {
        let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOBASEURL, campaignMediaList[sender.tag].media!))
        let player = AVPlayer(url: url! as URL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func photosbuttonClick(_ sender: Any) {
        collectionDataType = "Photo"
        photosButton.backgroundColor = UIColor.black
        videosButton.backgroundColor = UIColor.white
        photosButton.titleLabel?.textColor = UIColor.white
        videosButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        dataCollectionView.reloadData()
    }
    
    @IBAction func videosButtonClick(_ sender: Any) {
        collectionDataType = "Video"
        photosButton.backgroundColor = UIColor.white
        videosButton.backgroundColor = UIColor.black
        photosButton.titleLabel?.textColor = UIColor.black
        videosButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        dataCollectionView.reloadData()
    }
    
    @IBAction func markButton(_ sender: Any) {
        if campaignMediaList.count == 0 {
            
        }
        else {
            if rowsWhichAreChecked.contains(currentImageIndex) {
                rowsWhichAreChecked.remove(currentImageIndex)
            }
            else {
                rowsWhichAreChecked.add(currentImageIndex)
            }
            selectedImages = [UIImage]()
            _ = [CampaignDetailcampaignImages]()
            self.dataCollectionView.reloadData()
        }
        
        
        
    }
    
    @IBAction func imageHistory(_ sender: Any) {
        
        if campaignMediaList.count == 0 {
        } else {
            if campaignMediaList[currentImageIndex].type == "p" {
                navigationController?.pushViewController(PhotoDetailViewController.control, animated: true)
            }
            else {
                navigationController?.pushViewController(VideoDetailViewController.control, animated: true)
            }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        if campaignMediaList.count == 0 {
        } else {
            if campaignMediaList[currentImageIndex].type == "p" || campaignMediaList[currentImageIndex].type == "P" {
                let tempImage = UIImageView()
                tempImage.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[currentImageIndex].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                CompletedCampaignStore.sharedInstance.mediaComment = campaignMediaList[currentImageIndex].comment!
                
                CompletedCampaignStore.sharedInstance.mediaImage = tempImage.image!
                
                CompletedCampaignStore.sharedInstance.imageHeight = (campaignMediaList[currentImageIndex].height! as NSString).floatValue
                CompletedCampaignStore.sharedInstance.imageWidth = (campaignMediaList[currentImageIndex].width! as NSString).floatValue
                
                CompletedCampaignStore.sharedInstance.selectedCategoryId = selectedCampaignCategoryId
                print("CompletedCampaignStore.sharedInstance.selectedCategoryId = Done",CompletedCampaignStore.sharedInstance.selectedCategoryId)
                navigationController?.pushViewController(RevisePhotoViewController.control, animated: true)
            }
        }
    }
    
    @IBAction func crossButtonClick(_ sender: Any) {
        showHide = !showHide
    }
    
    @IBAction func sendPhotoComment(_ sender: Any) {
        
        if self.campaignMediaList.count == 0  {
            SVProgressHUD.showError(withStatus: Constants.NOMEDIA_ERROR)
            return
        }
        
        if photoCommentTextView.text == "" {
            SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
        }
        else {
            CampaignStore.sharedInstance.campaignImageComment(UserStore.sharedInstance.userInfo, CompletedCampaignStore.sharedInstance.CompletedCampaignId, CompletedCampaignStore.sharedInstance.CompletedcampaignImageId, photoCommentTextView.text!, "0") { (response) in
                print(response as Any)
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.campaignMediaList[self.currentImageIndex].comment = self.photoCommentTextView.text!
                    //self.photoCommentTextView.text = ""
                    self.photoCommentTextView.text = self.campaignMediaList[self.currentImageIndex].comment
                    self.viewerTextView.text = self.campaignMediaList[self.currentImageIndex].comment
                    
                    SVProgressHUD.showSuccess(withStatus: "Comment added")
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    @IBAction func selectAllMediaItems(_ sender: Any) {
        print(campaignMediaList.count)
        print(campaignMediaList)
        rowsWhichAreChecked.removeAllObjects()
        
        for index in 0..<campaignMediaList.count {
            rowsWhichAreChecked.add(index as Any)
        }
        
        print(rowsWhichAreChecked.count)
        self.dataCollectionView.reloadData()
        
    }
    
    @IBAction func XbuttonClick(_ sender: Any) {
        imageSelectionType = "normal"
        rowsWhichAreChecked.removeAllObjects()
        self.dataCollectionView.reloadData()
    }
    
    // MARK: - Topbar Delegates
    func backButtonClicked() {
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
 @objc func RightOnebButtonPressed() {
        if campDataType == "original" {
            
        }
        else {
            topShareButton.isHidden = true
            self.photoCommentTextView.text = ""
            self.viewerTextView.text = ""
            campaignMediaList = [CampaignDetailcampaignImages]()
            selectedMediaItems = [CampaignDetailcampaignImages]()
            rowsWhichAreChecked = NSMutableArray()
            campDataType = "original"
//            topBar.leftButton1.setImage(#imageLiteral(resourceName: "OriginalDataPink"), for: .normal)
//            topBar.leftButton2.setImage(#imageLiteral(resourceName: "FinalDataBlack"), for: .normal)
            getCampaignDetails()
        }
    }
    
 @objc func RightbButtonPressedTwo() {
        if campDataType == "final" {
        } else {
            topShareButton.isHidden = false
            self.photoCommentTextView.text = ""
            self.viewerTextView.text = ""
            campaignMediaList = [CampaignDetailcampaignImages]()
            selectedMediaItems = [CampaignDetailcampaignImages]()
            rowsWhichAreChecked = NSMutableArray()
            campDataType = "final"
//            topBar.leftButton1.setImage(#imageLiteral(resourceName: "OriginalDataBlack"), for: .normal)
//            topBar.leftButton2.setImage(#imageLiteral(resourceName: "FinalDataPink"), for: .normal)
            getCampaignDetails()
        }
        
        
        
        // _ = CampaignRatingViewController.showControl(LocalCampaignStore.init(selectedCampaignId))
    }
    
    @IBAction func additionalServicesClick(_ sender: Any) {
        navigationController?.pushViewController(AdditionalServicesViewController.Control(LocalCampaignStore.init(selectedCampaignId)), animated: true)
    }
    
    @IBAction func viewBills(_ sender: Any) {
        CompletedCampaignStore.sharedInstance.CompletedCampaignName = titileLabel.text!
        navigationController?.pushViewController(CampaignInvoiceViewController.control, animated: true)
    }
    
    @IBAction func shareButtonClick(_ sender: Any) {
        if selectedImages.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDIMAGES_NULL)
            return
        }
        DataDownloadStore.sharedInstance.shareImage(selectedImages as NSArray, titileLabel.text!, self) { (response) in
            if response == "1" {
                _ = CampaignRatingViewController.showControl(LocalCampaignStore.init(self.selectedCampaignId))
            }
            else {
            }
        }
    }
    
    @IBAction func downloadButtonClick(_ sender: Any) {
        if selectedImages.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDIMAGES_NULL)
            return
        }
        
        
        //        for  i in 0 ..< self.selectedMediaItems.count {
        //            if selectedMediaItems[i].type == "p" {
        //                let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, selectedMediaItems[i].media!)
        //                let url = URL(string:urlStr)
        //                if let data = try? Data(contentsOf: url!) {
        //                    let image: UIImage = UIImage(data: data)!
        //                    DataDownloadStore.sharedInstance.downlaodImage(image, titileLabel.text!, completion: { (response) in
        //                        if response == "1" {
        //
        //                        }
        //                    })
        //
        //                    // DataDownloadStore.sharedInstance.dow
        //                }
        //            }
        //            else {
        //
        //                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, selectedMediaItems[i].media!)
        //                DataDownloadStore.sharedInstance.downloadVideo(videoImageUrl, "dew", completion: { (response) in
        //                    print(response)
        //                    if response == "1" {
        //
        //                    }
        //                    else {
        //
        //                    }
        //                })
        //            }
        //        }
        
        
        
        DataDownloadStore.sharedInstance.saveImages(selectedImages as NSArray, titileLabel.text!) { (response) in
            if response == "1" {
                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                _ = CampaignRatingViewController.showControl(LocalCampaignStore.init(self.selectedCampaignId))
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.INTERNAL_ERROR)
            }
        }
    }
    
    @IBAction func messageButtonClick(_ sender: Any) {
        LocalMessageStore.sharedInstance.chatCampaignId = CompletedCampaignStore.sharedInstance.CompletedCampaignId
        navigationController?.pushViewController(MessagingViewController.control, animated: true)
    }
    
    @IBAction func presetCancel(_ sender: Any) {
        presetsTableView.setContentOffset(.zero, animated: true)
        presetsTableView.reloadData()
        presetHolderView.isHidden = true
        presetAlphaView.isHidden = true
    }
    
    @IBAction func presetDone(_ sender: Any) {
        presetsTableView.setContentOffset(.zero, animated: true)
        if self.presetActionType == "download" {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        self.presetHolderView.isHidden = true
        self.presetAlphaView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your code here
            var selectedItemsNumbers = [Int]()
            if let selectedRows = self.presetsTableView.indexPathsForSelectedRows {
                for indexPath in selectedRows  {
                    print(selectedRows)
                    selectedItemsNumbers.append(indexPath.row)
                }
            }
            print(selectedItemsNumbers)
            if self.presetActionType == "download" {
                self.self.downloadRequriedFile(selectedItemsNumbers as NSArray)
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.self.shareRequriedFile(selectedItemsNumbers as NSArray)
                }
            }
        }
    }
    
    func showPresets()  {
        presetVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, ",") as! [String]
        print(presetVersions)
        if presetVersions.count == 0 || presetVersions.count == 1 {
            presetsTableView.setContentOffset(.zero, animated: true)
            if self.presetActionType == "download" {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            }
            self.presetHolderView.isHidden = true
            self.presetAlphaView.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // your code here
                
                var selectedItemsNumbers = [Int]()
                selectedItemsNumbers.append(0)
                if self.presetActionType == "download" {
                    self.self.downloadRequriedFile(selectedItemsNumbers as NSArray)
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.self.shareRequriedFile(selectedItemsNumbers as NSArray)
                    }
                }
            }
        }
        else {
            presetHolderView.isHidden = false
            presetAlphaView.isHidden = false
            presetsTableView.allowsMultipleSelectionDuringEditing = true
            presetsTableView.isEditing = !isEditing
            presetsTableView.reloadData()
        }
    }
    
    @IBAction func topDownlaodButton(_ sender: Any) {
        presetsTableView.setContentOffset(.zero, animated: true)
        if selectedImages.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDIMAGES_NULL)
            return
        }
        presetActionType = "download"
        showPresets()
        
        
        
        //        var webVersions = [String]()
        //        webVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, " ") as! [String]
        //        print(webVersions)
        //        UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: webVersions, completion:{  (alert, index) in
        //            if index == 0 {
        //
        //            }
        //            else {
        //                SVProgressHUD.show()
        //                SVProgressHUD.setDefaultMaskType(.clear)
        //                self.downloadRequriedFile(index)
        //            }
        //            print(index)
        //        })
        
        
        
        
        
        //        var tempOptionArray = [String]()
        //
        //
        //           tempOptionArray.append("Print version")
        //
        //            tempOptionArray.append("Web version")
        //
        //            tempOptionArray.append("Watermark")
        //        tempOptionArray.append("All formats")
        //
        //        UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: tempOptionArray, completion:{  (alert, index) in
        //            if index == 1 {
        //                SVProgressHUD.show()
        //                 SVProgressHUD.setDefaultMaskType(.clear)
        //                Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
        //            }
        //            else if index == 2 {
        //                if self.webVersionStatus == "yes" {
        //                   self.showWebVersions()
        //                }
        //                else {
        //                  SVProgressHUD.showError(withStatus: "No web versions found")
        //                }
        //            }
        //            else {
        //                if self.watermarkStatus == "yes" {
        //                    SVProgressHUD.show()
        //                    SVProgressHUD.setDefaultMaskType(.clear)
        //                        self.showWaterMarkVersions()
        //                }
        //                else {
        //                    SVProgressHUD.showError(withStatus: "No watermark found")
        //                }
        //            }
        //        })
    }
    
    
    
    func downloadRequriedFile(_ selectedIndex: NSArray)   {
        print(rowsWhichAreChecked)
        print(campaignMediaList.count)
        print(selectedIndex.count)
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        _ = String()
        
        
        
        for  j in 0 ..< selectedIndex.count {
            for  i in 0 ..< self.rowsWhichAreChecked.count {
                if self.campaignMediaList[rowsWhichAreChecked[i] as! Int].type == "p" {
                    var webVersions = [String]()
                    webVersions = self.campaignMediaList[rowsWhichAreChecked[i] as! Int].WebSizeVersions?.seprateStringWithCharacter(self.campaignMediaList[rowsWhichAreChecked[i] as! Int].WebSizeVersions!, ",") as! [String]
                    
                    let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[selectedIndex[j] as! Int])")
                    _ = "\(String(describing: url!))"
                    if webVersions[j] == "noimage" {
                    }
                    else {
                        // self.self.tempImagesLink.append(string)
                        if let data = try? Data(contentsOf: url!) {
                            let image: UIImage = UIImage(data: data)!
                            image.tuc_saveTo(album: self.campaignTitle + " " + presetVersions[selectedIndex[j] as! Int])
                        }
                    }
                    
                }
                    
                else {
                    let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.campaignMediaList[rowsWhichAreChecked[i] as! Int].media!)
                    self.self.tempVideosLink.append(videoImageUrl)
                }
                
                
            }
            self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
            self.tempVideosLink = self.tempVideosLink.removeDuplicates()
            print(self.tempImagesLink)
        }
        
        // SVProgressHUD.dismiss()
        
        //        self.rowsWhichAreChecked.removeAllObjects()
        //        self.dataCollectionView.reloadData()
        
        
        //   *************   SAVE ONLY VIDEOS ***********
        if self.tempVideosLink.count > 0 {
            self.hitGallery(self.tempVideosLink[0])
        }
        else {
            self.imageSelectionType = "normal"
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
            print("DOWNLOADING COMPLETED")
        }
    }
    
    
    
    func downloadToDevice(_ selectedVersionsArray: NSArray, _ currentIndex: Int)  {
        
    }
    
    
    //    func downloadRequriedFile(_ selectedIndex: NSArray)   {
    //        print(rowsWhichAreChecked)
    //        print(campaignMediaList.count)
    //        print(selectedIndex.count)
    //        self.tempImagesLink = [String]()
    //        self.tempVideosLink = [String]()
    //        self.videoDownloadCounter = 0
    //
    //        // *************   SEPRATE VIDEOS AND IMAGES ***********
    //
    //
    //        for  i in 0 ..< self.rowsWhichAreChecked.count {
    //            var seIndex = Int()
    //            seIndex = rowsWhichAreChecked[i] as! Int
    //
    //
    //            if self.campaignMediaList[seIndex].type == "p" {
    //                var webVersions = [String]()
    //                webVersions = self.campaignMediaList[seIndex].WebSizeVersions?.seprateStringWithCharacter(self.campaignMediaList[seIndex].WebSizeVersions!, ",") as! [String]
    //
    //
    //                print(webVersions)
    //                for  j in 0 ..< selectedIndex.count {
    //                    let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[j])")
    //                    let string = "\(String(describing: url!))"
    //                    if webVersions[j] == "noimage" {
    //                    }
    //                    else {
    //                        self.self.tempImagesLink.append(string)
    //                    }
    //                }
    //            }
    //            else {
    //                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.campaignMediaList[seIndex].media!)
    //                self.self.tempVideosLink.append(videoImageUrl)
    //            }
    //        }
    //
    //        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
    //        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
    //
    //        print(self.tempImagesLink)
    //
    //
    //        // *************   SAVE ONLY IMAGES *********** //
    //        for  i in 0 ..< self.tempImagesLink.count {
    //            let url = URL(string:self.tempImagesLink[i])
    //            if let data = try? Data(contentsOf: url!) {
    //                let image: UIImage = UIImage(data: data)!
    //                DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
    //                    if response == "1" {
    //                        if i == self.tempImagesLink.count - 1 {
    //                            if self.tempVideosLink.count == 0 {
    //                                SVProgressHUD.dismiss()
    //                                print("DOWNLOADING COMPLETED")
    //                                self.rowsWhichAreChecked.removeAllObjects()
    //                                self.dataCollectionView.reloadData()
    //                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
    //                            }
    //                            else {
    //
    //                            }
    //                        }
    //                    }
    //                })
    //            }
    //        }
    //
    //
    //
    //
    //
    //        // *************   SAVE ONLY VIDEOS ***********
    //        if self.tempVideosLink.count > 0 {
    //            self.hitGallery(self.tempVideosLink[0])
    //        }
    //        else {
    //            self.rowsWhichAreChecked.removeAllObjects()
    //            self.dataCollectionView.reloadData()
    //            SVProgressHUD.dismiss()
    //        }
    //
    //    }
    
    
    func saveDataToPhone(_ imageArray : [String], _ videoArray : [String])  {
        
    }
    
    
    
    
    
    
    //holdView: shareButton
    func showWebVersions()  {
        SVProgressHUD.dismiss()
        var webVersions = [String]()
        webVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, " ") as! [String] 
        print(webVersions)
        UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: webVersions, holdView: shareButton, completion:{  (alert, index) in
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            //self.setupWebPhots(index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupWebPhots(index)
            }
        })
    }
    
    func setupWebPhots(_ selectedVersion : Int)  {
        print(rowsWhichAreChecked)
        if selectedVersion == 0 {
            SVProgressHUD.dismiss()
            return
        }
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        
        // *************   SEPRATE VIDEOS AND IMAGES ***********
        for i in 0 ..< self.selectedMediaItems.count {
            if self.selectedMediaItems[i].type == "p" {
                var webVersions = [String]()
                webVersions = self.selectedMediaItems[i].WebSizeVersions?.seprateStringWithCharacter(self.selectedMediaItems[i].WebSizeVersions!, ",") as! [String]
                print(webVersions)
                let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[selectedVersion - 1])")
                let string = "\(String(describing: url!))"
                
                if selectedVersion <= webVersions.count {
                    self.self.tempImagesLink.append(string)
                }
                else {
                }
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                self.self.tempVideosLink.append(videoImageUrl)
            }
        }
        
        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
        
        
        // *************   SAVE ONLY IMAGES *********** //
        for  i in 0 ..< self.tempImagesLink.count {
            let url = URL(string:self.tempImagesLink[i])
            if let data = try? Data(contentsOf: url!) {
                let image: UIImage = UIImage(data: data)!
                DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
                    if response == "1" {
                        if i == self.tempImagesLink.count - 1 {
                            if self.tempVideosLink.count == 0 {
                                SVProgressHUD.dismiss()
                                print("DOWNLOADING COMPLETED")
                                self.rowsWhichAreChecked.removeAllObjects()
                                self.dataCollectionView.reloadData()
                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                            }
                            else {
                                
                            }
                        }
                    }
                })
            }
        }
        
        
        
        
        
        // *************   SAVE ONLY VIDEOS ***********
        if self.tempVideosLink.count > 0 {
            self.hitGallery(self.tempVideosLink[0])
        }
        else {
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    
    ///// SETUP WATERMARK FOR DIFFERENT SIZES
    // holdView: shareButton
    func showWaterMarkVersions()  {
        SVProgressHUD.dismiss()
        var webVersions = [String]()
        webVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, " ") as! [String]
        print(webVersions)
        UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: webVersions, holdView: shareButton, completion:{  (alert, index) in
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            //self.setupWebPhots(index)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setupWaterMarkPhots(index)
            }
        })
    }
    
    func setupWaterMarkPhots(_ selectedVersion : Int)  {
        print(rowsWhichAreChecked)
        if selectedVersion == 0 {
            SVProgressHUD.dismiss()
            return
        }
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        
        // *************   SEPRATE VIDEOS AND IMAGES ***********
        for  i in 0 ..< self.selectedMediaItems.count {
            if self.selectedMediaItems[i].type == "p" {
                var webVersions = [String]()
                webVersions = self.selectedMediaItems[i].waterMark?.seprateStringWithCharacter(self.selectedMediaItems[i].waterMark!, ",") as! [String]
                print(webVersions)
                let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[selectedVersion - 1])")
                let string = "\(String(describing: url!))"
                
                if selectedVersion <= webVersions.count {
                    self.self.tempImagesLink.append(string)
                }
                else {
                    
                }
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                self.self.tempVideosLink.append(videoImageUrl)
            }
        }
        
        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
        
        
        // *************   SAVE ONLY IMAGES *********** //
        for  i in 0 ..< self.tempImagesLink.count {
            let url = URL(string:self.tempImagesLink[i])
            if let data = try? Data(contentsOf: url!) {
                let image: UIImage = UIImage(data: data)!
                DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
                    if response == "1" {
                        if i == self.tempImagesLink.count - 1 {
                            if self.tempVideosLink.count == 0 {
                                SVProgressHUD.dismiss()
                                print("DOWNLOADING COMPLETED")
                                self.rowsWhichAreChecked.removeAllObjects()
                                self.dataCollectionView.reloadData()
                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                            }
                            else {
                                
                            }
                        }
                    }
                })
            }
        }
        
        
        
        
        
        // *************   SAVE ONLY VIDEOS ***********
        if self.tempVideosLink.count > 0 {
            self.hitGallery(self.tempVideosLink[0])
        }
        else {
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    
    // SIMPLE DOWNLOAD WATERMARK
    
    func downloadWatermarks() {
        selectedImages = [UIImage]()
        //////////
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        
        // *************   SEPRATE VIDEOS AND IMAGES    ***********
        for  i in 0 ..< self.selectedMediaItems.count {
            
            if self.selectedMediaItems[i].type == "p" {
                let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, self.selectedMediaItems[i].waterMark!)
                self.self.tempImagesLink.append(urlStr)
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                self.self.tempVideosLink.append(videoImageUrl)
            }
        }
        
        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
        
        
        // *************   SAVE ONLY IMAGES *********** //
        for  i in 0 ..< self.tempImagesLink.count {
            let url = URL(string:self.tempImagesLink[i])
            if let data = try? Data(contentsOf: url!) {
                let image: UIImage = UIImage(data: data)!
                DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
                    if response == "1" {
                        if i == self.tempImagesLink.count - 1 {
                            if self.tempVideosLink.count == 0 {
                                SVProgressHUD.dismiss()
                                print("DOWNLOADING COMPLETED")
                                self.rowsWhichAreChecked.removeAllObjects()
                                self.dataCollectionView.reloadData()
                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                            }
                            else {
                                
                            }
                        }
                    }
                })
            }
        }
        
        
        
        
        
        // *************   SAVE ONLY VIDEOS ***********
        if self.tempVideosLink.count > 0 {
            self.hitGallery(self.tempVideosLink[0])
        }
        else {
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func updateTimer() {
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        
        //************* SEPRATE VIDEOS AND IMAGES ***********
        
        for  i in 0 ..< self.selectedMediaItems.count {
            if self.selectedMediaItems[i].type == "p" {
                let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, self.selectedMediaItems[i].media!)
                self.self.tempImagesLink.append(urlStr)
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                self.self.tempVideosLink.append(videoImageUrl)
            }
        }
        
        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
        
        // *************   SAVE ONLY IMAGES   *********** //
        
        for  i in 0 ..< self.tempImagesLink.count {
            let url = URL(string: self.tempImagesLink[i])
            if let data = try? Data(contentsOf: url!) {
                let image: UIImage = UIImage(data: data)!
                DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
                    if response == "1" {
                        if i == self.tempImagesLink.count - 1 {
                            if self.tempVideosLink.count == 0 {
                                SVProgressHUD.dismiss()
                                print("DOWNLOADING COMPLETED")
                                self.rowsWhichAreChecked.removeAllObjects()
                                self.dataCollectionView.reloadData()
                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                            }
                            else {
                            }
                        }
                    }
                })
            }
        }
        
        // *************   SAVE ONLY VIDEOS ***********
        if self.tempVideosLink.count > 0 {
            self.hitGallery(self.tempVideosLink[0])
        }
        else {
            print("DOWNLOADING COMPLETED 1111111")
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func hitGallery(_ urlStr: String)  {
        _ = urlStr
        // DispatchQueue.global(qos: .background).async {
        if let url = URL(string: urlStr),
            let urlData = NSData(contentsOf: url) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(documentsPath)/tempFile.MOV"
            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { completed, error in
                    if completed {
                        if self.videoDownloadCounter == self.tempVideosLink.count - 1 {
                            print("DOWNLOADING COMPLETED")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.imageSelectionType = "normal"
                                self.rowsWhichAreChecked.removeAllObjects()
                                self.dataCollectionView.reloadData()
                                SVProgressHUD.dismiss()
                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
                            }
                        }
                        else {
                            self.videoDownloadCounter = self.videoDownloadCounter + 1
                            self.hitGallery(self.tempVideosLink[self.videoDownloadCounter])
                        }
                        
                    }
                }
            }
        }
        //}
    }
    
    @IBAction func topShareButton(_ sender: Any) {
        presetsTableView.setContentOffset(.zero, animated: true)
        if self.selectedImages.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDIMAGES_NULL)
            return
        }
        UIAlertController.showAlert("Choose", message: "Select sharing method", buttons: ["Share via email", "Choose from phone"]) { (alert, selectedInt) in
            print(selectedInt)
            
            if selectedInt == 0 {
                self.showEmailSharingOptions()
            }
            else {
                self.getPhotoSharingLink()
            }
        }
    }
    
    func getPhotoSharingLink() {
        var tempMediaFilesArray = [String]()
        for index in 0..<rowsWhichAreChecked.count {
            tempMediaFilesArray.append(campaignMediaList[index].internalIdentifier!)
        }
        let characterArray = tempMediaFilesArray.joined(separator: ",")
        tempMediaFilesArray.removeAll()
        
        
        CampaignStore.sharedInstance.getMediaSharingLink(selectedCampaignId, userRoleId, String(characterArray)) { (resposne) in
            print(resposne as Any)
            self.imageSelectionType = "normal"
            let responseData = resposne?["response"] as! NSDictionary
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            
            if responseData["status"] as! String == "1" {
                
                print(responseData["link"] as Any)
                
                
                
                let htmlData = responseData["link"] as! String
                var descriptionText: NSAttributedString? = nil
                if let anEncoding = htmlData.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue)) {
                    descriptionText = try? NSAttributedString(data: anEncoding, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html.rawValue], documentAttributes: nil)
                }
                
                let items = [descriptionText]
                
                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                
                activityVC.setValue(self.campaignTitle, forKey: "subject")
                
                //activityVC.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToWeibo, UIActivityType.message, UIActivityType.mail, UIActivityType.copyToPasteboard, UIActivityType.postToFlickr, UIActivityType.postToVimeo, UIActivityType.markupAsPDF ]
                
                
                activityVC.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if !completed {
                        // User canceled
                        
                        //return
                    }
                    
                    // User completed activity
                }
                
                self.present(activityVC, animated: true, completion: nil)
                
                
                
            } else {
                SVProgressHUD.showError(withStatus: "Sorry something went wrong")
            }
            
        }
        
        
    }
    
    func showEmailSharingOptions()  {
        let alertController = UIAlertController(title: "Enter Emails", message: "Enter emails with whom you want to share media(comma sperated)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "abc@gmail.com, xyz@gmail.com"
        }
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert -> Void in
            var emails = String()
            emails = (alertController.textFields![0] as UITextField).text!
            if emails.length == 0 {
                UIAlertController.showAlert("Alert!", message: "Please enter email", buttons: ["OK"], completion: { (UIAlertController, Int) in
                    
                })
            }
            else {
                self.shareMediaViaServer(emails)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func shareMediaViaServer(_ emails: String)  {
        
        var tempMediaFilesArray = [String]()
        
        
        for index in 0..<rowsWhichAreChecked.count {
            
            tempMediaFilesArray.append(campaignMediaList[index].internalIdentifier!)
        }
        
        
        print(selectedCampaignId)
        print(userRoleId)
        print(tempMediaFilesArray)
        let characterArray = tempMediaFilesArray.joined(separator: ",")
        tempMediaFilesArray.removeAll()
        
        
        CampaignStore.sharedInstance.shareMediaViaServer(selectedCampaignId, userRoleId, String(characterArray), emails) { (resposne) in
            print(resposne as Any)
            self.imageSelectionType = "normal"
            let responseData = resposne?["response"] as! NSDictionary
            self.rowsWhichAreChecked.removeAllObjects()
            self.dataCollectionView.reloadData()
            
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Media shared successfully")
                
                
            } else {
                SVProgressHUD.showError(withStatus: "Sorry something went wrong")
            }
            
        }
    }
    
    
    func shareRequriedFile(_ selectedIndex: NSArray)   {
        print(rowsWhichAreChecked)
        
        
        self.tempImagesLink = [String]()
        self.tempVideosLink = [String]()
        self.videoDownloadCounter = 0
        
        // *************   SEPRATE VIDEOS AND IMAGES ***********
        for  i in 0 ..< self.rowsWhichAreChecked.count {
            var seIndex = Int()
            seIndex = rowsWhichAreChecked[i] as! Int
            
            if self.campaignMediaList[seIndex].type == "p" {
                var webVersions = [String]()
                
                webVersions = self.campaignMediaList[seIndex].WebSizeVersions?.seprateStringWithCharacter(self.campaignMediaList[seIndex].WebSizeVersions!, ",") as! [String]
                print(webVersions)
                
                for  j in 0 ..< selectedIndex.count {
                    
                    let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[j])")
                    let string = "\(String(describing: url!))"
                    if webVersions[j] == "noimage" {
                        
                    }
                    else {
                        self.self.tempImagesLink.append(string)
                    }
                    
                }
                
                
                
                
                //
                //
                //                let url = URL(string: "\(APIs.KIMAGEBASEURL)\(webVersions[selectedIndex - 1])")
                //                let string = "\(String(describing: url!))"
                //                if webVersions[selectedIndex - 1] == "noimage" {
                //
                //                }
                //                else {
                //                    self.self.tempImagesLink.append(string)
                //                }
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.campaignMediaList[seIndex].media!)
                self.self.tempImagesLink.append(videoImageUrl)
            }
        }
        //  self.titileLabel.text
        
        //        Hi (User Name)
        //
        //        (Shared of link user name) has shared media with you for (campaign name)
        //            Please click this link to download the media.
        //
        //        Please contact (Shared of link user name) if you believe this media was not meant for you.
        //
        //        For any technical support or if you have any questions relating to U Snap please email social@usnap.com.au
        //
        //        Happy snapping
        //        U Snap PTY LTD
        
        
        
        
        
        self.self.tempImagesLink = self.tempImagesLink.removeDuplicates()
        self.tempVideosLink = self.tempVideosLink.removeDuplicates()
        
        self.tagLine = String(format: "Hi \n%@ %@ %@. %@ \nPlease contact %@ if you believe this media was not meant for you.\n For any technical support or if you have any questions relating to U Snap please email social@usnap.com.au \n Happy snapping \n U Snap PTY LTD", self.loginUserName, "Has shared media with you for", self.campaignTitle,  "Please click this link to download the media.", self.loginUserName )
        
        
        
        
        
        
        DataDownloadStore.sharedInstance.shareImageWithSubject(tempImagesLink as NSArray, self.self.campaignTitle, self.tagLine, self.loginUserName, self.campaignTitle, self) { (response) in
            if response == "1" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.rowsWhichAreChecked.removeAllObjects()
                    self.dataCollectionView.reloadData()
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "Image shared successfully")
                }
            }
            else {
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //        // *************   SAVE ONLY IMAGES *********** //
        //        for  i in 0 ..< self.tempImagesLink.count {
        //            let url = URL(string:self.tempImagesLink[i])
        //            if let data = try? Data(contentsOf: url!) {
        //                let image: UIImage = UIImage(data: data)!
        //                DataDownloadStore.sharedInstance.downlaodImage(image, self.titileLabel.text!, completion: { (response) in
        //                    if response == "1" {
        //                        if i == self.tempImagesLink.count - 1 {
        //                            if self.tempVideosLink.count == 0 {
        //                                SVProgressHUD.dismiss()
        //                                print("DOWNLOADING COMPLETED")
        //                                self.rowsWhichAreChecked.removeAllObjects()
        //                                self.dataCollectionView.reloadData()
        //                                SVProgressHUD.showSuccess(withStatus: Constants.Images_Saved)
        //                            }
        //                            else {
        //
        //                            }
        //                        }
        //                    }
        //                })
        //            }
        //        }
        //
        //
        //
        //
        //
        //        // *************   SAVE ONLY VIDEOS ***********
        //        if self.tempVideosLink.count > 0 {
        //            self.hitGallery(self.tempVideosLink[0])
        //        }
        //        else {
        //            self.rowsWhichAreChecked.removeAllObjects()
        //            self.dataCollectionView.reloadData()
        //            SVProgressHUD.dismiss()
        //        }
        
        
        
        
    }
    
    
    
    
    func setAllFormatsForSharing()  {
        self.tagLine = String(format: "%@ %@ %@ %@", self.loginUserName, "Has shared all formats of", self.self.campaignTitle, "with you. Please click this link to download your media.")
        
        
        // ********************** Setup data for print versions **********************
        var allLinks = [String]()
        
        if self.printVersionStatus == "yes" {
            allLinks.append("Print Versions\n")
            // *************   SEPRATE VIDEOS AND IMAGES ***********
            for  i in 0 ..< self.selectedMediaItems.count {
                if self.selectedMediaItems[i].type == "p" {
                    let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, self.selectedMediaItems[i].media!)
                    allLinks.append(urlStr)
                }
                else {
                    let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                    allLinks.append(videoImageUrl)
                }
            }
        }
        
        
        
        
        // ********************** Setup data for Web versions **********************
        
        if self.webVersionStatus == "yes" {
            allLinks.append("\nWeb Versions\n")
            var webVersions = [String]()
            webVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, " ") as! [String]
            print(webVersions)
            
            
            for  j in 0 ..< webVersions.count {
                allLinks.append(String(format: "\n%@ %@ \n", "Web version size: ", webVersions[j]))
                for  i in 0 ..< self.selectedMediaItems.count {
                    if self.selectedMediaItems[i].type == "p" {
                        
                        var webVersions = [String]()
                        webVersions = self.selectedMediaItems[i].WebSizeVersions?.seprateStringWithCharacter(self.selectedMediaItems[i].WebSizeVersions!, ",") as! [String]
                        print(webVersions)
                        print(self.selectedMediaItems)
                        if   j <= webVersions.count {
                            let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, webVersions[j] as String)
                            allLinks.append(urlStr)
                        }
                        else {
                            
                        }
                        
                    }
                    else {
                        let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                        allLinks.append(videoImageUrl)
                    }
                    
                }
                
            }
        }
        
        
        
        // ********************** Setup data for watermark images **********************
        
        
        if self.watermarkStatus == "yes" {
            allLinks.append("\nWatermark Images\n")
            for  i in 0 ..< self.selectedMediaItems.count {
                if self.selectedMediaItems[i].type == "p" {
                    let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, self.selectedMediaItems[i].waterMark!)
                    allLinks.append(urlStr)
                }
                else {
                    let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                    allLinks.append(videoImageUrl)
                }
            }
        }
        
        allLinks = allLinks.removeDuplicates()
        print(allLinks)
        
        DataDownloadStore.sharedInstance.shareImageWithSubject(allLinks as NSArray, self.self.campaignTitle, self.tagLine, self.loginUserName, self.campaignTitle, self) { (response) in
            if response == "1" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.rowsWhichAreChecked.removeAllObjects()
                    self.dataCollectionView.reloadData()
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "Image shared successfully")
                }
            }
            else {
            }
        }
    }
    //holdView: gallaryButton
    func showWebVersionsForSharing()  {
        var webVersions = [String]()
        self.tagLine = String(format: "%@ %@", self.loginUserName, " Has shared web version images with you. Please click this link to download your media. ")
        webVersions = webVersionSizes.seprateStringWithCharacter(webVersionSizes, " ") as! [String]
        print(webVersions)
        UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: webVersions, holdView: shareButton, completion:{  (alert, index) in
            if index == 0 {
                
            }
            else {
                var allLinks = [String]()
                // *************   SEPRATE VIDEOS AND IMAGES ***********
                for  i in 0 ..< self.selectedMediaItems.count {
                    if self.selectedMediaItems[i].type == "p" {
                        
                        var webVersions = [String]()
                        webVersions = self.selectedMediaItems[i].WebSizeVersions?.seprateStringWithCharacter(self.selectedMediaItems[i].WebSizeVersions!, ",") as! [String]
                        print(webVersions)
                        print(self.selectedMediaItems)
                        if index <= webVersions.count {
                            let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, webVersions[index - 1] as String)
                            allLinks.append(urlStr)
                        }
                        else {
                            
                        }
                        
                    }
                    else {
                        let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, self.selectedMediaItems[i].media!)
                        allLinks.append(videoImageUrl)
                    }
                    
                }
                allLinks = allLinks.removeDuplicates()
                
                DataDownloadStore.sharedInstance.shareImageWithSubject(allLinks as NSArray, self.self.campaignTitle, self.tagLine, self.loginUserName, self.campaignTitle, self) { (response) in
                    if response == "1" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.rowsWhichAreChecked.removeAllObjects()
                            self.dataCollectionView.reloadData()
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showSuccess(withStatus: "Image shared successfully")
                        }
                    }
                    else {
                    }
                }
            }
        })
    }
    
    @IBAction func dismissViewer(_ sender: Any) {
        AppUtility.lockOrientation(.portrait)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.imgViewerHolder.isHidden = true
        self.viewerCommentHolder.isHidden = true
    }
    
    @IBAction func downloadDeleteClick(_ sender: Any) {
        if self.campaignMediaList.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
        }
        else {
            self.startDownlaoding()
        }
    }
    
    func startDownlaoding()  {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        
        for  i in 0 ..< self.campaignMediaList.count {
            if campaignMediaList[i].type == "p" {
                let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, campaignMediaList[i].media!)
                let url = URL(string:urlStr)
                if let data = try? Data(contentsOf: url!) {
                    let image: UIImage = UIImage(data: data)!
                    DataDownloadStore.sharedInstance.downlaodImage(image, self.campaignTitle, completion: { (response) in
                        if response == "1" {
                            if i == self.campaignMediaList.count - 1 {
                                DispatchQueue.main.async {
                                    // self.deleMediaAfterDownload()
                                }
                            }
                        }
                    })
                }
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, campaignMediaList[i].media!)
                DataDownloadStore.sharedInstance.downloadVideo(videoImageUrl, "dew", completion: { (response) in
                    if response == "1" {
                        if i == self.campaignMediaList.count - 1 {
                            DispatchQueue.main.async {
                                //  self.deleMediaAfterDownload()
                            }
                        }
                    }
                    else {
                    }
                })
            }
        }
    }
    
    func deleMediaAfterDownload()  {
        CampaignStore.sharedInstance.deleteAfterDownload(selectedCampaignId) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Media files are downloaded to gallery and deleted from the server")
                self.performSegueToReturnBack()
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func viewerSendButton(_ sender: Any) {
        if viewerTextView.text == "" {
            SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
        }
        else {
            CampaignStore.sharedInstance.campaignImageComment(UserStore.sharedInstance.userInfo, CompletedCampaignStore.sharedInstance.CompletedCampaignId, self.campaignMediaList[viewerCurrentImageIndex].internalIdentifier!, viewerTextView.text!, "0") { (response) in
                print(response as Any)
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.campaignMediaList[self.currentImageIndex].comment = self.photoCommentTextView.text!
                    self.campaignMediaList[self.viewerCurrentImageIndex].comment = self.viewerTextView.text!
                    SVProgressHUD.showSuccess(withStatus: "Comment added")
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
        
    }
    
    // MARK: - Table view Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presetVersions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = presetVersions[indexPath.row]
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = colorView
        
        return cell
    }
    
    
    // MARK: - Collection view Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return campaignMediaList.count
        }
            
        else if collectionView.tag == 3{
            return campaignMediaList.count
        }
        else{
            return campaignMediaList.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignDetailImageCell", for: indexPath as IndexPath) as! CampaignDetailImageCell
            if campaignMediaList[indexPath.row].type == "p" {
                cell.campaignDetailImageView.sd_setShowActivityIndicatorView(true)
                cell.campaignDetailImageView.sd_setIndicatorStyle(.gray)
                cell.campaignDetailImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                cell.playButton.isHidden = true
            }
            else {
                cell.campaignDetailImageView.sd_setShowActivityIndicatorView(true)
                cell.campaignDetailImageView.sd_setIndicatorStyle(.gray)
                cell.campaignDetailImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(campaignMediaList[indexPath.row].thumbnail!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                cell.playButton.isHidden = false
            }
            cell.campaignDetailImageView.actionBlock {
                self.imgViewerHolder.isHidden = false
                let indexPath = IndexPath(row: self.currentImageIndex, section: 0)
                
                self.viewerCurrentImageIndex = self.currentImageIndex
                self.imgViewerCollectionView.reloadData()
                self.imgViewerCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: false)
                
                self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
                self.viewerTextView.text = self.campaignMediaList[indexPath.row].comment
                
                AppUtility.lockOrientation(.all)
            }
            
            cell.playButton.addTarget(self, action: #selector(topVideoPlayClick), for: .touchUpInside)
            cell.playButton.tag = indexPath.row
            
            
            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of
            
            // self.manageTopHeight((self.campaignMediaList[self.currentImageIndex].height! as NSString).floatValue, (self.campaignMediaList[self.currentImageIndex].width! as NSString).floatValue)
            // }
            
            return cell
        }
            
            // Image Viewer
        else  if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgViewCollectionViewCell", for: indexPath) as? ImgViewCollectionViewCell
            cell?.imgScroll.autoresizesSubviews = true
            cell?.imgScroll.isMultipleTouchEnabled = true
            cell?.imgScroll.maximumZoomScale = 4.0
            cell?.imgScroll.minimumZoomScale = 1.0
            cell?.imgScroll.clipsToBounds = true
            cell?.imgScroll.delegate = self
            cell?.imgScroll.zoomScale = 1.0
            
            
            
            if campaignMediaList[indexPath.row].type == "p" {
                cell?.imgView.sd_setShowActivityIndicatorView(true)
                cell?.imgView.sd_setIndicatorStyle(.gray)
                cell?.imgView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                cell?.viewerPlayButton.isHidden = true
            }
            else {
                cell?.imgView.sd_setShowActivityIndicatorView(true)
                cell?.imgView.sd_setIndicatorStyle(.gray)
                cell?.imgView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(campaignMediaList[indexPath.row].thumbnail!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                cell?.viewerPlayButton.isHidden = true
            }
            
            cell?.viewerPlayButton.addTarget(self, action: #selector(viewerVideoPlayClick), for: .touchUpInside)
            cell?.viewerPlayButton.tag = indexPath.row
            
            cell?.imgView.actionBlock {
                self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
                self.viewerTextView.text = self.campaignMediaList[indexPath.row].comment
                if self.viewerCommentHolder.isHidden == true {
                    self.viewerCommentHolder.isHidden = false
                }
                else {
                    self.viewerCommentHolder.isHidden = true
                }
                
            }
            
            if let aCell = cell {
                return aCell
            }
            
            
            return UICollectionViewCell()
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignDetail", for: indexPath as IndexPath) as! CampaignDetailCollectionViewCell
            cell.countLabel.text = String(format: "%d", indexPath.row + 1)
            if campaignMediaList[indexPath.row].type == "p" {
                cell.topImageView.sd_setShowActivityIndicatorView(true)
                cell.topImageView.sd_setIndicatorStyle(.gray)
                cell.topImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                cell.playButton.isHidden = true
            }
            else {
                cell.topImageView.sd_setShowActivityIndicatorView(true)
                cell.topImageView.sd_setIndicatorStyle(.gray)
                cell.topImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(campaignMediaList[indexPath.row].thumbnail!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                cell.playButton.isHidden = false
            }
            
            
            
            if rowsWhichAreChecked.contains(indexPath.row) {
                cell.checkBoxImg.image = #imageLiteral(resourceName: "RadioOn")
                selectedImages.append(cell.topImageView.image!)
                cell.topImageView.addBorderlayerThick(solidPinkBorderColor)
                print(indexPath.row)
                selectedMediaItems.append(campaignMediaList[indexPath.row])
                
            }
            else {
                cell.checkBoxImg.image = #imageLiteral(resourceName: "RadioOff")
                cell.topImageView.addBorderlayerThick(UIColor.clear)
            }
            
            if rowsWhichAreChecked.count != 0 {
                holderViewHeightCons.constant = 30
                selectedCountLabel.text = "eklneknnn"
                selectedCountLabel.text = String(format: "%d %@", rowsWhichAreChecked.count, "Selected")
            }
            else {
                holderViewHeightCons.constant = 0
            }
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapImage(_:)))
            cell.topImageView.tag = indexPath.row
            cell.topImageView.addGestureRecognizer(longGesture)
            cell.numberOfRevisions.text = "\("No. of Revisions - ")\(campaignMediaList[indexPath.row].noOfRevision!)"
            cell.lastRevisionDate.text = "\(" Last Revision - ")\(campaignMediaList[indexPath.row].lastRevision!)"
            
            
            return cell
        }
    }
    
    func manageTopHeight(_ serverHeight : Float, _ serverWidth : Float)   {
        var backendHeight = Float()
        var backendWidth = Float()
        var screenWidth = Float()
        var widthRatio = Float()
        backendHeight = serverHeight
        backendWidth = serverWidth
        screenWidth = Float(self.view.frame.size.width)
        widthRatio = screenWidth / backendWidth
        //        self.topImageHeightConst.constant = 0
        self.topImageHeightConst.constant = CGFloat(backendHeight * widthRatio)
    }
    
    
    
    func getTopHeight(_ serverHeight : Float, _ serverWidth : Float) -> CGFloat   {
        var backendHeight = Float()
        var backendWidth = Float()
        var screenWidth = Float()
        var widthRatio = Float()
        backendHeight = serverHeight
        backendWidth = serverWidth
        screenWidth = Float(self.view.frame.size.width)
        widthRatio = screenWidth / backendWidth
        //        topImageHeightConst.constant = 0
        return CGFloat(backendHeight * widthRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView.tag == 1 {
            
            let width  = self.view.frame.size.width
            let height  = self.view.frame.size.width
            
            // let height = self.getTopHeight((self.campaignMediaList[self.currentImageIndex].height! as NSString).floatValue, (self.campaignMediaList[self.currentImageIndex].width! as NSString).floatValue)
            return CGSize(width: width, height: height)
            
        }
        if collectionView == imgViewerCollectionView {
            let width  = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            return CGSize(width: width, height: height)
        }
        
        let width  = dataCollectionView.frame.size.height
        let height = dataCollectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 {
            return 0
        }
        
        return 0.5
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = imageScrollerCollectionView?.contentOffset;
        let width  = imageScrollerCollectionView?.bounds.size.width;
        
        let index     = round(offset!.x / width!);
        let newOffset = CGPoint(x: index * size.width, y: offset!.y)
        
        imageScrollerCollectionView?.setContentOffset(newOffset, animated: false)
        
        
        coordinator.animate(alongsideTransition: { (context) in
            self.imageScrollerCollectionView?.reloadData()
            self.imageScrollerCollectionView?.setContentOffset(newOffset, animated: false)
        }, completion: nil)
        
        
        
        let offsetViewer = imgViewerCollectionView?.contentOffset;
        let widthViewer  = imgViewerCollectionView?.bounds.size.width;
        
        let indexViewer     = round(offsetViewer!.x / widthViewer!);
        let newOffsetViewer = CGPoint(x: indexViewer * size.width, y: offsetViewer!.y)
        
        imgViewerCollectionView?.setContentOffset(newOffsetViewer, animated: false)
        
        
        coordinator.animate(alongsideTransition: { (context) in
            self.imgViewerCollectionView?.reloadData()
            self.imgViewerCollectionView?.setContentOffset(newOffsetViewer, animated: false)
        }, completion: nil)
        convertOrientation()
    }
    
    func convertOrientation()  {
        if UIDevice.current.orientation.isLandscape {
            bottomTabImage.image = #imageLiteral(resourceName: "bootom_Landscape")
        } else {
            bottomTabImage.image = #imageLiteral(resourceName: "bootom")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageScrollerCollectionView.collectionViewLayout.invalidateLayout()
        imgViewerCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for v: UIView in scrollView.subviews {
            if (v is UIImageView) {
                return v
            }
        }
        return nil
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
    
    @objc func longTapImage(_ sender: UIGestureRecognizer){
        imageSelectionType = "longPress"
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            if rowsWhichAreChecked.contains(sender.view?.tag as Any) {
                rowsWhichAreChecked.remove(sender.view?.tag as Any)
            }
            else {
                rowsWhichAreChecked.add(sender.view?.tag as Any)
            }
            
            self.dataCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            return
        }
        
        if imageSelectionType == "longPress" {
            if rowsWhichAreChecked.contains(indexPath.row as Any) {
                rowsWhichAreChecked.remove(indexPath.row as Any)
            }
            else {
                rowsWhichAreChecked.add(indexPath.row as Any)
            }
            
            self.dataCollectionView.reloadData()
        }
        else {
            if campaignMediaList[indexPath.row].type == "p" || campaignMediaList[indexPath.row].type == "P"{
                // self.manageTopHeight((self.campaignMediaList[indexPath.row].height! as NSString).floatValue, (self.campaignMediaList[indexPath.row].width! as NSString).floatValue)
            }
            else
            {
            }
            self.currentImageIndex = indexPath.row
            photoCommentTextView.text = ""
            CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[indexPath.row].internalIdentifier!
            imageScrollerCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: true)
            
            // self.manageTopHeight((self.campaignMediaList[indexPath.row].height! as NSString).floatValue, (self.campaignMediaList[indexPath.row].width! as NSString).floatValue)
            imgViewerCollectionView.reloadItems(at: [indexPath])
            self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
            self.viewerTextView.text = self.campaignMediaList[indexPath.row].comment
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if imgViewerCollectionView.isHidden == false {
            if scrollView == imgViewerCollectionView {
                var visibleRect = CGRect()
                visibleRect.origin = imgViewerCollectionView.contentOffset
                visibleRect.size = imgViewerCollectionView.bounds.size
                
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                
                guard let indexPath = imgViewerCollectionView.indexPathForItem(at: visiblePoint) else { return }
                if indexPath.row == 0 {
                }
                else {
                    let backIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
                    imgViewerCollectionView.reloadItems(at: [backIndexPath])
                }
            }
        }
        
        var visibleRect = CGRect()
        var visibleRectViewer = CGRect()
        if (scrollView.viewWithTag(1) != nil) {
            visibleRect.origin = imageScrollerCollectionView.contentOffset
            visibleRect.size = imageScrollerCollectionView.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            guard let indexPath = imageScrollerCollectionView.indexPathForItem(at: visiblePoint) else { return }
            
            self.currentImageIndex = indexPath.row
            CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[indexPath.row].internalIdentifier!
            self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
            
            
            visibleRectViewer.origin = imgViewerCollectionView.contentOffset
            visibleRectViewer.size = imgViewerCollectionView.bounds.size
            
            let visiblePointViewer = CGPoint(x: visibleRectViewer.midX, y: visibleRectViewer.midY)
            guard let indexPathViewer = imgViewerCollectionView.indexPathForItem(at: visiblePointViewer) else { return }
            self.viewerTextView.text = self.campaignMediaList[indexPathViewer.row].comment
            viewerCurrentImageIndex = indexPathViewer.row
            self.viewerTextView.text = self.campaignMediaList[indexPathViewer.row].comment
            imageScrollerCollectionView.reloadItems(at: [indexPath])
        }
        else {
            visibleRect.origin = imgViewerCollectionView.contentOffset
            visibleRect.size = imgViewerCollectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = imgViewerCollectionView.indexPathForItem(at: visiblePoint) else { return }
            
            
            //   [imgViewerCollectionView reloadItemsAtIndexPaths:[changedIndexes ctassetsPickerIndexPathsFromIndexesWithSection:0] ];
            
            self.currentImageIndex = indexPath.row
            CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[indexPath.row].internalIdentifier!
            viewerCurrentImageIndex = indexPath.row
            self.viewerTextView.text = self.campaignMediaList[indexPath.row].comment
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


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
