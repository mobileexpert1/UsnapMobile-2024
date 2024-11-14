//
//  CampaignDetailViewController.swift
//  Usnap
//
//  Created by CSPC141 on 12/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import Photos
import PhotosUI
import AVKit
import ARKit
import GSImageViewerController
import MobileCoreServices
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController
import OpalImagePicker
import BSImageView
import BSImagePicker


var campaignCategoryDict = [String:Any]()

@available(iOS 13.0, *)
extension CampaignDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.campaignSubCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "AddAdditionalServicesTableCell", for: indexPath) as! AddAdditionalServicesTableCell
        if campaignSubCategories.count > 0 {
            tableCell.updateModel(campaignSubCategories[indexPath.row], indexPath.row,alreadySelectedCategory: modelUdpate)
            tableCell.delegate = self
        }
        return tableCell
    }
        
    @objc func updateCell(_ model: Any,_ strType:String, _ cell: UITableViewCell, _ item: Int) {
        var modelUdpate = model as! [SubCategorySelectedModel]
        if strType != "Pressed Info Button" {
            if let indexRemove = modelUdpate.firstIndex(where: { $0.subcategoryId == nil})  {
                modelUdpate.remove(at: indexRemove)
            }
            
            print("inpuData = ",modelUdpate)
            
            var selectedyQuantity = [""]
            var selectedCategoryAddOnServices = [""]
            
            selectedyQuantity.removeAll()
            selectedCategoryAddOnServices.removeAll()
            
            for i in 0..<modelUdpate.count {
                if !selectedCategoryAddOnServices.contains(modelUdpate[i].subcategoryId ?? "") {
                    selectedyQuantity.append(modelUdpate[i].selectedQuantity ?? "")
                    selectedCategoryAddOnServices.append(modelUdpate[i].subcategoryId ?? "")
                }
            }
            
            selectedCategoryQuantity = selectedyQuantity.joined(separator: ",")
            selectedCategoryAddOn = selectedCategoryAddOnServices.joined(separator: ",")
            
            print(selectedCategoryQuantity,selectedCategoryAddOn)
            if self.campaignMediaList.indices.contains(currentImageIndex) {
                CreditApiStore.sharedInstance.sendCategoryAndSubCategoryApi(self.campaignMediaList[currentImageIndex].internalIdentifier ?? "0", self.selectedCategoryAddOn, self.selectedCategoryQuantity) { responseData in
                    let response = responseData?["response"] as! NSDictionary
                    if response["status"] as! String == "1" {
                        self.getCampaignDetails()
                    }
                }
            }
        }else{
            UIAlertController.showAlert("", message: campaignSubCategories[item].description ?? "", buttons: ["OK"], completion: { (alert, index) in })
        }
    }
    
    func fetchAvailableCampaignCategories() {
        //modelUdpate.removeAll()
        self.campaignSubCategories.removeAll()
        CreditApiStore.sharedInstance.getCampaignSubCategories(selectedCategory: CompletedCampaignStore.sharedInstance.selectedCategoryId) { response in
            self.campaignSubCategories = response?.subCategoryResponse?.subCategoryData?.subservices ?? []
            self.vWAdditionalServicesHeight.constant = CGFloat(60 * self.campaignSubCategories.count)

            SVProgressHUD.dismiss()
            self.slectedServicestableview.reloadData()
        }
    }
}

@available(iOS 13.0, *)
class CampaignDetailViewController: AbstractControl, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TopBarDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, OpalImagePickerControllerDelegate, BWWalkthroughViewControllerDelegate, ExposureCustomCameraDelegate,TableCellDelegate {
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var creditUsed: UILabel!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var tabBottomBar: UIImageView!
    @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topNoDataFound: UILabel!
    @IBOutlet var noDataFoundLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var photoCommentTextView: UITextView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var markButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var firstNote: UILabel!
    @IBOutlet var dataCollectionView: UICollectionView!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var createdDate: UILabel!
    @IBOutlet var contentBy: UILabel!
    @IBOutlet var assignedTo: UILabel!
    @IBOutlet var numberOfPhotos: UILabel!
    @IBOutlet var numberOfVideos: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var creditAmount: UILabel!
    @IBOutlet var payableAmount: UILabel!
    @IBOutlet var urgentDeliveryButton: UIButton!
    @IBOutlet var holderScrollView: UIScrollView!
    
    @IBOutlet var selectedCountLabel: UILabel!
    @IBOutlet var imageScroller: UICollectionView!
    @IBOutlet var mediaActionHolderView: UIView!
    
    @IBOutlet var viewerHolderView: UIView!
    @IBOutlet var viewerCollectionView: UICollectionView!
    
    @IBOutlet var viewerFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var holderViewHeightCons: NSLayoutConstraint!
    var rowsWhichAreChecked = NSMutableArray()
    var selectedImageIds = NSMutableArray()
 
    var qty = String()
    var campaignIdd = String()
    var doubleStr = String()
    var creditUseds = String()
    var total = Double()
    var urgentCreditUsed = String()
    var urgentCredits = String()
    var currentImageIndex = Int()
    var viewerCurrentImageIndex = Int()
    var selectedImagesData = [UIImage]()
    var selectedVideoData = [UIImage]()
    var campaignMediaList = [NewCampaignDetailcampaignMedia]()
    var campaignDetailObjects : NewCampaignDetailresult!
    let picker = UIImagePickerController()
    var selectedMediaThumbnails = [UIImage]()
    var urgentTypeString = String()
    var noteLabelString = NSMutableAttributedString()
    var imagesUrl = [URL]()
    var paymentOption = String()
    var capturedPhotos = [UIImage]()
    var galleryImagesArray = [UIImage]()
    
    var imagesOrientation  = [String]()
    var imageSelectionType  = String()
    var currentOrientationValue  = String()
    
    var selectedCampaignCategoryName = ""
    var selectedCampaignCategoryId = ""
    var selectedCampaignCategoryPrice = ""
    
    var categoryPrice = Int()
    var totalCredits = Int()
    
    var creditCategoryVC = CreditCategoryVC()
    
    @IBOutlet var loaderImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var loaderImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var loadingImageView: UIImageView!
    @IBOutlet var loadingHolderView: UIView!
    @IBOutlet var customCameraView: UIView!
    var exposureValues  = [Float]()
    var minDuration  = [Float]()
    var maxDuartion  = [Int]()
    @IBOutlet var customCameraHolderView: UIView!
    @IBOutlet var imagesCountLabel: UILabel!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var selectedPhotosDataCamera = [NSData]()
    var selectedPhotosDataCamera1 = [NSData]()
    var photoData = [NSData]()
    var selectedPhotosData = [Data]()
    var selectedPhotosData1 = [Data]()
    var expouserCounter = Int()
    
    
    var normalCampPrice = String()
    var urgentCampPrice = String()
    var normalPayblePrice = String()
    var urgentPayblePrice = String()
    var loaderImage = UIImage()
    let cameraManager = CameraManager()
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    @IBOutlet var viewerCommentHolder: UIView!
    //    @IBOutlet var viewerCommentHolder: UIView!
    @IBOutlet var viewerText: UITextView!
    var showHide: Bool = false{
        didSet {
            if showHide == true {
                editButton.isHidden = false
                markButton.isHidden = false
                deleteButton.isHidden = false
            }
            else {
                editButton.isHidden = true
                markButton.isHidden = true
                deleteButton.isHidden = true
            }
        }
    }

    // Sham Start
    //var modelUdpateSubCategory = [SubCategorySelectedModel()]

    var campaignSubCategories = [SubCategories]()
    @IBOutlet weak var vWAdditionalServicesHeight: NSLayoutConstraint! //Main View Height
    @IBOutlet weak var slectedServicestableview: UITableView!
    
    var selectedCategoryQuantity = ""
    var selectedCategoryAddOn = ""
    
//
//    @IBAction func btnAddiotnalServicesAction(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let creditSubCat = storyBoard.instantiateViewController(withIdentifier: "CreditSubCategories") as! CreditSubCategories
//        creditSubCat.delegate = self
//        creditSubCat.selectedCategory = CompletedCampaignStore.sharedInstance.selectedCategoryId
//        creditSubCat.modelUdpate = modelUdpateSubCategory
//        creditSubCat.selectedImageId = self.campaignMediaList[currentImageIndex].internalIdentifier ?? "0"
//        navigationController?.pushViewController(creditSubCat, animated: true);
//    }
//
//    func updateSelectedCategorResponse(inpuData: [SubCategorySelectedModel]) {
//        modelUdpateSubCategory = inpuData
//        slectedServicesCollectionVw.reloadData()
//    }
//
    //End
    
    // View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelUdpate.removeAll()
        //modelUdpateSubCategory.removeAll()
        Quantity.delegate = self
        centeredNavBarImageView()
        
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(CampaignDetailViewController.barButtonDidTap(_:)))
        
        //        let modelUpdatew = SubCategorySelectedModel(subcategoryId:"1", selectedQuantity: "2",selectedQuantityName: "rewrwwrwrfsdfdsfsf")
        //        let modelUpdate2w = SubCategorySelectedModel(subcategoryId:"1", selectedQuantity: "2",selectedQuantityName: "9-90-90")
        //        self.modelUdpateSubCategory.append(modelUpdatew)
        //        self.modelUdpateSubCategory.append(modelUpdate2w)
        //
        //        self.slectedServicesCollectionVw.reloadData()
        
        holderViewHeightCons.constant = 0
        urgentTypeString = "0"
        noteLabelString = firstNote.attributedText as? NSMutableAttributedString ?? NSMutableAttributedString(string: "")
        crossButton.isHidden = true
        
        
        
        //        let originalAttributedText = nameLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
        //
        //        // then we replace text so easily
        //        let newAttributedText = originalAttributedText.mutableString.setString("new text to replace")
        
        
        firstNote.text = ""
        picker.delegate = self
        topBar.delegate = self
        self.showHide = false
        photoCommentTextView.addBorder(UIColor.lightGray)
        
        //        self.topImageView.actionBlock {
        //            if self.playButton.isHidden == true {
        //                let imageInfo      = GSImageInfo(image: self.topImageView.image!, imageMode: .aspectFit, imageHD: nil)
        //                let transitionInfo = GSTransitionInfo(fromView: self.topImageView)
        //                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        //                self.present(imageViewer, animated: true, completion: nil)
        //            }
        //
        //        }
        viewerHolderView.isHidden = true
        //        viewerFlowLayout.itemSize = UIScreen.main.bounds.size
        //        viewerFlowLayout.scrollDirection = .horizontal
        //        viewerFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //        viewerFlowLayout.minimumInteritemSpacing = 0.0
        customCameraHolderView.isHidden = true
        
//        slectedServicesCollectionVw.register(UINib(nibName: "AddAdditionalServicesCell", bundle: nil), forCellWithReuseIdentifier: "AddAdditionalServicesCell")
//        slectedServicesCollectionVw.delegate = self
//        slectedServicesCollectionVw.dataSource = self
//        slectedServicesCollectionVw.reloadData()
        
        //slectedServicestableview.estimatedRowHeight = 140
        slectedServicestableview.rowHeight = UITableViewAutomaticDimension
        slectedServicestableview.register(UINib(nibName: "AddAdditionalServicesTableCell", bundle: nil), forCellReuseIdentifier: "AddAdditionalServicesTableCell")
        slectedServicestableview.delegate = self
        slectedServicestableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   AppUtility.lockOrientation(.portrait)
        let bottomOffset = CGPoint(x: 0, y: (holderScrollView.contentSize.height - holderScrollView.bounds.height) + 15 )
        holderScrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //AppUtility.lockOrientation(.all)
        session?.stopRunning()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc = sb.instantiateViewController(withIdentifier: "CampaignDetailViewController") as? CampaignDetailViewController
        if vc != nil {
            vc = nil
        }
        campaignCategoryDict.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageSelectionType = "normal"
        imagesOrientation.removeAll()
        convertOrientation()
        getCampaignDetails()
        // newEdit--phase2
        print(campaignCategoryDict)
        // --newEdit - Phase2
        if !campaignCategoryDict.isEmpty {
            self.categoryPrice = campaignCategoryDict["categoryPrice"]! as! Int
            
            if let stringToFloat = Float(self.payableAmount.text!) {
                let credits = Int(stringToFloat)
                print(credits)
                totalCredits = self.categoryPrice + credits
            } else {
                totalCredits = self.categoryPrice + Int(self.payableAmount.text!)!
            }
            
            let categoryName = campaignCategoryDict["categoryName"]! as! String
            
            UIAlertController.showAlert("Usnap", message: "Are you sure you want to submit with \(categoryName.uppercased()) category\nTotal Credits : \(totalCredits)", buttons: ["Change", "Yes"]) { _, index in
                if index == 0 {
                    campaignCategoryDict.removeAll()
                    self.navigationController?.pushViewController(CreditCategoryVC.control, animated: true)
                    self.dismiss(animated: true)
                } else {
                    self.dismiss(animated: true)
                    self.submitCampaign()
                    
                    
                    // call api here with updated coins and check the available coins before placing order (from API)
                    //self.savePressed("0", String(format: "Please confirm submission of this campaign to the retouching team. %@ will be charged from your nominated account at the time of submission.", self.payableAmount.text!))
                }
            }
        }
    }
    
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
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
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        //        let collectionViewFlowControl = UICollectionViewFlowLayout()
        //        collectionViewFlowControl.scrollDirection = UICollectionView.ScrollDirection.horizontal
        //
        //        slectedServicesCollectionVw.collectionViewLayout = collectionViewFlowControl
        
        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.collectionView?.isPagingEnabled = false
//        layout.collectionView?.isScrollEnabled = false
//        self.slectedServicesCollectionVw.collectionViewLayout = layout
    }
    
    func submitCampaign() {
        CreateCampaignStore.sharedInstance.submitCampaign(campaignCategoryDict["categoryId"]! as! String, self.urgentTypeString, CompletedCampaignStore.sharedInstance.CompletedCampaignId, UserStore.sharedInstance.userInfo, "0") { response in
            print(response)
            
            
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                print(responseData)
                
                if responseData["is_mail_exist"] as! String == "1" {
                    SVProgressHUD.dismiss()
                   
                    DispatchQueue.main.async {
                        self.popOrDismissViewController(true)
                    }
//                    UIAlertController.showAlert("Success", message: "Your campaign has been submitted successfully. Pick your hard copies from our Usnap office and you can also print real estate signage and install the signs for sale.", buttons: ["OK"], completion: { (UIAlertController, Int) in
//                        self.popOrDismissViewController(true)
//                    })
                    
                }
                else {
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        self.showEmailOptionToAdd()
                    }
//                    UIAlertController.showAlert("Success", message: "Your campaign has been submitted successfully. Pick your hard copies from our Usnap office and you can also print real estate signage and install the signs for sale.", buttons: ["OK"], completion: { (UIAlertController, Int) in
//                        self.showEmailOptionToAdd()
//                    })
                    
                    //                            SVProgressHUD.showSuccess(withStatus: "Your campaign has been submitted successfully.")
                    //                            self.showEmailOptionToAdd()
                }
            } else {
                SVProgressHUD.showError(withStatus: responseData["message"] as? String)
            }
        }
    }
    
    func getCampaignDetails()  {
        SVProgressHUD.show()
        CreateCampaignStore.sharedInstance.getNewCampaignDETAIL(String(NewCampaignDetailStore.sharedInstance.createdCampaignId), UserStore.sharedInstance.userInfo) { [self] (response) in
            
            print("======>>>>>>", response)
            
            if response?.newCampaignDetailresponse?.status == "1" {
                
                //print(response?.newCampaignDetailresponse?.newCampaignDetailresult?.newCampaignDetailcampaignMedia![0].media)
                
                
                self.campaignDetailObjects = response?.newCampaignDetailresponse?.newCampaignDetailresult
                self.campaignMediaList = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.newCampaignDetailcampaignMedia)!
                
                CompletedCampaignStore.sharedInstance.selectedCategoryId = (self.campaignDetailObjects.campaign_category_id ?? "")
                
                print("Selected Category id =", CompletedCampaignStore.sharedInstance.selectedCategoryId)
                
                self.paymentOption = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.paymentOption!)!
                
                
                self.titleLabel.text = String(format: "#%d- %@ \n%@",  Int((response?.newCampaignDetailresponse?.newCampaignDetailresult?.internalIdentifier!)!)! + 100, (response?.newCampaignDetailresponse?.newCampaignDetailresult?.title!)!, (response?.newCampaignDetailresponse?.newCampaignDetailresult?.address!)!)
                //  String(format: "#%d", Int(self.campaignListResponse[indexPath.row].internalIdentifier!)! + 100)
                
                // self.titleLabel.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.title!
                //self.categoryName.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.catagories!
                
                
               
                self.categoryName.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.paymentStatus!
                self.createdDate.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.addDate!.removeTimeFromString( (response?.newCampaignDetailresponse?.newCampaignDetailresult?.addDate!)!)
                
                self.numberOfPhotos.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.noOfPhotos!
                self.numberOfVideos.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.noOfVideos!
                self.statusLabel.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.status!
                self.contentBy.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.contentBy!
                self.assignedTo.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.assignedTo!
                // In total price label we are showing remaning days.
                
                self.totalPrice.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.RemaningDays!
                self.creditAmount.text = ""// gst lbl
                self.Quantity.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.quantity!
                self.qty = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.quantity!)!
                self.payableAmount.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.credits
                self.campaignIdd = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.id!)!
                //self.payableAmount.text = response?.newCampaignDetailresponse?.newCampaignDetailresult?.amountPayable
                self.creditUsed.text =  (response?.newCampaignDetailresponse?.newCampaignDetailresult?.credit_used!)!
                self.creditUseds = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.credit_used!)!
                self.urgentCreditUsed = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgent_credit_used!)!
                self.urgentCredits = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentCredits!)!
                self.normalCampPrice = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.totalPrice!)!
                self.urgentCampPrice = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.UrgentPrice!)!
                self.normalPayblePrice = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.credits!)!
                self.urgentPayblePrice = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentPaybleAmount!)!
                
                total = Double(normalPayblePrice)! + Double(creditUseds)!
                doubleStr = String(format: "%.2f", total)
               
                
                if response?.newCampaignDetailresponse?.newCampaignDetailresult?.service_Type! == "1" {
                    Quantity.isHidden = false
                    quantityLbl.isHidden = false
                } else {
                    
                    Quantity.isHidden = true
                    quantityLbl.isHidden = true
                }
                
                
                
                
                let newString = response?.newCampaignDetailresponse?.newCampaignDetailresult?.UrgentTime!
                self.noteLabelString = NSMutableAttributedString()
                //                Note: Urgent delivery is a request sent to the retouchers, requesting the job is processed in under 12 hours at an additional fee per image.
                //                The retoucher will accept/deny this request depending on availability. Please note the additional charge of $XX (urgent charge fee per image set by admin) per image submitted, will be automatically deducted should the retoucher accept this urgent request.
                
                let timeString = String(format: "Note: Urgent delivery is a request sent to retouchers, requesting the job is processed in under %@. at an additional fee per image. \n The retoucher will accept/deny this request depending on availability. Please also note there are additional charges of %@ per image submitted, will be automatically deducted should the retoucher accept this urgent request. If the retoucher denies the urgent request you are only charged the standard rate.", newString!, (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentPricePerImage!)!)
                var noteMutableString = NSMutableAttributedString()
                noteMutableString = NSMutableAttributedString(string: timeString)
                
                let font = UIFont(name: "Helvetica-Bold", size: 15.0)
                noteMutableString.addAttribute(NSAttributedStringKey.font, value:font!, range: NSRange.init(location: 0, length: 5))
                
                // newEdit
                //                guard let range = timeString.range(of: newString!) else { exit(0) }
                //                let nsRange = NSRange(range, in: newString!)
                //                noteMutableString.addAttribute(NSAttributedStringKey.font, value:font!, range: nsRange)
                let str = NSString(string: timeString)
                let theRange = str.range(of: newString!)
                noteMutableString.addAttribute(NSAttributedStringKey.font, value:font!, range: theRange)
                
                //                guard let range2 = timeString.range(of: (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentPricePerImage!)!) else { exit(0) }
                //                let nsRange2 = NSRange(range2, in: (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentPricePerImage!)!)
                //                noteMutableString.addAttribute(NSAttributedStringKey.font, value:font!, range: nsRange2)
                let theRange2 = str.range(of: (response?.newCampaignDetailresponse?.newCampaignDetailresult?.urgentPricePerImage!)!)
                noteMutableString.addAttribute(NSAttributedStringKey.font, value:font!, range: theRange2)
                // newEdit: Ends
                
                self.noteLabelString.append(noteMutableString)
                
                if self.campaignMediaList.count == 0  {
                    self.topNoDataFound.isHidden = false
                    self.topImageView.isHidden = true
                    self.noDataFoundLabel.isHidden = false
                    self.dataCollectionView.isHidden = true
                    self.crossButton.isHidden = true
                    self.showHide = false
                    CompletedCampaignStore.sharedInstance.CompletedCampaignId = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.internalIdentifier)!
                }
                else {
                    self.showHide = true
                    self.topNoDataFound.isHidden = true
                    self.topImageView.isHidden = false
                    self.noDataFoundLabel.isHidden = true
                    self.dataCollectionView.isHidden = false
                    self.crossButton.isHidden = true
                    self.currentImageIndex = 0
                    CompletedCampaignStore.sharedInstance.CompletedCampaignId = (response?.newCampaignDetailresponse?.newCampaignDetailresult?.internalIdentifier)!
                    CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[0].internalIdentifier!
                    if self.campaignMediaList[0].type == "p" {
                        self.topImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(self.campaignMediaList[0].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                        //  self.playButton.isHidden = true
                    }
                    else {
                        self.topImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(self.campaignMediaList[0].media!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                        // self.playButton.isHidden = false
                    }
                    self.photoCommentTextView.text = self.campaignMediaList[0].comment
                    self.viewerText.text = self.campaignMediaList[0].comment
                    // self.manageTopHeight((self.campaignMediaList[0].height! as NSString).floatValue, (self.campaignMediaList[0].width! as NSString).floatValue)
                    
                    if self.campaignMediaList.count > 0 {
                        print("Selected Index = ",self.currentImageIndex)
                        if self.campaignMediaList.indices.contains(self.currentImageIndex) {
                            if self.campaignMediaList[self.currentImageIndex].campaignDetailaddOnServices!.count > 0 {
                                self.fetchSubCategoryIds(indexPath: self.currentImageIndex)
                            }
                        }
                    }
                }
                self.dataCollectionView.reloadData()
                self.imageScroller.reloadData()
                self.viewerCollectionView.reloadData()
                self.slectedServicestableview.reloadData()
                self.fetchAvailableCampaignCategories()
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func setLabelsFont(targetLabel : UILabel) {
        let labelText : [String] = targetLabel.text!.components(separatedBy: ":")
        let boldString = labelText[0]
        let normalString = String(format: "%@%@", ":", labelText[1])
        
        // EDIT BOLD TEXT
        var boldMutableString = NSMutableAttributedString()
        boldMutableString = NSMutableAttributedString(string: boldString, attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic-Bold", size: 12.0)!])
        boldMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:boldString.count))
        
        // EDIT NORMAL TEXT
        var normalMutableString = NSMutableAttributedString()
        normalMutableString = NSMutableAttributedString(string: normalString, attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic", size: 11.0)!])
        normalMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:normalString.count))
        boldMutableString.append(normalMutableString)
        targetLabel.attributedText = boldMutableString
    }
    
    @IBAction func crossButtonClick(_ sender: Any) {
        showHide = !showHide
    }
    
    @IBAction func cameraIconClick(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.selectedPhotosDataCamera.removeAll()
            self.selectedPhotosData.removeAll()
            self.capturedPhotos.removeAll()
            self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
            self.sourceOptions()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.selectedPhotosDataCamera.removeAll()
                        self.selectedPhotosData.removeAll()
                        self.capturedPhotos.removeAll()
                        self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
                        self.sourceOptions()
                    }
                    //access allowed
                } else {
                    //access denied
                    UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                        
                    })
                }
            })
        }
    }
    
    func sourceOptions() {
        let alertController = UIAlertController(title: "", message: "Select type", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Photos from gallery", style: .default) { (action) in
            
            print(UserStore.sharedInstance.showCameraSuggestion)
            if UserStore.sharedInstance.showCameraSuggestion == "" {
                UIAlertController.showAlert("Alert!", message: "For best results use uSnap’s camera to automatically capture 9 exposures", buttons: ["Cancel", "Proceed", "Don't show this again" ], completion: { (alert, index) in
                    
                    print(index)
                    if index == 0 {}
                    else if index == 1 {
                        self.openPicker_Photos(.savedPhotosAlbum)
                    }
                    else {
                        UserStore.sharedInstance.showCameraSuggestion = "Dont show"
                    }
                    
                })
            }
            
            else {
                self.openPicker_Photos(.savedPhotosAlbum)
            }
        }
        
        let action2 = UIAlertAction(title: "Photos from camera", style: .default) { (action) in
            
            NewCampaignDetailStore.sharedInstance.selectedCameraType = ""
            var typesOfCamera = [String]()
            if #available(iOS 13.0, *) {
                let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInUltraWideCamera], mediaType: AVMediaType.video, position: .back).devices
                for devices in availableDevices {
                    print(devices.deviceType.rawValue)
                    typesOfCamera.append(devices.deviceType.rawValue)
                }
            }
            
            else {
                let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera], mediaType: AVMediaType.video, position: .back).devices
                for devices in availableDevices {
                    print(devices.deviceType.rawValue)
                    typesOfCamera.append(devices.deviceType.rawValue)
                }
            }
            
            if typesOfCamera.contains("AVCaptureDeviceTypeBuiltInWideAngleCamera")  &&  typesOfCamera.contains("AVCaptureDeviceTypeBuiltInUltraWideCamera") {
                UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: ["Wide Angle Camera", "Normal Camera"], holdView: self.view) { (alert, index) in
                    print(index)
                    
                    if index  == 0 {
                        return
                    }
                    // Wide Angle
                    if index  == 1 {
                        NewCampaignDetailStore.sharedInstance.selectedCameraType = "UltraWide"
                    }
                    else if index  == 2 {
                        NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
                    }
                    
                    if UserStore.sharedInstance.showTutorialScreens == "show" || UserStore.sharedInstance.showTutorialScreens == "" {
                        self.setTutorial()
                    }  else {
                        self.setCustomCamera()
                    }
                }
            }
            
            else {
                NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
                
                if UserStore.sharedInstance.showTutorialScreens == "show" || UserStore.sharedInstance.showTutorialScreens == "" {
                    self.setTutorial()
                }  else {
                    self.setCustomCamera()
                }
            }
            
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = addPhotoButton
            popoverPresentationController.sourceRect = addPhotoButton.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openPicker_Photos(_ sourceType: UIImagePickerControllerSourceType)  {
        //        picker.sourceType = sourceType
        //        picker.delegate = self
        //        picker.mediaTypes = [kUTTypeImage as NSString as String]
        //        present(picker, animated: true, completion: nil)
        //        let galleryImagePicker = OpalImagePickerController()
        //        galleryImagePicker.imagePickerDelegate = self
        //        galleryImagePicker.maximumSelectionsAllowed = 5
        //        present(galleryImagePicker, animated: true, completion: nil)
        
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 10
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
            self.dismiss(animated: true, completion: nil)
        }, finish: { (assets: [PHAsset]) -> Void in
            self.getImages(assets)
        }, completion: nil)
    }
    
    func getImages(_ assets: [PHAsset])  {
        SVProgressHUD.show()
        for item in assets {
            let imagesss = getUIImage(asset: item)
            if imagesss != nil {
                galleryImagesArray.append(imagesss!)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    SVProgressHUD.showInfo(withStatus: "file format is not supported")
                }
            }
        }
        SVProgressHUD.dismiss()
        self.processGaleryImages(galleryImagesArray)
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        print("Final Image = ",img as Any)
        return img
    }
    
    @IBAction func addVideoButtonClick(_ sender: Any) {
        //        CompletedCampaignStore.sharedInstance.existingVideoLink = self.campaignDetailObjects.videoExist!
        //        CompletedCampaignStore.sharedInstance.existingVideoLink = self.campaignDetailObjects.audioExist!
        navigationController?.pushViewController(AddVideoViewController.Control(self.campaignDetailObjects.audioExist!, self.campaignDetailObjects.videoExist!), animated: true)
        
        //        if self.campaignDetailObjects.videoExist != "" && self.campaignDetailObjects.audioExist != "" {
        //           SVProgressHUD.show(withStatus: "You have already uploaded video and audio file")
        //        }
        //        else  {
        //            navigationController?.pushViewController(AddVideoViewController.control, animated: true)
        //        }
    }
    
    @IBAction func messageButtonClick(_ sender: Any) {
        LocalMessageStore.sharedInstance.chatCampaignId = CompletedCampaignStore.sharedInstance.CompletedCampaignId
        navigationController?.pushViewController(MessagingViewController.control, animated: true)
    }
    
    @IBAction func urgentDeliveryClick(_ sender: Any) {
        if urgentDeliveryButton.currentImage == #imageLiteral(resourceName: "Tick") {
            urgentTypeString = "0"
            urgentDeliveryButton.setImage(UIImage(named: "UnTick"), for: .normal)
            firstNote.text = ""
            //totalPrice.text = normalCampPrice
            payableAmount.text = normalPayblePrice
            total = Double(normalPayblePrice)! + Double(creditUseds)!
            creditUsed.text = creditUseds
             doubleStr = String(format: "%.2f", total) // "3.14"
        }
        else {
            firstNote.text = ""
            print(noteLabelString.string)
            print(noteLabelString)
            urgentTypeString = "1"
            urgentDeliveryButton.setImage(UIImage(named: "Tick"), for: .normal)
            firstNote.attributedText = noteLabelString
            //totalPrice.text = urgentCampPrice
            creditUsed.text = urgentCreditUsed
            payableAmount.text = urgentCredits
            total = Double(urgentCredits)! + Double(urgentCreditUsed)!
             doubleStr = String(format: "%.2f", total)
        }
    }
    
    //
    @IBAction func saveOnlyClick(_ sender: Any) {
        if  self.campaignDetailObjects.cardExist == "no" {
            UIAlertController.showAlert("Alert!", message: "your credit card is not linked. Please enter your card details first.", buttons: ["Submit", "Cancel"], completion: { (alert, index) in
                print(index)
                if index == 0 {
                    self.navigationController?.pushViewController(CreditCardDetailsViewController.control, animated: true)
                }
                else {
                    
                }
            })
        } else {
            // self.payableAmount.text!
            savePressed("1" , String(format: "Please confirm you wish to save this campaign as a draft. This campaign will not be processed until you submit the campaign to the retouching team."))
        }
    }
    
    @IBAction func saveAndSubmitClick(_ sender: Any) {
        // newEdit--Phase2
        //        if campaignCategoryDict.isEmpty {
        //            UIAlertController.showAlert("Attention!", message: "Please select the campaign category from the edit screen.", buttons: ["OK"], completion: { (alert, index) in
        //
        //            })
        //            //self.navigationController?.pushViewController(CreditCategoryVC.control, animated: true)
        //        }else{
        savePressed("0", String(format: "Please confirm submission of this campaign to the retouching team. %@ will be charged from your nominated account at the time of submission.", doubleStr))
        //}
        
        /*if  self.campaignDetailObjects.cardExist == "no" {
         UIAlertController.showAlert("Alert!", message: "your credit card is not linked. Please enter your card details first.", buttons: ["Submit", "Cancel"], completion: { (alert, index) in
         print(index)
         if index == 0 {
         self.navigationController?.pushViewController(CreditCardDetailsViewController.control, animated: true)
         } else {
         }
         })
         }
         else {
         if paymentOption == "later" {
         savePressed("0", String(format: "Please confirm submission of this campaign to the retouching team. %@ will be charged from your nominated account.", self.payableAmount.text!))
         } else {
         //savePressed("0", "Your payment will be deducted at the time of submission")
         savePressed("0", String(format: "Please confirm submission of this campaign to the retouching team. %@ will be charged from your nominated account at the time of submission.", self.payableAmount.text!))
         }
         }*/
    }
    
    @IBAction func viewInvoiceClick(_ sender: Any) {
        navigationController?.pushViewController(CampaignInvoiceViewController.control, animated: true)
    }
    
    @IBAction func photosbuttonClick(_ sender: Any) {
        dataCollectionView.reloadData()
    }
    
    @IBAction func videosButtonClick(_ sender: Any) {
        dataCollectionView.reloadData()
    }
    
    func savePressed(_ saveType : String, _ messageAttachment : String) {
        var tempComemntArray = [String]()
        for i in 0 ..< self.campaignMediaList.count {
            if self.campaignMediaList[i].comment! == "" {
            } else {
                tempComemntArray.append(self.campaignMediaList[i].comment!)
            }
        }
        
        if tempComemntArray.count ==  self.campaignMediaList.count {
            uploadCampToServer(String(format: "%@ %@", "", messageAttachment), saveType)
        } else {
            uploadCampToServer(String(format: "%@ %@", "Please note some of your media does not contain instructions. Are you sure you wish to proceed?", messageAttachment), saveType)
        }
    }
    
    func uploadCampToServer(_ message: String, _ saveType : String) {
        UIAlertController.showAlert("Alert!", message: message, buttons: ["Cancel", "Submit"], completion: { [self] (alert, index) in
            if index == 0 {
            } else {
                CampaignStore.sharedInstance.SaveCampaign(self.urgentTypeString, CompletedCampaignStore.sharedInstance.CompletedCampaignId, UserStore.sharedInstance.userInfo , saveType,payableAmount.text!,creditUsed.text!) { (response) in
                    
                    print("pay---->>>",payableAmount.text)
                    print("credit----->>>>",creditUsed.text)
                    let responseData = response?["response"] as! NSDictionary
                    if responseData["status"] as! String == "1" {
                        print(responseData)
                        
                        if responseData["is_mail_exist"] as! String == "1" {
                            SVProgressHUD.dismiss()
                            //UIAlertController.showAlert("Success", message: "Your campaign has been submitted successfully. Pick your hard copies from our Usnap office and you can also print real estate signage and install the signs for sale.", buttons: ["OK"], completion: { (UIAlertController, Int) in
                            self.popOrDismissViewController(true)
                            //})
                            
                        } else {
                            SVProgressHUD.dismiss()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                                self.showEmailOptionToAdd()
                            })
                            
                            // UIAlertController.showAlert("Success", message: "Your campaign has been submitted successfully. Pick your hard copies from our Usnap office and you can also print real estate signage and install the signs for sale.", buttons: ["OK"], completion: { (UIAlertController, Int) in
                            // // })
                            
                            // SVProgressHUD.showSuccess(withStatus: "Your campaign has been submitted successfully.")
                            // self.showEmailOptionToAdd()
                        }
                    } else {
                        SVProgressHUD.showError(withStatus: responseData["message"] as? String)
                    }
                }
            }
        })
    }
    
    func showEmailOptionToAdd() {
        let alertController = UIAlertController(title: "Enter Email", message: "Please add your email address, so we can notify you once your campaign is ready.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "abc@gmail.com"
        }
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert -> Void in
            var emails = String()
            emails = (alertController.textFields![0] as UITextField).text!
            if emails.length == 0 {
                UIAlertController.showAlert("Alert!", message: "Please enter email", buttons: ["OK"], completion: { (UIAlertController, Int) in
                })
            }
            else {
                self.saveEmailToServer(emails)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.popOrDismissViewController(true)
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveEmailToServer(_ email: String)  {
        if email.isValidEmail {
            CampaignStore.sharedInstance.SaveUserEmail(email, UserStore.sharedInstance.userInfo) { (resposne) in
                print(resposne as Any)
                let responseData = resposne?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Email saved successfully")
                    self.popOrDismissViewController(true)
                } else {
                    SVProgressHUD.showError(withStatus: "Sorry something went wrong")
                }
            }
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
            showEmailOptionToAdd()
        }
    }
    
    @IBAction func postCommentPhoto(_ sender: Any) {
        if self.campaignMediaList.count == 0  {
            SVProgressHUD.showError(withStatus: Constants.NOMEDIA_ERROR)
        }
        else {
            if photoCommentTextView.text == "" {
                SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
            }
            else {
                CampaignStore.sharedInstance.campaignImageComment(UserStore.sharedInstance.userInfo, CompletedCampaignStore.sharedInstance.CompletedCampaignId, CompletedCampaignStore.sharedInstance.CompletedcampaignImageId, photoCommentTextView.text!, "0") { (response) in
                    let responseData = response?["response"] as! NSDictionary
                    if responseData["status"] as! String == "1" {
                        self.campaignMediaList[self.currentImageIndex].comment = self.photoCommentTextView.text!
                        self.photoCommentTextView.text = self.campaignMediaList[self.currentImageIndex].comment
                        self.viewerText.text = self.campaignMediaList[self.currentImageIndex].comment
                        // self.photoCommentTextView.text = ""
                        SVProgressHUD.showSuccess(withStatus: "Comment added")
                    } else {
                        SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                    }
                }
            }
        }
    }
    
    @IBAction func XbuttonClick(_ sender: Any) {
        rowsWhichAreChecked.removeAllObjects()
        selectedImageIds.removeAllObjects()
        self.dataCollectionView.reloadData()
    }
    
    @IBAction func selectAllMedia(_ sender: Any) {
        rowsWhichAreChecked.removeAllObjects()
        
        for index in 0..<campaignMediaList.count {
            rowsWhichAreChecked.add(index as Any)
            selectedImageIds.add(self.campaignMediaList[index].internalIdentifier!)
        }
        self.dataCollectionView.reloadData()
    }
    
    @IBAction func trashClick(_ sender: Any) {
        UIAlertController.showAlert("Alert!", message: "Are you sure?", buttons: ["No", "Yes"], completion: { (alert, index) in
            if index == 0 {
            } else {
                var idString = String()
                idString = (self.selectedImageIds.map{String(describing: $0)}).joined(separator: ",")
                CreateCampaignStore.sharedInstance.deleteImage(idString) { (response) in
                    print(response as Any)
                    let responseData = response?["response"] as! NSDictionary
                    self.imageSelectionType = "normal"
                    if responseData["status"] as! String == "1" {
                        self.selectedImageIds = NSMutableArray()
                        self.rowsWhichAreChecked = NSMutableArray()
                        self.rowsWhichAreChecked.removeAllObjects()
                        self.selectedImageIds.removeAllObjects()
                        self.dataCollectionView.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()  + 0.01) {
                            // your function here
                            SVProgressHUD.show(withStatus: "Deleted successfully")
                            self.getCampaignDetails()
                        }
                        
                        
                    }
                }
            }
        })
    }
    
    @IBAction func viewerCrossButton(_ sender: Any) {
        //AppUtility.lockOrientation(.portrait)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        viewerHolderView.isHidden = true
        self.viewerCommentHolder.isHidden = true
        
    }
    @IBAction func viewerPostComment(_ sender: Any) {
        if viewerText.text == "" {
            SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
        }
        else {
            CampaignStore.sharedInstance.campaignImageComment(UserStore.sharedInstance.userInfo, CompletedCampaignStore.sharedInstance.CompletedCampaignId, self.campaignMediaList[viewerCurrentImageIndex].internalIdentifier!, viewerText.text!, "0") { (response) in
                print(response as Any)
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.campaignMediaList[self.viewerCurrentImageIndex].comment = self.viewerText.text!
                    SVProgressHUD.showSuccess(withStatus: "Comment added")
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    func backButtonClicked() {
    }
    
    func leftButtonClicked1() {
        
    }
    
    func leftButtonClicked2() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - SET CAMERA
    
    var backCamera = AVCaptureDevice.default(for: .video)
    
    func setCustomCamera()  {
        
        customCameraHolderView.isHidden = false
        ExposureCustomCamera.shared.beginCamera(customCameraView, self)
        
        
        
        //        customCameraHolderView.isHidden = false
        //        cameraManager.resumeCaptureSession()
        //        cameraManager.cameraOutputQuality = .high
        //        cameraManager.shouldEnableTapToFocus = false
        //        cameraManager.shouldEnableExposure = false
        //        cameraManager.writeFilesToPhoneLibrary = false
        //        cameraManager.shouldRespondToOrientationChanges = false
        //
        //        cameraManager.addPreviewLayerToView(customCameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        //        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
        //
        //            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
        //            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
        //
        //            self?.present(alertController, animated: true, completion: nil)
        //        }
        //
        //        return
        //
        //        session = AVCaptureSession()
        //        session!.sessionPreset = AVCaptureSession.Preset.photo
        //
        //
        //        //  backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //
        //
        //        do {
        //            try backCamera?.lockForConfiguration()
        //        }
        //        catch let error1 as NSError {
        //            print(error1.localizedDescription)
        //        }
        //        backCamera?.exposureMode = .custom
        //
        //        print((backCamera?.activeFormat.maxISO)!)
        //        backCamera?.setExposureModeCustom(duration: CMTimeMake(1,150), iso: 450 , completionHandler: {(timestamp:CMTime) -> Void in
        //
        //        })
        //
        //
        //
        //        var error: NSError?
        //        var input: AVCaptureDeviceInput!
        //        do {
        //            input = try AVCaptureDeviceInput(device: backCamera!)
        //
        //
        //
        //
        //        } catch let error1 as NSError {
        //            error = error1
        //            input = nil
        //            print(error!.localizedDescription)
        //        }
        //        if error == nil && session!.canAddInput(input) {
        //            session!.addInput(input)
        //            stillImageOutput = AVCaptureStillImageOutput()
        //            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        //            if session!.canAddOutput(stillImageOutput!) {
        //                session!.addOutput(stillImageOutput!)
        //                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        //                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //                videoPreviewLayer!.frame = customCameraView.frame
        //                customCameraView.layer.addSublayer(videoPreviewLayer!)
        //                session!.startRunning()
        //                // ...
        //                // Configure the Live Preview here...
        //            }
        //            // ...
        //            // The remainder of the session setup will go here...
        //        }
    }
    
    
    
    
    func setTutorial()  {
        DispatchQueue.main.async {
           // AppUtility.lockOrientation(.all)
            let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
            let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
            let page_one = stb.instantiateViewController(withIdentifier: "walk1")
            let page_two = stb.instantiateViewController(withIdentifier: "walk2")
            let page_three = stb.instantiateViewController(withIdentifier: "walk3")
            // let page_four = stb.instantiateViewController(withIdentifier: "walk0") as UIViewController
            walkthrough.closeButton?.setTitleColor(.red, for: .normal)
            // Attach the pages to the master
            walkthrough.delegate = self
            walkthrough.add(viewController:page_one)
            walkthrough.add(viewController:page_two)
            walkthrough.add(viewController:page_three)
            
            // walkthrough.add(viewController:page_four)
            self.present(walkthrough, animated: true, completion: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.dismiss(animated: true, completion: nil)
        self.setCustomCamera()
    }
    
    
    
    
    @IBAction func customCameraCancelClick(_ sender: Any) {
        self.selectedPhotosDataCamera1.removeAll()
        ExposureCustomCamera.shared.removeAllFromMemory()
        
        SVProgressHUD.dismiss()
        
        capturedPhotos.removeAll()
        selectedPhotosDataCamera.removeAll()
        customCameraHolderView.isHidden = true
    }
    
    @IBAction func customCameraDoneClick(_ sender: Any) {
        //        SVProgressHUD.dismiss()
        //
        self.selectedPhotosDataCamera1.removeAll()
        customCameraHolderView.isHidden = true
        //        self.uploadDataToServer()
        //        selectedPhotosDataCamera = [NSData]()
        ExposureCustomCamera.shared.removeAllFromMemory()
        
        
        
        SVProgressHUD.show(withStatus: "Processing")
        SVProgressHUD.setDefaultMaskType(.clear)
        
        perform(#selector(processImages), with: nil, afterDelay: 1)
        
    }
    
    
    @objc func processImages() {
        var orientationCounter = Int()
        orientationCounter = 0
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // change 2 to desired number of seconds
        cameraManager.stopCaptureSession()
        session?.stopRunning()
        session = nil
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Your code with delay
            // var tempIntCount = Int()
            // tempIntCount = 0
            
            //            for img in self.capturedPhotos {
            //                tempIntCount  = tempIntCount + 1
            //                DispatchQueue.main.async {
            //                    if tempIntCount  >= self.capturedPhotos.count  {
            //                        self.customCameraHolderView.isHidden = true
            //
            //                    }
            //
            //                    SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.capturedPhotos.count)), status: "Processing")
            //                    SVProgressHUD.setDefaultMaskType(.clear)
            //                }
            //               // let finalImageAfterRotation = self.imageOrientation(img)
            //                var finalImageAfterRotation = UIImage()
            //
            //                if self.imagesOrientation[orientationCounter] == "L" {
            //                    finalImageAfterRotation = img
            //                }
            //                else {
            //                    finalImageAfterRotation = self.imageOrientation(img)
            //                }
            //                orientationCounter = orientationCounter + 1
            //
            //                self.selectedPhotosDataCamera.append(finalImageAfterRotation.compressTo(3)! as NSData)
            //
            //                // self.selectedPhotosDataCamera.append(UIImagePNGRepresentation(finalImageAfterRotation)! as NSData)
            //
            //               // self.selectedPhotosDataCamera.append(finalImageAfterRotation.compressTo(2)! as NSData)
            //
            //            }
            
            
            SVProgressHUD.dismiss()
            self.capturedPhotos.removeAll()
            self.imagesOrientation.removeAll()
            // self.uploadDataToServer()
            
            
            //            for i in 0..<self.selectedPhotos.count {
            //                print("i", i)
            //                print("self.selectedPhotos.count", self.selectedPhotos.count)
            //                if (self.selectedPhotos.count - 1) == i {
            //                   print("i", i)
            //                   print("self.selectedPhotos.count - 1", self.selectedPhotos.count - 1)
            //                } else {
            //                    self.uploadDataToServer()
            //                }
            //            }
            //
            
        }
    }
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func uploadDataToServer()  {
        CreateCampaignStore.sharedInstance.sendCampaignData(selectedPhotosData as NSArray, selectedPhotosDataCamera  as NSArray, selectedVideoData as NSArray , UserStore.sharedInstance.userInfo, "", "", "", "", "", "", "", "", "", String(NewCampaignDetailStore.sharedInstance.createdCampaignId),  "") { (response) in
            print(response)
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                
                //-- Saved to photo library
                print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
                
                //                if self.selectedPhotosData.count != 0 {
                //                    for photoData in 0..<self.selectedPhotosData.count {
                //                        guard let image = UIImage(data: self.selectedPhotosData[photoData] as Data) else { return }
                //                        print(image)
                //                        CustomPhotoAlbum.shared.save(image: image)
                //                    }
                //                }
                //
                //                if self.selectedPhotosDataCamera.count != 0 {
                //                    for cameraData in 0..<self.selectedPhotosDataCamera.count {
                //                        guard let image = UIImage(data: self.selectedPhotosDataCamera[cameraData] as Data) else { return }
                //                        print(image)
                //                        CustomPhotoAlbum.shared.save(image: image)
                //                    }
                //                }
                
                //                if self.selectedVideoData.count != 0 {
                //                    for videoData in 0..<self.selectedVideoData.count {
                //                        //guard let image = UIImage(data: self.selectedVideoData[cameraData]) else { return }
                //                        print(self.selectedVideoData[videoData])
                //                        CustomPhotoAlbum.sharedInstance.save(image: self.selectedVideoData[videoData])
                //                    }
                //                }
                
                SVProgressHUD.showSuccess(withStatus: "Uploaded Successfully")
                self.selectedPhotosDataCamera.removeAll()
                self.capturedPhotos.removeAll()
                self.getCampaignDetails()
            } else {
                self.selectedPhotosDataCamera.removeAll()
                self.capturedPhotos.removeAll()
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func customCameraClickPic(_ sender: Any) {
        angle = .pi/2
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            loaderImage = UIImage.gifImageWithName("image_loaderLandscapeLeft")!
            print("11")
            currentOrientationValue = "L"
            angle = -.pi/2
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            loaderImage = UIImage.gifImageWithName("image_loaderLandscapeRight")!
            print("12")
            currentOrientationValue = "L"
            angle = .pi/2
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            loaderImage = UIImage.gifImageWithName("image_loaderPortrait")!
            print("13")
            currentOrientationValue = "P"
            angle = 0
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            loaderImage = UIImage.gifImageWithName("image_loaderPortraitUPSide")!
            print("14")
            currentOrientationValue = "P"
            angle = .pi
        }
        
        
        if capturedPhotos.count / 9 == 10 {
            SVProgressHUD.showError(withStatus: "Maximum 10 photos are allowed")
        } else {
            maxDuartion = [33, 50 , 70,  90, 110  ,130,  150]
            
            exposureValues = [108, 200 , 300,  350, 400  ,500,  580]
            
            loadingImageView.image = loaderImage
            
            if UIDevice.current.orientation.isLandscape {
                loaderImageWidthConstraint.constant = 152
                loaderImageHeightConstraint.constant = 250
            } else {
                loaderImageWidthConstraint.constant = 250
                loaderImageHeightConstraint.constant = 152
            }
            
            loadingHolderView.isHidden = false
            
            expouserCounter = 0
            
            capturePhotos()
        }
    }
    
    //    func capturePhoto(_ exposure : Float, _maxDuration  : Int )  {
    //        let videoConnection = stillImageOutput!.connection(with: AVMediaType.video)
    //        if(videoConnection != nil) {
    //            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
    //                if sampleBuffer != nil {
    //                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
    //                    let dataProvider = CGDataProvider(data: imageData! as CFData)
    //                    let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
    //
    //                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
    //                    let data = UIImagePNGRepresentation(image)
    //                    self.selectedPhotosDataCamera.append(data! as NSData)
    //
    //                    self.backCamera?.setExposureModeCustom(duration: CMTimeMake(1,Int32(_maxDuration)), iso: exposure , completionHandler: {(timestamp:CMTime) -> Void in
    //                        self.imagesCountLabel.text = String(self.selectedPhotosDataCamera.count / 7)
    //                        if self.expouserCounter == self.exposureValues.count - 1 {
    //                            self.expouserCounter = 0
    //                            SVProgressHUD.dismiss()
    //                            self.backCamera?.setExposureModeCustom(duration:CMTimeMake(1,Int32(self.maxDuartion[self.expouserCounter])) , iso: self.exposureValues[self.expouserCounter], completionHandler: nil)
    //                        }
    //                        else {
    //                            self.expouserCounter = self.expouserCounter + 1
    //                            self.capturePhoto(self.exposureValues[self.expouserCounter], _maxDuration: self.maxDuartion[self.expouserCounter])
    //                        }
    //                    })
    //                }
    //            })
    //        }
    //
    //
    //
    //    }
    
    var exposeValuesArray = [0.5,0.10,0.17,0.24,0.31,0.38,0.45,0.52,0.59]
    var count = 0
    
    
    func capturePhotos(){
        
        ExposureCustomCamera.shared.delegate = self
        ExposureCustomCamera.shared.captureClick()
        
        //        if self.count != 9 {
        //            self.cameraManager._changeExposureDuration(value: Float(self.exposeValuesArray[self.count]))
        //            self.count += 1
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        //                self.cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
        //                    if image != nil {
        //                        self.addOrientation()
        //                        self.capturedPhotos.append(image!)
        //                        self.cameraManager.focusMode = .locked
        //                        self.cameraManager._changeExposureMode(mode: .custom)
        //                        self.capturePhotos()
        //                    }
        //
        //                })
        //            })
        //
        //        } else {
        //            print("Done")
        //            self.cameraManager.focusMode = .continuousAutoFocus
        //            self.cameraManager._changeExposureMode(mode: .continuousAutoExposure)
        //            self.count = 0
        //            self.loadingHolderView.isHidden = true
        //            SVProgressHUD.dismiss()
        //            self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
        //
        //        }
        
    }
    
    
    func addOrientation()  {
        imagesOrientation.append(currentOrientationValue)
    }
    
    func imageRotatedByDegrees(oldImage: UIImage) -> UIImage {
        var degrees:CGFloat = 90.0
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch (orientation) {
        case .portrait:
            degrees = 90.0
        case .landscapeRight:
            degrees = 180.0
        case .landscapeLeft:
            degrees = 0.0
        default:
            degrees = -90.0
        }
        
        
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func capturePhoto(_ exposure : Float, _maxDuration  : Int )  {
        let videoConnection = stillImageOutput!.connection(with: AVMediaType.video)
        if(videoConnection != nil) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.capturedPhotos.append(image)
                    self.backCamera?.setExposureModeCustom(duration: CMTimeMake(1,Int32(_maxDuration)), iso: exposure , completionHandler: {(timestamp:CMTime) -> Void in
                        
                        self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
                        
                        //                        self.imagesCountLabel.text = String(self.selectedPhotosDataCamera.count / 7)
                        if self.expouserCounter == self.exposureValues.count - 1 {
                            self.expouserCounter = 0
                            //SVProgressHUD.dismiss()
                            self.loadingHolderView.isHidden = true
                            self.backCamera?.setExposureModeCustom(duration:CMTimeMake(1,Int32(self.maxDuartion[self.expouserCounter])) , iso: self.exposureValues[self.expouserCounter], completionHandler: nil)
                        }
                        else {
                            self.expouserCounter = self.expouserCounter + 1
                            self.capturePhoto(self.exposureValues[self.expouserCounter], _maxDuration: self.maxDuartion[self.expouserCounter])
                        }
                    })
                }
            })
        }
        
        
        
    }
    
    // MARK: - Exposure camera delegate
    
    func getAllExposures(_ imagesData : [NSData]) {
        selectedPhotosDataCamera = selectedPhotosDataCamera + imagesData
        selectedPhotosDataCamera1 = selectedPhotosDataCamera1 + imagesData
        self.loadingHolderView.isHidden = true
        SVProgressHUD.dismiss()
        print("self.selectedPhotosDataCamera.count", self.selectedPhotosDataCamera.count)
        
        self.imagesCountLabel.text = String(self.selectedPhotosDataCamera1.count / 9)
        print("self.imagesCountLabel.text", self.imagesCountLabel.text)
        //        self.customCameraDoneBtn.isUserInteractionEnabled = true
        //        self.customCameraCancelBtn.isUserInteractionEnabled = true
        //        self.customCameracaptureBtn.isUserInteractionEnabled = true
        
        if (self.selectedPhotosDataCamera.count / 9) >= 1 {
            self.uploadDataToServer()
        }
    }
    
    //MARK:- COLLECTION VIEW DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return campaignMediaList.count
        }
        if collectionView.tag == 3{
            return campaignMediaList.count
        }
        
        else{
            return campaignMediaList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignDetailImageCell", for: indexPath as IndexPath) as! CampaignDetailImageCell
            if campaignMediaList[indexPath.row].type == "p" || campaignMediaList[indexPath.row].type == "P"{
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
                if cell.playButton.isHidden == true {
                    
                    self.viewerHolderView.isHidden = false
                    let indexPath = IndexPath(row: self.currentImageIndex, section: 0)
                    self.viewerCurrentImageIndex = self.currentImageIndex
                    self.viewerCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: false)
                    self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
                    self.viewerText.text = self.campaignMediaList[indexPath.row].comment
                    
                 //   AppUtility.lockOrientation(.all)
                }
            }
            cell.playButton.addTarget(self, action: #selector(viewerVideoPlayClick), for: .touchUpInside)
            cell.playButton.tag = indexPath.row
            
            //self.manageTopHeight((self.campaignMediaList[self.currentImageIndex].height! as NSString).floatValue, (self.campaignMediaList[self.currentImageIndex].width! as NSString).floatValue)
            return cell
        }
        
        
        else  if collectionView.tag == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignDetailViewerCollectionViewCell", for: indexPath) as? CampaignDetailViewerCollectionViewCell
            cell?.viewerScrollView.autoresizesSubviews = true
            cell?.viewerScrollView.isMultipleTouchEnabled = true
            cell?.viewerScrollView.maximumZoomScale = 4.0
            cell?.viewerScrollView.minimumZoomScale = 1.0
            cell?.viewerScrollView.clipsToBounds = true
            cell?.viewerScrollView.delegate = self
            cell?.viewerScrollView.zoomScale = 1.0
            
            if campaignMediaList[indexPath.row].type == "p" {
                cell?.viewerImageView.sd_setShowActivityIndicatorView(true)
                cell?.viewerImageView.sd_setIndicatorStyle(.gray)
                cell?.viewerImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                cell?.viewerPlayButton.isHidden = true
            }
            else {
                cell?.viewerImageView.sd_setShowActivityIndicatorView(true)
                cell?.viewerImageView.sd_setIndicatorStyle(.gray)
                cell?.viewerImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(campaignMediaList[indexPath.row].thumbnail!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                cell?.viewerPlayButton.isHidden = false
            }
            cell?.viewerPlayButton.addTarget(self, action: #selector(viewerVideoPlayClick), for: .touchUpInside)
            cell?.viewerPlayButton.tag = indexPath.row
            
            cell?.viewerImageView.actionBlock {
                self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
                self.viewerText.text = self.campaignMediaList[indexPath.row].comment
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
        } else{
            
            imagesUrl = [URL]()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampaignDetail", for: indexPath as IndexPath) as! CampaignDetailCollectionViewCell
            cell.countLabel.text = String(format: "%d", indexPath.row + 1)
            
            
            if campaignMediaList[indexPath.row].type == "p" || campaignMediaList[indexPath.row].type == "P"{
                imagesUrl.append(URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)")!)
                cell.topImageView.sd_setShowActivityIndicatorView(true)
                cell.topImageView.sd_setIndicatorStyle(.gray)
                cell.topImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
                cell.playButton.isHidden = true
            }
            else {
                imagesUrl.append(URL(string: "\(APIs.KVIDEOBASETHUMBNAILURL)\(campaignMediaList[indexPath.row].media!)")!)
                cell.topImageView.sd_setShowActivityIndicatorView(true)
                cell.topImageView.sd_setIndicatorStyle(.gray)
                cell.topImageView.sd_setImage(with: URL(string: "\(APIs.KVIDEOBASEURL)\(campaignMediaList[indexPath.row].thumbnail!)"), placeholderImage: UIImage(named: "DummySmallVideo"))
                cell.playButton.isHidden = false
            }
            
            
            if rowsWhichAreChecked.contains(indexPath.row) {
                cell.checkBoxImg.image =  #imageLiteral(resourceName: "RadioOn")
                cell.topImageView.addBorderlayerThick(solidPinkBorderColor)
                // selectedImages.append(cell.topImageView.image!)
            }
            else {
                cell.checkBoxImg.image =  #imageLiteral(resourceName: "RadioOff")
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
        topViewHeightConstraint.constant = 0
        print(backendHeight * widthRatio)
        topViewHeightConstraint.constant = CGFloat(backendHeight * widthRatio)
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 1 || collectionView.tag == 11 {
            return 0
        }
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //self.dataCollectionView.reloadData()
        // self.imageScroller.reloadData()
        if collectionView.tag == 1 {
            let width  = UIScreen.main.bounds.width
            let height = imageScroller.frame.size.height
            // let height = self.getTopHeight((self.campaignMediaList[self.currentImageIndex].height! as NSString).floatValue, (self.campaignMediaList[self.currentImageIndex].width! as NSString).floatValue)
            return CGSize(width: width, height: height)
        }
        if collectionView == viewerCollectionView {
            let width  = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            return CGSize(width: width, height: height)
        }
        let width  = dataCollectionView.frame.size.height
        let height = dataCollectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 11 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 11 {
            return 1
        }
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        let offset = imageScroller?.contentOffset;
        let width  = imageScroller?.bounds.size.width;
        
        let index     = round(offset!.x / width!);
        let newOffset = CGPoint(x: index * size.width, y: offset!.y)
        
        imageScroller?.setContentOffset(newOffset, animated: false)
        
        
        coordinator.animate(alongsideTransition: { (context) in
            self.imageScroller?.reloadData()
            self.imageScroller?.setContentOffset(newOffset, animated: false)
        }, completion: nil)
        
        /////
        
        
        let offsetViewer = viewerCollectionView?.contentOffset;
        let widthViewer  = viewerCollectionView?.bounds.size.width;
        
        let indexViewer     = round(offsetViewer!.x / widthViewer!);
        let newOffsetViewer = CGPoint(x: indexViewer * size.width, y: offsetViewer!.y)
        
        viewerCollectionView?.setContentOffset(newOffsetViewer, animated: false)
        
        
        coordinator.animate(alongsideTransition: { (context) in
            self.viewerCollectionView?.reloadData()
            self.viewerCollectionView?.setContentOffset(newOffsetViewer, animated: false)
        }, completion: nil)
        
        
        convertOrientation()
    }
    
    func convertOrientation()  {
        
        //        if UIDevice.current.orientation.isLandscape {
        //            tabBottomBar.image = #imageLiteral(resourceName: "bootom_bar_Landscape")
        //
        //
        //        } else {
        //            tabBottomBar.image = #imageLiteral(resourceName: "bootom_bar")
        //
        //
        //        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageScroller.collectionViewLayout.invalidateLayout()
        viewerCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for v: UIView in scrollView.subviews {
            if (v is UIImageView) {
                return v
            }
        }
        return nil
    }
    
    
    @objc func longTapImage(_ sender: UIGestureRecognizer){
        imageSelectionType = "selection"
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            
            if rowsWhichAreChecked.contains(sender.view?.tag as Any) {
                rowsWhichAreChecked.remove(sender.view?.tag as Any)
                selectedImageIds.remove(self.campaignMediaList[(sender.view?.tag)!].internalIdentifier!)
            }
            
            else {
                rowsWhichAreChecked.add(sender.view?.tag as Any)
                selectedImageIds.add(self.campaignMediaList[(sender.view?.tag)!].internalIdentifier!)
            }
            
            self.dataCollectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            return
        }
        
        if imageSelectionType == "selection" {
            if rowsWhichAreChecked.contains(indexPath.row as Any) {
                rowsWhichAreChecked.remove(indexPath.row as Any)
                selectedImageIds.remove(self.campaignMediaList[(indexPath.row)].internalIdentifier!)
            }
            
            else
            {
                rowsWhichAreChecked.add(indexPath.row as Any)
                selectedImageIds.add(self.campaignMediaList[(indexPath.row)].internalIdentifier!)
            }
            
            self.dataCollectionView.reloadData()
        }
        else {
            self.currentImageIndex = indexPath.row
            self.photoCommentTextView.text = ""
            CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[indexPath.row].internalIdentifier!
            imageScroller.scrollToItem(at: indexPath, at: [.centeredHorizontally,.centeredVertically], animated: true)
            //
            
            //  self.manageTopHeight((self.campaignMediaList[indexPath.row].height! as NSString).floatValue, (self.campaignMediaList[indexPath.row].width! as NSString).floatValue)
            viewerCollectionView.reloadItems(at: [indexPath])
            imageScroller.reloadItems(at: [indexPath])
            self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
            self.viewerText.text = self.campaignMediaList[indexPath.row].comment
            
            fetchSubCategoryIds(indexPath: indexPath.row)
        }
    }
    
    func fetchSubCategoryIds(indexPath:Int) {
        //self.modelUdpateSubCategory.removeAll()
        modelUdpate.removeAll()
        if self.campaignMediaList[indexPath].campaignDetailaddOnServices!.count > 0 {
            for i in 0..<self.campaignMediaList[indexPath].campaignDetailaddOnServices!.count {
                let indexModelData = self.campaignMediaList[indexPath].campaignDetailaddOnServices![i]
                let modelUpdatew = SubCategorySelectedModel(subcategoryId:indexModelData.serviceId, selectedQuantity: indexModelData.qty,selectedQuantityName: "\(indexModelData.subCategoryName ?? "")")
                modelUdpate.append(modelUpdatew)
            }
        }
        slectedServicestableview.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        if viewerCollectionView.isHidden == false {
            if scrollView == viewerCollectionView {
                var visibleRect = CGRect()
                visibleRect.origin = viewerCollectionView.contentOffset
                visibleRect.size = viewerCollectionView.bounds.size
                
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                
                guard let indexPath = viewerCollectionView.indexPathForItem(at: visiblePoint) else { return }
                if indexPath.row == 0 {
                    
                }
                else {
                    let backIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
                    viewerCollectionView.reloadItems(at: [backIndexPath])
                }
            }
        }
        
        
        var visibleRect = CGRect()
        var visibleRectViewer = CGRect()
        
        if (scrollView.viewWithTag(1) != nil) {
            visibleRect.origin = imageScroller.contentOffset
            visibleRect.size = imageScroller.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = imageScroller.indexPathForItem(at: visiblePoint) else { return }
            self.currentImageIndex = indexPath.row
            CompletedCampaignStore.sharedInstance.CompletedcampaignImageId = self.campaignMediaList[indexPath.row].internalIdentifier!
            self.photoCommentTextView.text = self.campaignMediaList[indexPath.row].comment
            //// FOR LARGE VIEWER
            
            
            
            visibleRectViewer.origin = viewerCollectionView.contentOffset
            visibleRectViewer.size = viewerCollectionView.bounds.size
            
            let visiblePointViewer = CGPoint(x: visibleRectViewer.midX, y: visibleRectViewer.midY)
            guard let indexPathViewer = viewerCollectionView.indexPathForItem(at: visiblePointViewer) else { return }
            viewerCurrentImageIndex = indexPathViewer.row
            self.viewerText.text = self.campaignMediaList[indexPathViewer.row].comment
            
            imageScroller.reloadItems(at: [indexPath])
        }
        else {
            visibleRect.origin = viewerCollectionView.contentOffset
            visibleRect.size = viewerCollectionView.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = viewerCollectionView.indexPathForItem(at: visiblePoint) else { return }
            viewerCurrentImageIndex = indexPath.row
            self.viewerText.text = self.campaignMediaList[indexPath.row].comment
        }
        
    }
    
    @IBAction func editPhotoClick(_ sender: Any) {
        
        if campaignMediaList[currentImageIndex].type == "p" || campaignMediaList[currentImageIndex].type == "P" {
            let tempImage = UIImageView()
            tempImage.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(campaignMediaList[currentImageIndex].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
            CompletedCampaignStore.sharedInstance.mediaImage = tempImage.image!
            
            
            CompletedCampaignStore.sharedInstance.imageHeight = (campaignMediaList[currentImageIndex].height! as NSString).floatValue
            
            CompletedCampaignStore.sharedInstance.imageWidth = (campaignMediaList[currentImageIndex].width! as NSString).floatValue
            CompletedCampaignStore.sharedInstance.mediaComment = campaignMediaList[currentImageIndex].comment!
            
            
            print("CompletedCampaignStore.sharedInstance.selectedCategoryId = Done ",CompletedCampaignStore.sharedInstance.selectedCategoryId)
            navigationController?.pushViewController(RevisePhotoViewController.control, animated: true)
        }
        
        
        
        
        
        
        
        
        
        //        if campaignMediaList[currentImageIndex].type == "p" || campaignMediaList[currentImageIndex].type == "P"{
        //            CompletedCampaignStore.sharedInstance.mediaComment = campaignMediaList[currentImageIndex].comment!
        //            navigationController?.pushViewController(RevisePhotoViewController.control, animated: true)
        //        }
        //        else {
        //            SVProgressHUD.showError(withStatus: Constants.NOTALLOWEDFORVIDEOS_ERROR)
        //        }
        
        
        
    }
    
    @IBAction func markButtonClick(_ sender: Any) {
        if rowsWhichAreChecked.contains(currentImageIndex) {
            rowsWhichAreChecked.remove(currentImageIndex)
            selectedImageIds.remove(self.campaignMediaList[self.currentImageIndex].internalIdentifier!)
        }
        else {
            rowsWhichAreChecked.add(currentImageIndex)
            selectedImageIds.add(self.campaignMediaList[self.currentImageIndex].internalIdentifier!)
        }
        
        self.dataCollectionView.reloadData()
        self.imageScroller.reloadData()
    }
    
    @IBAction func deletePhotoClick(_ sender: Any) {
        UIAlertController.showAlert("Alert!", message: "Do you want to delete this media file", buttons: ["No", "Yes"], completion: { (alert, index) in
            if index == 0 {
                
            }
            else {
                if  self.campaignMediaList.count == 0 {
                    SVProgressHUD.showError(withStatus: "No image to delete")
                }
                else {
                    var idString = String()
                    if self.selectedImageIds.count == 0 {
                        idString = self.campaignMediaList[self.currentImageIndex].internalIdentifier!
                    }
                    else {
                        idString = (self.selectedImageIds.map{String(describing: $0)}).joined(separator: ",")
                    }
                    CreateCampaignStore.sharedInstance.deleteImage(idString) { (response) in
                        print(response as Any)
                        let responseData = response?["response"] as! NSDictionary
                        self.imageSelectionType = "normal"
                        if responseData["status"] as! String == "1" {
                            self.selectedImageIds = NSMutableArray()
                            self.rowsWhichAreChecked = NSMutableArray()
                            SVProgressHUD.show(withStatus: "Deleted successfully")
                            self.getCampaignDetails()
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func playButtonClick(_ sender: UIButton) {
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
    
    @objc func campaignHistory(sender: UIButton){
        //        if collectionDataType == "Photo" {
        //            navigationController?.pushViewController(PhotoDetailViewController.control, animated: true)
        //        }
        //        else {
        //            navigationController?.pushViewController(VideoDetailViewController.control, animated: true)
        //        }
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL as NSURL
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
        }
        return image
    }
    
    func dataFromPath(path: String) -> NSData? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        let data = UIImagePNGRepresentation(image!)
        return data as NSData?
    }
    
    // MARK: - OPAL Delegates for custom gallery image picker
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        presentedViewController?.dismiss(animated: true, completion: {
            self.processGaleryImages(images)
        })
    }
    
    func processGaleryImages(_ images: [UIImage])  {
        DispatchQueue.main.async {
            var tempIntCount = Int()
            tempIntCount = 0
            
            self.selectedPhotosData = [Data]()
            for image in images {
                tempIntCount  = tempIntCount + 1
                SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.selectedPhotosData.count)), status: "Processing")
                SVProgressHUD.setDefaultMaskType(.clear)
                self.selectedPhotosData.append((image.compressTo(2)! as NSData) as Data)
                print(images.count)
                print(self.selectedPhotosData.count)
                if self.selectedPhotosData.count == images.count {
                    SVProgressHUD.dismiss()
                    self.galleryImagesArray.removeAll()
                    CreateCampaignStore.sharedInstance.sendCampaignData(self.selectedPhotosData as NSArray, self.selectedPhotosDataCamera  as NSArray, self.selectedVideoData as NSArray , UserStore.sharedInstance.userInfo, "", "", "", "", "", "", "", "", "", String(NewCampaignDetailStore.sharedInstance.createdCampaignId),  "") { (response) in
                        let responseData = response?["response"] as! NSDictionary
                        if responseData["status"] as! String == "1" {
                            
                            //-- Saved to photo library
                            print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
                            
                            //                            if self.selectedPhotosData.count != 0 {
                            //                                for photoData in 0..<self.selectedPhotosData.count {
                            //                                    guard let image = UIImage(data: self.selectedPhotosData[photoData] as Data) else { return }
                            //                                    print(image)
                            //                                    CustomPhotoAlbum.shared.save(image: image)
                            //                                }
                            //                            }
                            //
                            //                            if self.selectedPhotosDataCamera.count != 0 {
                            //                                for cameraData in 0..<self.selectedPhotosDataCamera.count {
                            //                                    guard let image = UIImage(data: self.selectedPhotosDataCamera[cameraData] as Data) else { return }
                            //                                    print(image)
                            //                                    CustomPhotoAlbum.shared.save(image: image)
                            //                                }
                            //                            }
                            
                            //                            if self.selectedVideoData.count != 0 {
                            //                                for videoData in 0..<self.selectedVideoData.count {
                            //                                    //guard let image = UIImage(data: self.selectedVideoData[cameraData]) else { return }
                            //                                    print(self.selectedVideoData[videoData])
                            //                                    CustomPhotoAlbum.sharedInstance.save(image: self.selectedVideoData[videoData])
                            //                                }
                            //                            }
                            
                            // SVProgressHUD.showSuccess(withStatus: "Data uploaded successfully")
                            //SVProgressHUD.show()
                            self.getCampaignDetails()
                        } else {
                            SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                        }}}}}
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Image picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated:true, completion: nil) //5
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var imagesArray = [UIImage]()
            imagesArray.append(chosenImage)
            saveimageToServer(imagesArray as NSArray, picker.sourceType)
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.PHOTOONLY_ERROR)
        }
    }
    
    func saveimageToServer(_ totalImages: NSArray, _ sourceType: UIImagePickerControllerSourceType) {
        if totalImages.count == 0   {
            SVProgressHUD.showError(withStatus: "please select campaign name and images or videos")
        }  else {
            selectedPhotosData = [Data]()
            let selectedVideoData = [Data]()
            // CONVERT IMAGES TO DATA
            
            
            if sourceType == .camera {
                if totalImages.count != 0 {
                    for indexValue in  totalImages {
                        let data:NSData = UIImagePNGRepresentation(indexValue as! UIImage )! as Data as NSData
                        selectedPhotosDataCamera.append(data)
                        selectedPhotosDataCamera1.append(data)
                    }
                }
            }
            else {
                if totalImages.count != 0 {
                    for indexValue in  totalImages {
                        let data:NSData = UIImagePNGRepresentation(indexValue as! UIImage )! as Data as NSData
                        selectedPhotosData.append(data as Data as Data)
                        selectedPhotosData1.append(data as Data as Data)
                    }
                }
            }
            CreateCampaignStore.sharedInstance.sendCampaignData(selectedPhotosData as NSArray, selectedPhotosDataCamera  as NSArray, selectedVideoData as NSArray , UserStore.sharedInstance.userInfo, "", "", "", "", "", "", "", "", "", String(NewCampaignDetailStore.sharedInstance.createdCampaignId),  "") { (response) in
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    
                    
                    //-- Saved to photo library
                    print("UserStore.sharedInstance.title", UserStore.sharedInstance.title)
                    
                    //                    if self.selectedPhotosData.count != 0 {
                    //                        for photoData in 0..<self.selectedPhotosData.count {
                    //                            guard let image = UIImage(data: self.selectedPhotosData[photoData] as Data) else { return }
                    //                            print(image)
                    //                            CustomPhotoAlbum.shared.save(image: image)
                    //                        }
                    //                    }
                    //
                    //                    if self.selectedPhotosDataCamera.count != 0 {
                    //                        for cameraData in 0..<self.selectedPhotosDataCamera.count {
                    //                            guard let image = UIImage(data: self.selectedPhotosDataCamera[cameraData] as Data) else { return }
                    //                            print(image)
                    //                            CustomPhotoAlbum.shared.save(image: image)
                    //                        }
                    //                    }
                    //
                    //                    if self.selectedVideoData.count != 0 {
                    //                        for videoData in 0..<self.selectedVideoData.count {
                    //                            //guard let image = UIImage(data: self.selectedVideoData[cameraData]) else { return }
                    //                            print(self.selectedVideoData[videoData])
                    //                            CustomPhotoAlbum.sharedInstance.save(image: self.selectedVideoData[videoData])
                    //                        }
                    //                    }
                    
                    // SVProgressHUD.showSuccess(withStatus: "Data uploaded successfully")
                    //SVProgressHUD.show()
                    self.getCampaignDetails()
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
}
@available(iOS 13.0, *)
extension CampaignDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let alert = UIAlertController(title: "Quantity", message: "Enter a Quantity", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { [self] (q) in
            q.delegate = self
            q.keyboardType = .numberPad
            textField.text = qty
            // textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self, weak alert] (_) in
            let qt = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.Quantity.text = qt?.text
            qt?.delegate = self
            
            CreditApiStore.sharedInstance.updateCampaignQuantity(campaignIdd, Quantity.text!)
            //  print("Text field: \(textField.text)")
            self.getCampaignDetails()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
