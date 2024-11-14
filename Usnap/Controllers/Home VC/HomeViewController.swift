//
//  HomeViewController.swift
//  Usnap
//
//  Created by CSPC141 on 02/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController

import Photos
import PhotosUI
import ImagePicker
import AVFoundation
import AVKit
import CTAssetsPickerController
import MobileCoreServices

import Crashlytics
import OpalImagePicker
import BSImageView
import BSImagePicker
import DKImagePickerController
import Alamofire
import StoreKit


//import CameraManager
//https://github.com/jonhull/GradientSlider/tree/master/GradientSlider

var angle:CGFloat = .pi/2
@available(iOS 13.0, *)
class HomeViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, TopBarDelegate, UISearchBarDelegate, campaignFilterDelegate, completionDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, ImagePickerDelegate, CTAssetsPickerControllerDelegate, pickerChangedvalueDelegate, BWWalkthroughViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GMSAutocompleteViewControllerDelegate, OpalImagePickerControllerDelegate, ExposureCustomCameraDelegate {
    
    func CampaignFilterData(_ data : NSDictionary, _ clearClick: String) {
        if clearClick == "Yes" {
            newViewApprenece = "push"
            fetchCampaignList()
        } else {
            fetchCampaignListWithFilters(UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole, data["campaignCategoryId"] as! String, data["status"] as! String, data["campaignName"] as! String, data["startDate"] as! String, data["endDate"] as! String, data["retoucherName"] as! String, data["staffMemberDetail"] as! String)
        }
    }
    
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        staffButton.setTitle(pickerValue, for: .normal)
        //selectedStaffName = (pickerValue as NSString) as String
        selectedStaffId = valueId
    }
    

    
    var placesClient: GMSPlacesClient!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    @IBOutlet var loaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet var loaderWidthConstraint: NSLayoutConstraint!
    @IBOutlet var loaderHolderView: UIView!
    @IBOutlet var loaderImageView: UIImageView!
    @IBOutlet var uploadCampaignHolderView: UIView!
    @IBOutlet var campTitleTF: UITextField!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var staffButton: UIButton!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var listView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var gallaryButton: UIButton!
    @IBOutlet var imagesCountLabel: UILabel!
    @IBOutlet var pickerHolder: UIView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var customCameraView: UIView!
    @IBOutlet var customCameraHolderView: UIView!
    @IBOutlet var customCameracaptureBtn: UIButton!
    @IBOutlet var customCameraCancelBtn: UIButton!
    @IBOutlet var customCameraDoneBtn: UIButton!
    
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
  
//    @IBOutlet weak var hideView: UIView!
    
    
    
    @IBOutlet weak var btnSelectCategory: UIButton!
    
    @IBAction func btnSelectCategory(_ sender: UIButton) {
        
        DropDownHandler.shared.showDropDownWithItems(btnSelectCategory, campaignCategoriesName)
        DropDownHandler.shared.itemPickedBlock = { (index, item) in
            self.btnSelectCategory.setTitle(item, for: .normal)
            if let selectedRowIndex = self.campaignCategories.firstIndex(where: { $0.category_name == item }) {
                self.selectedCampaignCategoriesId = self.campaignCategories[selectedRowIndex].id ?? ""
                print("Selected Row",self.campaignCategories[selectedRowIndex].category_name as Any,self.campaignCategories[selectedRowIndex].id as Any)
            }
        }
    }
    
    func fetchAvailableCampaignCategories() {
        campaignCategoriesName.removeAll()
        campaignCategories.removeAll()
        CreditApiStore.sharedInstance.getCampaignCategories { response in
            self.campaignCategories = response?.categoryResponse?.categoryData?.categories ?? []
            for i in 0..<self.campaignCategories.count {
                self.campaignCategoriesName.append(self.campaignCategories[i].category_name ?? "")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    var campaignCategories = [Categories]()
    var campaignCategoriesName = [""]
    var selectedCampaignCategoriesId = ""
    
    var selectedStaffId = String()
    var campaignListResponse = [CampaignListresult]()
    var searchArray = [CampaignListresult]()
    var modelBackUp = [CampaignListresult]()
    var picker = UIImagePickerController()
    var selectedCampaignID = String()
    var imagePickerController = ImagePickerController()
    let imagePicker = ImagePickerController()
    
    var selectedPhotosData = [NSData]()
    var selectedPhotosDataCamera = [NSData]()
    var selectedVideosData = [NSData]()
    var userOldCampaigns = [NewCampaignDatacampaign]()
    
    var exposureValues  = [Float]()
    var minDuration  = [Float]()
    var maxDuartion  = [Int]()
    
    var expouserCounter = Int()
    
    var newViewApprenece = String()
    var capturedPhotos = [UIImage]()
    var loaderImage = UIImage()
    
    
    var imageStrBase = String()
    var imagesOrientation  = [String]()
    var currentOrientationValue  = String()
    var imagesArray = [UIImage]()
    
    //var session: AVCaptureSession?
    //var stillImageOutput: AVCapturePhotoOutput?
    //var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let cameraManager = CameraManager()
    var arrayDKAssets = [DKAsset]()
    var arrayImages = [UIImage]()
    
    var openPics = String()
    var galleryExistingPics = String()
    var containCampaign = String()
    var selectedPhotosDataCamera1 = [NSData]()
    //fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideView.width = 2.0
        centeredNavBarImageView()
        
        navigationController?.navigationBar.tintColor = .black

        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
            
      
        
        listView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        topBar.delegate = self
        addToolBar(textField: searchBar)
        searchBar.text = ""
        placesClient = GMSPlacesClient.shared()
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        //nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
        //nc.removeObserver(self)
        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_CAMPAIGN),
                       object:nil, queue:nil,
                       using:catchNotification_PickerView)
        
        pickerView.backgroundColor = UIColor.white
        pickerView.setValue(solidPinkBorderColor, forKeyPath: "textColor")
        
        customCameraHolderView.isHidden = true
        
        newViewApprenece = "push"
        nc.addObserver(self, selector: #selector(catchNotification_NotificationHandler), name: Notification.Name(rawValue:ConstantsKeys.HANDLENOTIFICATION_KEY), object: nil)
        
        //let nc1 = NotificationCenter.default
        //nc1.addObserver(self, selector: #selector(catchNotification_PickerViewe3erfr), name: Notification.Name(ConstantsKeys.HANDLENOTIFICATION_KEY), object: nil)
        
        addressLbl.actionBlock {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.present(autocompleteController, animated: true, completion: nil)
            //let autocompleteController = GMSAutocompleteViewController()
            //autocompleteController.delegate = self
            // Specify the place data types to return.
            //let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            //UInt(GMSPlaceField.placeID.rawValue))!
            //autocompleteController.placeFields = fields
            //Specify a filter.
            //let filter = GMSAutocompleteFilter()
            //filter.type = .address
            //autocompleteController.autocompleteFilter = filter
            // Display the autocomplete view controller.
            //self.present(autocompleteController, animated: true, completion: nil)
        }
        checkForLocalCamp()
        // setCustomExposerValues()
        fetchAvailableCampaignCategories()
    }
    
    func setCustomExposerValues()  {
        if let device = AVCaptureDevice.default(for:AVMediaType.video) {
            //            print(device.minExposureTargetBias)
            //            print(device.maxExposureTargetBias)
            //            print(device.exposureDuration)
            //            print(device.activeFormat.minISO)
            //            print(device.activeFormat.maxISO)
            //            print(device.activeFormat.minExposureDuration.value)
            //            print(device.activeFormat.maxExposureDuration.value)
            
            // Calculate Exposer values (ISO)
            exposureValues  = [Float]()
            var minExposerValue = Float()
            var maxExposerValue = Float()
            minExposerValue = device.activeFormat.minISO
            maxExposerValue = device.activeFormat.maxISO
            
            var differenceValue = Float()
            differenceValue = maxExposerValue - minExposerValue
            //print(differenceValue)
            differenceValue =  fabs(differenceValue)
            //print(differenceValue)
            differenceValue = differenceValue / 2
            differenceValue = differenceValue / 3
            exposureValues.append(Float(minExposerValue))
            
            for _ in 0...5 {
                exposureValues.append(exposureValues.last! + differenceValue)
            }
            
            print(exposureValues)
            // Calculate Duration values (ISO)
            maxDuartion  = [Int]()
            var minDurationValue = Int()
            var maxDurationValue = Int()
            minDurationValue = Int(device.activeFormat.minExposureDuration.value)
            maxDurationValue = Int(device.activeFormat.maxExposureDuration.value)
            
            var differenceValueDuration = Int()
            differenceValueDuration = maxDurationValue - minDurationValue
            print(differenceValueDuration)
            differenceValueDuration =  Int(fabs(Double(differenceValueDuration)))
            print(differenceValueDuration)
            differenceValueDuration = differenceValueDuration / 2
            differenceValueDuration = differenceValueDuration / 3
            maxDuartion.append(2)
            //maxDuartion.append(Int(device.activeFormat.maxExposureDuration.value))
            for i in 0...5 {
                //maxDuartion.append(25)
                if i == 0 {
                    maxDuartion.append((maxDuartion.last! - 1) + differenceValueDuration)
                }
                else {
                    maxDuartion.append(maxDuartion.last!  + differenceValueDuration)
                }
                
            }
            print(maxDuartion)
            
            maxDuartion = maxDuartion.reversed()
            
            print(exposureValues)
            print(maxDuartion)
            exposureValues.insert(exposureValues[3], at: 0)
            exposureValues.remove(at: 4)
            maxDuartion.insert(maxDuartion[3], at: 0)
            maxDuartion.remove(at: 4)
            print(exposureValues)
            print(maxDuartion)
        }
    }
  /*
   {
       
       // let control = StaffInvoiceFIlterPopUpViewController.control as! StaffInvoiceFIlterPopUpViewController
       // control.delegate = self
       // UIApplication.visibleViewController.present(control, animated: false, completion: nil)
       
       newViewApprenece = "present"
       
       let control = CampaignFilterViewController.control as! CampaignFilterViewController
       control.delegate = self
       UIApplication.visibleViewController.present(control, animated: false, completion: nil)
       
   }
   
   */
    
    
    
    
    @IBAction func actionFilterData(_ sender: Any) {
        
        // let control = StaffInvoiceFIlterPopUpViewController.control as! StaffInvoiceFIlterPopUpViewController
        // control.delegate = self
        // UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
        newViewApprenece = "present"
        
        let control = CampaignFilterViewController.control as! CampaignFilterViewController
        control.delegate = self
        self.present(control, animated: false, completion: nil)
        
    }
    
    
    
    
    @IBAction func actionWriteData(_ sender: Any) {
        selectedPhotosData.removeAll()
        selectedVideosData.removeAll()
        selectedPhotosDataCamera.removeAll()
        
        //        NewCampaignDetailStore.sharedInstance.selectedPics = self.selectedPhotosData
        //        NewCampaignDetailStore.sharedInstance.selectedVids = self.selectedVideosData
        //        NewCampaignDetailStore.sharedInstance.selectedPicsCamera = self.selectedPhotosDataCamera
        
        
        
        self.openPics = ""
        self.uploadCampaignHolderView.isHidden = false
        
        //        let control = CrateCampaignPopUpViewController.control as! CrateCampaignPopUpViewController
        //        control.delegate = self
        //        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
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
    
//    @available(iOS 13.0, *)
//    func setNavigation() {
//        self.navigationItem.title = MenuClassViewController.menus[0]
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "TopBarMenu"), style: .plain, target: self, action: #selector(handleMenu))
//        self.navigationItem.leftBarButtonItem?.tintColor = .gray
//    }
//
//
//    @objc func handleMenu() {
//        delegate?.menuHandler(index: -1)
//    }
//
    
    
    func setUI() {
        addressLbl.addBorder(pinkBorderColor)
        campTitleTF.addBorder(pinkBorderColor)
        if UserStore.sharedInstance.userRole == "3" {
            staffButton.isUserInteractionEnabled = true
            staffButton.backgroundColor = UIColor.white
        } else {
            staffButton.isUserInteractionEnabled = false
            staffButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func setAfterUI() {
        addressLbl.text = "Address"
        addressLbl.textColor = UIColor.lightGray
        campTitleTF.text = ""
        staffButton.setTitle("Select Staff Member", for: .normal)
        btnSelectCategory.setTitle("Select Service", for: .normal)
        selectedCampaignCategoriesId = ""
    }
    
    @objc func catchNotification_PickerViewe3erfr(notification:Notification) -> Void {
    }
    
    func setTutorial()  {
        DispatchQueue.main.async {
            AppUtility.lockOrientation(.all)
            let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
            let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
            let page_one = stb.instantiateViewController(withIdentifier: "walk1")
            let page_two = stb.instantiateViewController(withIdentifier: "walk2")
            let page_three = stb.instantiateViewController(withIdentifier: "walk3")
            walkthrough.closeButton?.setTitleColor(.red, for: .normal)
            walkthrough.closeButton?.isHidden = false
            //Attach the pages to the master
            walkthrough.delegate = self
            walkthrough.add(viewController:page_one)
            walkthrough.add(viewController:page_two)
            walkthrough.add(viewController:page_three)
            self.present(walkthrough, animated: true, completion: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.dismiss(animated: true, completion: nil)
        self.imagesCountLabel.text = String(self.selectedPhotosDataCamera.count / 9)
        self.setCustomCamera()
    }
    
    @objc func catchNotification_NotificationHandler(notification:Notification) -> Void {
        //NewCampaignDetailStore.sharedInstance.createdCampaignId = 32
        //self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imagesOrientation.removeAll()
        AppUtility.lockOrientation(.portrait)
        fetchCampaignData()
        if newViewApprenece == "push" {
            searchBar.text = ""
            fetchCampaignList()
        } else{
            
        }
    }
    
    //var backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var backCamera = AVCaptureDevice.default(for: .video)
    
    func setCustomCamera()  {
        customCameraHolderView.isHidden = false
        self.customCameraView.backgroundColor = UIColor.clear
        ExposureCustomCamera.shared.beginCamera(self.customCameraView, self)
        //cameraManager.resumeCaptureSession()
        //cameraManager.cameraOutputQuality = .high
        //cameraManager.shouldEnableTapToFocus = false
        //cameraManager.shouldEnableExposure = false
        //cameraManager.writeFilesToPhoneLibrary = false
        //cameraManager.shouldRespondToOrientationChanges = false
        //cameraManager.addPreviewLayerToView(customCameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        //cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
        //let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
        //self?.present(alertController, animated: true, completion: nil)
        //}
        //return
        //session = AVCaptureSession()
        //session!.sessionPreset = AVCaptureSession.Preset.photo
        //do {
        //try backCamera?.lockForConfiguration()
        //}
        //catch let error1 as NSError {
        //print(error1.localizedDescription)
        //}
        //backCamera?.exposureMode = .custom
        //print(maxDuartion)
        //print(exposureValues)
        //backCamera?.setExposureTargetBias(Float(maxDuartion[0]), completionHandler: nil)
        //backCamera?.setExposureTargetBias(exposureValues[0], completionHandler: { (timestamp:CMTime) -> Void in
        //})
        //backCamera?.setExposureModeCustom(duration: CMTimeMake(1,Int32(Int(maxDuartion[0]))), iso: exposureValues[0] , completionHandler: {(timestamp:CMTime) -> Void in
        //})
        //backCamera?.setExposureModeCustom(duration: CMTimeMake(1,150), iso: 450 , completionHandler: {(timestamp:CMTime) -> Void in
        //})
        //backCamera?.isVideoHDREnabled = true
        //var error: NSError?
        //var input: AVCaptureDeviceInput!
        //do {
        //input = try AVCaptureDeviceInput(device: backCamera!)
        //} catch let error1 as NSError {
        //error = error1
        //input = nil
        //print(error!.localizedDescription)
        //}
        //if error == nil && session!.canAddInput(input) {
        //session!.addInput(input)
        //stillImageOutput = AVCaptureStillImageOutput()
        //stillImageOutput?.isHighResolutionStillImageOutputEnabled = true
        //stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        //if session!.canAddOutput(stillImageOutput!) {
        //session!.addOutput(stillImageOutput!)
        //videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        //videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        //customCameraView.layer.addSublayer(videoPreviewLayer!)
        //videoPreviewLayer!.frame = customCameraView.bounds
        //session!.startRunning()
        // Configure the Live Preview here...
        //}
        // The remainder of the session setup will go here...
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        if customCameraHolderView.isHidden == true {
        //
        //        }
        //        else {
        //          videoPreviewLayer!.frame = customCameraView.bounds
        //        }
        //
        setUI()
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
    }
    
    func fetchCampaignData() {
        print("fetchCampaignData calling")
        CreateCampaignStore.sharedInstance.getDataForNewCampaign(UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole) { (response) in
            if response?.newCampaignDataresponse?.status == "1" {
                self.userOldCampaigns = (response?.newCampaignDataresponse?.newCampaignDataresult?.newCampaignDatacampaign)!
                MiscDetailStore.sharedInstance.staffMembers = (response?.newCampaignDataresponse?.newCampaignDataresult?.newCampaignDatastaffMembers)!
            }  else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func catchNotification_PickerView(notification:Notification) -> Void {
        NotificationCenter.default.removeObserver(self)
        guard let userInfo = notification.userInfo,
              let _  = userInfo["selectedValue"] as? String else {
            return
        }
        //selectCampaignButton.setTitle(selectedValue, for: .normal)
        //selectedCampaignID = userInfo["SelectedIndex"]! as! String
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        //AppUtility.lockOrientation(.all)
        session?.stopRunning()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc = sb.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        if vc != nil {
            vc = nil
        }
        // NotificationCenter.default.removeObserver(self)
        // let nc = NotificationCenter.default
        // nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
    }
    
    
    //    func catchNotification_Filter(notification:Notification) -> Void {
    //        NotificationCenter.default.removeObserver(self)
    //     userInfo: ["campaignCategoryId":selectCategoryButton.currentTitle!, "campaignName": campaignNameTF.text!, "retoucherName" : retoucherNameTf.text!, "status" : statusButtonTf.currentTitle!, "campaignTitle" : campaignTitleTF.text!, "staffMemberDetail" : staffMemberName.text!])
    //    }
    
    
    
    
    //getCampaignListWITHFILTERS
    
    
    func fetchCampaignListWithFilters(_ user_id: String, _ user_role: String, _ category: String, _ status: String, _ title: String, _ strdate: String, _ enddate: String, _ retoucher_name: String, _ staff_name: String)  {
        PopUpApiStore.sharedInstance.getCampaignListWITHFILTERS(user_id, user_role, category, status, title, strdate, enddate, retoucher_name, staff_name) { (response) in
            if response?.campaignListresponse?.status == "1" {
                
                if response?.campaignListresponse?.campaignListresult?.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                } else {
                    self.campaignListResponse = (response?.campaignListresponse?.campaignListresult)!
                    self.modelBackUp = self.campaignListResponse
                    self.listView.reloadData()
                }
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func fetchCampaignList()  {
        print("fetchCampaignList")
        CampaignStore.sharedInstance.getCampaignList(UserStore.sharedInstance.userInfo) { (response) in
            if response?.campaignListresponse?.status == "1" {
                self.campaignListResponse = (response?.campaignListresponse?.campaignListresult)!
                if self.campaignListResponse.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                    self.listView.reloadData()
                } else {
                    self.modelBackUp = self.campaignListResponse
                    self.listView.reloadData()
                }
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func checkForLocalCamp() {
        if UserDefaults.standard.object(forKey: "localCampDetails") != nil {
            let dataDict = UserDefaults.standard.dictionary(forKey: "localCampDetails")
            var messageString = String()
            if dataDict!["title"] as! String == "" {
                messageString = String(format: "%@ %@", dataDict!["address"] as! String, "has not been submitted to the sever yet. Please select an option below.")
            } else {
                messageString = String(format: "%@ %@", dataDict!["title"] as! String, "has not been submitted to the sever yet. Please select an option below.")
            }
            UIAlertController.showAlert("Alert", message: messageString, buttons: ["Delete campaign", "Submit campaign","Remind me later"]) { (alert, index) in
                print(index)
                
                if index == 0 {
                    if UserDefaults.standard.object(forKey: "localCampDetails") != nil {
                        self.removeLocalFiles()
                        UIAlertController.showAlert("Alert", message: String(format: "%@ %@", dataDict!["title"] as! String, "is deleted from local memory"), buttons: ["OK"]) { (alert, value) in
                        }
                    }
                    else {
                    }
                }
                
                else if index == 1 {
                    if NetworkReachabilityManager()!.isReachable {
                        if UserDefaults.standard.object(forKey: "localCampDetails") != nil {
                            self.fetchLocalCampData()
                        }
                    }
                }
                
                else {
                    
                }
                
            }
        }
        
    }
    
    @IBAction func cameraIconClick(_ sender: Any) {
        UIAlertController.showAlert("Upload media in", message: "Choose any option", buttons: ["New Campaign", "Existing Campaign", "Cancel"], completion: { (alert, index) in
            if index == 0 {
                self.openPics = "camera"
                self.containCampaign = "new"
                self.uploadCampaignHolderView.isHidden = false
            } else if index == 1 {
                if self.userOldCampaigns.count == 0 {
                    UIAlertController.showAlert("Alert!", message: "No previous campaign found. Do you want to create a new campaign?", buttons: ["Yes","No"], completion: { (alert, index) in
                        if index == 0 {
                            self.openPics = "camera"
                            self.containCampaign = "new"
                            self.uploadCampaignHolderView.isHidden = false
                        }
                    })
                } else {
                    self.openPics = "camera"
                    self.containCampaign = "existing"
                    self.pickerView.reloadAllComponents()
                    self.pickerHolder.isHidden = false
                }
            } else if index == 2 {
                self.selectedPhotosDataCamera.removeAll()
                self.selectedPhotosData.removeAll()
                self.selectedVideosData.removeAll()
                self.capturedPhotos.removeAll()
            }
        })
        
        
        /*
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
                self.setCameraAccordngToNeed()
            }
        }
        
        else {
            NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
            self.setCameraAccordngToNeed()
        }
        */
    }
    
    func setCameraAccordngToNeed() {
        DispatchQueue.main.async {
            AppUtility.lockOrientation(.portrait)
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                if UserStore.sharedInstance.showTutorialScreens == "show" || UserStore.sharedInstance.showTutorialScreens == "" {
                    self.setTutorial()
                } else {
                    self.imagesCountLabel.text = String(self.selectedPhotosDataCamera.count / 9)
                    self.setCustomCamera()
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        if UserStore.sharedInstance.showTutorialScreens == "show" || UserStore.sharedInstance.showTutorialScreens == ""{
                            self.setTutorial()
                        } else {
                            self.imagesCountLabel.text = String(self.selectedPhotosDataCamera.count / 9)
                            self.setCustomCamera()
                        } } else {
                            //access denied
                            UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                            })
                        }
                })
            }
        }
    }
    
    func openPicker_Photos(_ sourceType: UIImagePickerControllerSourceType)  {
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        //        var configuration = Configuration()
        var configuration = ImagePickerConfiguration()
        configuration.doneButtonTitle = "Finish"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        imagePickerController = ImagePickerController(configuration: configuration)
        
        //        picker.allowsEditing = false
        //        picker.sourceType = sourceType
        //        picker.delegate = self
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //        present(picker, animated: true, completion: nil)
    }
    
    
    func addToolBar(textField: UISearchBar) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
    
    @IBAction func gallaryClick(_ sender: Any) {
        
        /*
        UIAlertController.showAlert("Upload media in", message: "Choose any option", buttons: ["New Campaign", "Existing Campaign", "Cancel"], completion: { (alert, index) in
            if index == 0 {
                self.openPics = "gallery"
                self.containCampaign = "new"
                self.uploadCampaignHolderView.isHidden = false
            } else if index == 1 {
                if self.userOldCampaigns.count == 0 {
                    UIAlertController.showAlert("Alert!", message: "No previous campaign found. Do you want to create a new campaign?", buttons: ["Yes","No"], completion: { (alert, index) in
                        if index == 0 {
                            self.openPics = "gallery"
                            self.containCampaign = "new"
                            self.uploadCampaignHolderView.isHidden = false
                        }
                    })
                } else {
                    self.openPics = "gallery"
                    self.containCampaign = "existing"
                    self.pickerView.reloadAllComponents()
                    self.pickerHolder.isHidden = false
                }
            } else if index == 2 {
                self.selectedPhotosDataCamera.removeAll()
                self.selectedPhotosData.removeAll()
                self.selectedVideosData.removeAll()
                self.capturedPhotos.removeAll()
            }
        })
        */
        
        
        
        print(UserStore.sharedInstance.showCameraSuggestion)
        if UserStore.sharedInstance.showCameraSuggestion == "" {
            UIAlertController.showAlert("Alert!", message: "For best results use uSnap’s camera to automatically capture 9 exposures", buttons: ["Cancel", "Proceed", "Don't show this again" ], completion: { (alert, index) in
                self.containCampaign = ""
                self.openPics = ""

                print(index)
                if index == 0 {
                }
                else if index == 1 {
                    DispatchQueue.main.async {
                        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                            //already authorized
                            self.showOptionsAfterPermissions()
                        } else {
                            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                                if granted {
                                    self.showOptionsAfterPermissions()
                                    //access allowed
                                } else {
                                    //access denied
                                    UIAlertController.showAlert("Alert!", message: "Please allow for gallery in app settings", buttons: ["OK"], completion: { (alert, index) in
                                    })
                                }
                            })
                        }
                    }
                }
                else {
                    UserStore.sharedInstance.showCameraSuggestion = "Dont show"
                }
                
            })
        }
        
        else {
            self.containCampaign = ""
            self.openPics = ""
            DispatchQueue.main.async {
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    //already authorized
                    self.showOptionsAfterPermissions()
                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                        if granted {
                            self.showOptionsAfterPermissions()
                            //access allowed
                        } else {
                            //access denied
                            UIAlertController.showAlert("Alert!", message: "Please allow for gallery in app settings", buttons: ["OK"], completion: { (alert, index) in
                            })
                        }
                    })
                }
            }
        }
        
    }
    
    func showOptionsAfterPermissions()  {
        DispatchQueue.main.async {
            
            UIAlertController.showActionSheet("Options", cbTitle: "Cancel", dbTitle: "", obTitles: ["Images", "Videos"], holdView: self.gallaryButton) { (alert, index) in
                print(index)
                if index == 1 {
                    self.showGalleryPics()
                }
                else if index == 2 {
                    self.openPicker_Videos(.photoLibrary)
                }
            }
        }
    }
    
    func showGalleryPics()  {
        //        selectedPhotosData = [NSData]()
        //        selectedVideosData = [NSData]()
        //        DKImagePickerControllerResource.customLocalizationBlock = nil
        //        DKImagePickerControllerResource.customImageBlock = nil
        //        DKImagePickerHandler.shared.currentVC = nil
        //        DKImagePickerHandler.shared.pickerController=DKImagePickerController()
        //        DKImageExtensionController.unregisterExtension(for: .camera)
        //        DKImageExtensionController.unregisterExtension(for: .inlineCamera)
        //
        //        DKImageAssetExporter.sharedInstance.remove(observer: self)
        //        DKImagePickerHandler.shared.currentVC = self
        //
        //        DKImagePickerHandler.shared.showImagePicker(vc: self) { (assets) in
        //            self.arrayDKAssets = assets!
        //
        //            self.imagesArray.removeAll()
        //            SVProgressHUD.show(withStatus: "Fetching images")
        //            if assets?.count == 0 {
        //
        //            }
        //            else {
        //                 self.getImagesFromAssets(self.arrayDKAssets[0], 0)
        //            }
        //        }
        
        
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
        //self.openPicker_Videos(.photoLibrary)
    }
    
    
    // MARK: - Delegates for custom gallery image picker
    func getImagesFromAssets(_ asset: DKAsset, _ position: Int)  {
        if position < self.arrayDKAssets.count {
            asset.fetchImage(with: PHImageManagerMaximumSize, completeBlock: { [weak self](image, dict) in
                self?.imagesArray.append(image!)
                if self?.imagesArray.count == self?.arrayDKAssets.count {
                    SVProgressHUD.dismiss()
                    self?.processGaleryImages((self?.imagesArray)!)
                }
                else {
                    if position+1 < (self?.arrayDKAssets.count)! {
                        self?.getImagesFromAssets((self?.arrayDKAssets[position+1])!, position+1)
                    }
                }
            })
        }
        
        
        
        //  self.processGaleryImages(imagesArray)
        
        
        
        //                var tempIntCount = Int()
        //                tempIntCount = 0
        //                selectedPhotosData = [NSData]()
        //                selectedVideosData = [NSData]()
        //                for imageAsset in assets {
        //                    tempIntCount  = tempIntCount + 1
        //                    SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.selectedPhotosData.count)), status: "Processing")
        //                    SVProgressHUD.setDefaultMaskType(.clear)
        //
        //        //            var image = UIImage()
        //        //            image = getUIImage(asset:imageAsset )!
        //
        //                     let asset = imageAsset
        //
        //                    asset.fetchImage(with: PHImageManagerMaximumSize, completeBlock: { (image, dict) in
        //                         self.selectedPhotosData.append(image.compressTo(2)! as NSData)
        //                        if self.selectedPhotosData.count == assets.count {
        //                            SVProgressHUD.dismiss()
        //                            self.uploadDataToServer()
        //                        }
        //                    })
        //
        //
        //                }
        
    }
    
    
    
    
    //    func getImagesFromAssets(_ assets: [PHAsset])  {
    //
    //        var tempIntCount = Int()
    //        tempIntCount = 0
    //        selectedPhotosData = [NSData]()
    //        selectedVideosData = [NSData]()
    //        for imageAsset in assets {
    //            tempIntCount  = tempIntCount + 1
    //            SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.selectedPhotosData.count)), status: "Processing")
    //            SVProgressHUD.setDefaultMaskType(.clear)
    //
    ////            var image = UIImage()
    ////            image = getUIImage(asset:imageAsset )!
    //
    //             let asset = imageAsset
    //
    //            asset.fetchImage(with: PHImageManagerMaximumSize, completeBlock: { (image, dict) in
    //                 self.selectedPhotosData.append(image.compressTo(2)! as NSData)
    //                if self.selectedPhotosData.count == assets.count {
    //                    SVProgressHUD.dismiss()
    //                    self.uploadDataToServer()
    //                }
    //            })
    //
    //
    //        }
    //
    //    }
    
    func getImages(_ assets: [PHAsset])  {
        SVProgressHUD.show()
        for item in assets {
            imagesArray.append(getUIImage(asset: item)!)
        }
        print(imagesArray)
        SVProgressHUD.dismiss()
        self.processGaleryImages(imagesArray)
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        //        var img: UIImage?
        //        let manager = PHImageManager.default()
        //        let options = PHImageRequestOptions()
        //        options.version = .original
        //        options.isSynchronous = false
        //        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
        //            if let data = data {
        //                img = UIImage(data: data)
        //            }
        //        }
        //        return img
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.version = .original
        var thumbnail = UIImage()
        option.isSynchronous = true
        var size = CGSize()
        size = PHImageManagerMaximumSize
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if result == nil {
                
            } else {
                thumbnail = result!
            }
        })
        return thumbnail
    }
    
    
    //MARK:- Get original image from Asset
    func getImageFromAsset(_ asset: PHAsset,_ boolOriginal: Bool) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.version = .original
        var thumbnail = UIImage()
        option.isSynchronous = true
        var size = CGSize()
        if boolOriginal == true {
            size = PHImageManagerMaximumSize
        } else {
            size = CGSize(width: 100, height: 100)
        }
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if result == nil {
                
            } else {
                thumbnail = result!
            }
        })
        return thumbnail
    }
    
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        presentedViewController?.dismiss(animated: true, completion: {
            self.processGaleryImages(images)
        })
        
    }
    
   //=========
    func processGaleryImages(_ images: [UIImage])  {
        var tempIntCount = Int()
        tempIntCount = 0
        selectedPhotosData = [NSData]()
        selectedVideosData = [NSData]()
        for image in images {
            tempIntCount  = tempIntCount + 1
            SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.selectedPhotosData.count)), status: "Processing")
            SVProgressHUD.setDefaultMaskType(.clear)
            let data = image.compressTo(2)
            
//            PhotoManager.instance.saveImageToAlbumInRootFolder(image: image) { (error) in
//                 // Handle error
//            }

            if data != nil {
                self.selectedPhotosData.append(data! as NSData)
            }else{
                self.imagesArray.removeAll()
                SVProgressHUD.dismiss()
                SVProgressHUD.showInfo(withStatus: "file format is not supported")
            }
            print(images.count)
            print(selectedPhotosData.count)
            if self.selectedPhotosData.count == images.count {
                SVProgressHUD.dismiss()
                self.imagesArray.removeAll()
               // self.uploadDataToServer()
                print("=-=-=>>", self.containCampaign)
                if self.containCampaign == "existing" {
                    self.saveDataToExistingCamp()
                }
                else if self.containCampaign == "new" {
                    self.saveDataToExistingCampign()
                } else {
                    self.uploadDataToServer()
                }
            }
        }
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func videoClick(_ sender: Any) {
        UIAlertController.showAlert("Upload media in", message: "Choose any option", buttons: ["New Campaign", "Existing Campaign", "Cancel"], completion: { (alert, index) in
            if index == 0 {
                self.openPics = "video"
                self.containCampaign = "new"
                self.uploadCampaignHolderView.isHidden = false
            } else if index == 1 {
                if self.userOldCampaigns.count == 0 {
                    UIAlertController.showAlert("Alert!", message: "No previous campaign found. Do you want to create a new campaign?", buttons: ["Yes","No"], completion: { (alert, index) in
                        if index == 0 {
                            self.openPics = "video"
                            self.containCampaign = "new"
                            self.uploadCampaignHolderView.isHidden = false
                        }
                    })
                } else {
                    self.openPics = "video"
                    self.containCampaign = "existing"
                    self.pickerView.reloadAllComponents()
                    self.pickerHolder.isHidden = false
                }
            } else if index == 2 {
                self.selectedPhotosDataCamera.removeAll()
                self.selectedPhotosData.removeAll()
                self.selectedVideosData.removeAll()
                self.capturedPhotos.removeAll()
            }
        })
        
        /*
        DispatchQueue.main.async {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                self.openPicker_Videos(.camera)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        self.openPicker_Videos(.camera)
                    } else {
                        //access denied
                        UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                        })
                    }
                })
            }
        }
        */
    }
    
    func openPicker_Videos(_ sourceType: UIImagePickerControllerSourceType)  {
        DispatchQueue.main.async {
            self.picker.sourceType = sourceType
            self.picker.videoQuality = .typeHigh
            self.picker.delegate = self
            self.picker.mediaTypes = [kUTTypeMovie as NSString as String]
            // picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("crashhhhhhhhhhhhhhhhhhhhhh 122222222")
    }
    
    // MARK: - SET CAMERA
    //  var backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    // var backCamera = AVCaptureDevice()
    
    //    func captureDevice() -> AVCaptureDevice {
    //            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: .video, position: .front).devices
    //            for device in devices where device.position == .front {
    //                return device
    //
    //
    //        }
    //
    //        return AVCaptureDevice.default(for: .video)!
    //    }
    //
    //
    //
    //    func setUpCustomCamera() {
    //        session = AVCaptureSession()
    //        session!.sessionPreset = AVCaptureSession.Preset.photo
    //
    //        var backCamera = captureDevice()
    //
    //        do {
    //           try backCamera.lockForConfiguration()
    //        }
    //        catch let error1 as NSError {
    //        }
    //        backCamera.exposureMode = .custom
    //
    ////        backCamera.setExposureModeCustom(duration: CMTimeMake(1,150), iso: 450 , completionHandler: {(timestamp:CMTime) -> Void in
    ////        })
    //
    //
    //
    //        var error: NSError?
    //        var input: AVCaptureDeviceInput!
    //        do {
    //            input = try AVCaptureDeviceInput(device: backCamera)
    //
    //
    //
    //
    //        } catch let error1 as NSError {
    //            error = error1
    //            input = nil
    //        }
    //        if error == nil && session!.canAddInput(input) {
    //            session!.addInput(input)
    //          //  stillImageOutput = AVCaptureStillImageOutput()
    //             stillImageOutput = AVCapturePhotoOutput()
    //
    //
    //
    //
    //            let settings = AVCapturePhotoSettings()
    //            let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
    //            let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
    //                                 kCVPixelBufferWidthKey as String: 160,
    //                                 kCVPixelBufferHeightKey as String: 160]
    //            settings.previewPhotoFormat = previewFormat
    //
    //
    //           // stillImageOutput(with: settings, delegate: self)
    //
    //           Fce stillImageOutput?.setPreparedPhotoSettingsArray([settings], completionHandler: nil)
    //
    //
    //           // stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
    //
    //            if session!.canAddOutput(stillImageOutput!) {
    //                session!.addOutput(stillImageOutput!)
    //                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
    //                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
    //                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    //                customCameraView.layer.addSublayer(videoPreviewLayer!)
    //                session!.startRunning()
    //                // ...
    //                // Configure the Live Preview here...
    //            }
    //            // ...
    //            // The remainder of the session setup will go here...
    //        }
    //    }
    
    @IBAction func customCameraCancelClick(_ sender: Any) {
        self.selectedPhotosDataCamera1.removeAll()
        AppUtility.lockOrientation(.portrait)
        SVProgressHUD.dismiss()
        cameraManager.stopCaptureSession()
        ExposureCustomCamera.shared.removeAllFromMemory()
        
        session?.stopRunning()
        session = nil
        self.customCameraDoneBtn.isUserInteractionEnabled = true
        self.customCameraCancelBtn.isUserInteractionEnabled = true
        selectedPhotosDataCamera = [NSData]()
        selectedPhotosDataCamera.removeAll()
        customCameraHolderView.isHidden = true
        self.fetchCampaignList()
        self.fetchCampaignData()
    }
    
    @IBAction func customCameraDoneClick(_ sender: Any) {
        self.selectedPhotosDataCamera1.removeAll()
        AppUtility.lockOrientation(.portrait)
        // let aStr = String(format: "%@%x", "timeNow in hex: ", timeNow)
        ExposureCustomCamera.shared.removeAllFromMemory()
        
        SVProgressHUD.show(withStatus: "Processing")
        SVProgressHUD.setDefaultMaskType(.clear)
        self.customCameraDoneBtn.isUserInteractionEnabled = false
        self.customCameraCancelBtn.isUserInteractionEnabled = false
        self.customCameracaptureBtn.isUserInteractionEnabled = false
        
        if self.selectedPhotosDataCamera.count == 0 {
            SVProgressHUD.dismiss()
            self.customCameraHolderView.isHidden = true
            self.customCameraDoneBtn.isUserInteractionEnabled = true
            self.customCameraCancelBtn.isUserInteractionEnabled = true
            self.customCameracaptureBtn.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        }
        else {
            perform(#selector(processImages), with: nil, afterDelay: 1)
        }
    }
    
    @objc func processImages() {
        var orientationCounter = Int()
        orientationCounter = 0
        
        cameraManager.stopCaptureSession()
        
        session?.stopRunning()
        session = nil
        self.customCameraHolderView.isHidden = true
        self.customCameraDoneBtn.isUserInteractionEnabled = true
        self.customCameraCancelBtn.isUserInteractionEnabled = true
        self.customCameracaptureBtn.isUserInteractionEnabled = true
        videoPreviewLayer?.removeFromSuperlayer()
        
        DispatchQueue.global(qos: .userInitiated).async {
            // var tempIntCount = Int()
            //  tempIntCount = 0
            //            for img in self.capturedPhotos {
            //                tempIntCount  = tempIntCount + 1
            //                DispatchQueue.main.async {
            //                    if tempIntCount  >= self.capturedPhotos.count  {
            //                        self.customCameraHolderView.isHidden = true
            //                        self.customCameraDoneBtn.isUserInteractionEnabled = true
            //                        self.customCameraCancelBtn.isUserInteractionEnabled = true
            //                        self.customCameracaptureBtn.isUserInteractionEnabled = true
            //                    }
            //                   SVProgressHUD.showProgress(Float(Float(tempIntCount)/Float(self.capturedPhotos.count)), status: "Processing")
            //                     SVProgressHUD.setDefaultMaskType(.clear)
            //                }
            //
            //               var finalImageAfterRotation = UIImage()
            //
            //                if self.imagesOrientation[orientationCounter] == "L" {
            //                    finalImageAfterRotation = img
            //                }
            //                else {
            //                    finalImageAfterRotation = self.imageOrientation(img)
            //                }
            //                   self.selectedPhotosDataCamera.append(finalImageAfterRotation.compressTo(3)! as NSData)
            //                 orientationCounter = orientationCounter + 1
            //            }
            
            SVProgressHUD.dismiss()
            self.capturedPhotos.removeAll()
            self.imagesOrientation.removeAll()
            //self.uploadDataToServer()
            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        }
    }
    
    @IBAction func customCameraClickPic(_ sender: UIButton) {
        angle  = .pi/2
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            text="Portrait"
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
        case .landscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
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
        
        if selectedPhotosDataCamera.count / 9 == 10 {
            SVProgressHUD.showError(withStatus: "Maximum 10 photos are allowed")
        } else {
            customCameraDoneBtn.isUserInteractionEnabled = false
            self.customCameraCancelBtn.isUserInteractionEnabled = false
            self.customCameracaptureBtn.isUserInteractionEnabled = false
            loaderImageView.image = loaderImage
            if UIDevice.current.orientation.isLandscape {
                loaderWidthConstraint.constant = 152
                loaderHeightConstraint.constant = 250
            } else {
                loaderWidthConstraint.constant = 250
                loaderHeightConstraint.constant = 152
            }
            loaderHolderView.isHidden = false
            expouserCounter = 0
            capturePhotos()
        }
    }
    
    var exposeValuesArray = [0.5,0.10,0.17,0.24,0.31,0.38,0.45,0.52,0.59]
    var count = 0
    
    func capturePhotos(){
        ExposureCustomCamera.shared.delegate = self
        ExposureCustomCamera.shared.captureClick()
        
        //        self.cameraManager._changeExposureDuration(value: Float(self.exposeValuesArray[self.count]))
        //        self.count += 1
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        //            self.cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
        //                if image != nil {
        //                    self.addOrientation()
        //
        //                    self.cameraManager.focusMode = .locked
        //                    self.cameraManager._changeExposureMode(mode: .custom)
        //                    self.capturePhotos()
        //                }
        //            })
        //        })
        
        //    } else {
        //        print("Done")
        //        self.cameraManager.focusMode = .continuousAutoFocus
        //       self.cameraManager._changeExposureMode(mode: .continuousAutoExposure)
        //        self.count = 0
        //        self.loaderHolderView.isHidden = true
        //        SVProgressHUD.dismiss()
        //        self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
        //        self.customCameraDoneBtn.isUserInteractionEnabled = true
        //        self.customCameraCancelBtn.isUserInteractionEnabled = true
        //        self.customCameracaptureBtn.isUserInteractionEnabled = true
        //    }
        
    }
    
    // MARK: - Exposure camera delegate
    
    func getAllExposures(_ imagesData : [NSData]) {
        selectedPhotosDataCamera = selectedPhotosDataCamera + imagesData
        selectedPhotosDataCamera1 = selectedPhotosDataCamera1 + imagesData
        self.loaderHolderView.isHidden = true
        SVProgressHUD.dismiss()
        self.imagesCountLabel.text = String(self.selectedPhotosDataCamera1.count / 9)
        self.customCameraDoneBtn.isUserInteractionEnabled = true
        self.customCameraCancelBtn.isUserInteractionEnabled = true
        self.customCameracaptureBtn.isUserInteractionEnabled = true
        
        if (self.selectedPhotosDataCamera.count / 9) >= 1 {
            self.uploadData()
//            if self.containCampaign == "existing" {
//                self.uploadData()
//            }
//            else if self.containCampaign == "new" {
//                self.uploadData()
//            }
        }
    }
    
    func addOrientation()  {
        imagesOrientation.append(currentOrientationValue)
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
    
    
    
    
    
    //    func capturePhoto(_ exposure : Float, _maxDuration  : Int )  {
    //        let videoConnection = stillImageOutput!.connection(with: AVMediaType.video)
    //        if(videoConnection != nil) {
    //            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
    //                if sampleBuffer != nil {
    //                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
    //                    let dataProvider = CGDataProvider(data: imageData! as CFData)
    //                    let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
    //                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
    //                   // let data = UIImagePNGRepresentation(image)
    //
    //                  //  self.selectedPhotosDataCamera.append(data! as NSData)
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
    
    
    
    
    
    
    
    func capturePhoto(_ exposure : Float, _maxDuration  : Int )  {
        let videoConnection = stillImageOutput!.connection(with: AVMediaType.video)
        if(videoConnection != nil) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (sampleBuffer, error) -> Void in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                    let dataProvider = CGDataProvider(data: imageData! as CFData)
                    let cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.relativeColorimetric)
                    let orientation: UIDeviceOrientation = UIDevice.current.orientation
                    let image = self.changeImageOrientation(orientation:orientation,cgImage: cgImageRef!)
                    self.capturedPhotos.append(image)
                    //                    self.backCamera?.setExposureTargetBias(exposure, completionHandler: { (timestamp:CMTime) -> Void in
                    //
                    ////                    })
                    //
                    //
                    //
                    //
                    //
                    self.backCamera?.setExposureModeCustom(duration: CMTimeMake(1,Int32(_maxDuration)), iso: exposure , completionHandler: {(timestamp:CMTime) -> Void in
                        self.imagesCountLabel.text = String(self.capturedPhotos.count / 9)
                        if self.expouserCounter == self.exposureValues.count - 1 {
                            self.loaderHolderView.isHidden = true
                            self.expouserCounter = 0
                            SVProgressHUD.dismiss()
                            self.customCameraDoneBtn.isUserInteractionEnabled = true
                            self.customCameraCancelBtn.isUserInteractionEnabled = true
                            self.customCameracaptureBtn.isUserInteractionEnabled = true
                            self.backCamera?.setExposureModeCustom(duration:CMTimeMake(1,Int32(self.maxDuartion[self.expouserCounter])) , iso: self.exposureValues[self.expouserCounter], completionHandler: nil)
                        } else {
                            print(self.expouserCounter)
                            self.expouserCounter = self.expouserCounter + 1
                            self.capturePhoto(self.exposureValues[self.expouserCounter], _maxDuration: self.maxDuartion[self.expouserCounter])
                        }
                    })
                }
            })
        }
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
        
        let rotatedImage = oldImage.rotate(radians: Float(degrees))
        //        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        //        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        //        rotatedViewBox.transform = t
        //        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //        //Create the bitmap context
        //        UIGraphicsBeginImageContext(rotatedSize)
        //        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //        //Move the origin to the middle of the image so we will rotate and scale around the center.
        //        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //        //Rotate the image context
        //        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //        //Now, draw the rotated/scaled image into the context
        //        bitmap.scaleBy(x: 1.0, y: -1.0)
        //        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        //        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //        UIGraphicsEndImageContext()
        return rotatedImage!
    }
    
    
    
    func changeImageOrientation(orientation:UIDeviceOrientation,cgImage:CGImage) -> UIImage {
        let image:UIImage!
        switch (orientation) {
        case .portrait:
            image = UIImage.init(cgImage: cgImage, scale: 0.0, orientation: UIImageOrientation.right)
            return image!
        case .landscapeRight:
            image = UIImage.init(cgImage: cgImage, scale: 0.0, orientation: UIImageOrientation.down)
            return image!
        case .landscapeLeft:
            image = UIImage.init(cgImage: cgImage, scale: 0.0, orientation: UIImageOrientation.up)
            return image!
        default:
            image = UIImage.init(cgImage: cgImage, scale: 0.0, orientation: UIImageOrientation.right)
            return image!
        }
    }
    
    
    func changeCIimageOrientation(orientation:UIDeviceOrientation,_ ciImage:CIImage) -> UIImage {
        let image:UIImage!
        switch (orientation) {
        case .portrait:
            image = UIImage.init(ciImage: ciImage, scale: 0.0, orientation: UIImageOrientation.right)
            return image!
        case .landscapeRight:
            image = UIImage.init(ciImage: ciImage, scale: 0.0, orientation: UIImageOrientation.down)
            return image!
        case .landscapeLeft:
            image = UIImage.init(ciImage: ciImage, scale: 0.0, orientation: UIImageOrientation.up)
            return image!
        default:
            image = UIImage.init(ciImage: ciImage, scale: 0.0, orientation: UIImageOrientation.right)
            return image!
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.campaignListResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        //cell.countLabel.text = String(format: "#%d", indexPath.row + 1)
        cell.countLabel.text = String(format: "#%d", Int(self.campaignListResponse[indexPath.row].internalIdentifier!)! + 100)
        cell.campaignTitle.text = self.campaignListResponse[indexPath.row].title!
       
        cell.campaignDateLabel.text = self.campaignListResponse[indexPath.row].addDate!.removeTimeFromString(self.campaignListResponse[indexPath.row].addDate!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        navigationController?.pushViewController(CompletedCampaignViewController.control(self.campaignListResponse[indexPath.row]), animated: true)
        //
        //        return
        UserStore.sharedInstance.title = self.campaignListResponse[indexPath.row].title!
        if campaignListResponse[indexPath.row].assignedRetoucher == "0" {
            NewCampaignDetailStore.sharedInstance.createdCampaignId = Int(campaignListResponse[indexPath.row].internalIdentifier!)!
            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        } else {
            navigationController?.pushViewController(CompletedCampaignViewController.control(self.campaignListResponse[indexPath.row]), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //        let Accept = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
        //        }
        //        Accept.backgroundColor = acceptBgColor
        let Decline = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            UIAlertController.showAlert("Alert!", message: "Are you sure", buttons: ["Cancel", "Delete"], completion: { (alert, alertIndex) in
                if alertIndex == 0 {
                } else {
                    self.deleteCampaign(self.campaignListResponse[index.row].internalIdentifier!)
                }
            })
        }
        Decline.backgroundColor = declineBgColor
        return [Decline]
    }
    
    func deleteCampaign(_ campId: String)  {
        CampaignStore.sharedInstance.deleteCampaign(campId) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                self.searchBar.text = ""
                self.fetchCampaignList()
                self.fetchCampaignData()
            }else{
                SVProgressHUD.showInfo(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func pickerRemover(_ sender: Any
    ) {
        self.pickerHolder.isHidden = true
    }
    
    @IBAction func pickerCancel(_ sender: Any) {
        
        self.selectedPhotosDataCamera.removeAll()
        self.selectedPhotosData.removeAll()
        self.selectedVideosData.removeAll()
        self.capturedPhotos.removeAll()
        self.pickerHolder.isHidden = true
    }
    
    @IBAction func pickerDone(_ sender: Any) {
        self.pickerHolder.isHidden = true
        self.galleryExistingPics = "existing"
        if selectedCampaignID == "" {
            if userOldCampaigns.count > 0 {
                selectedCampaignID = userOldCampaigns[0].internalIdentifier!
            }
            
            if self.openPics == "gallery" {
                showOptionsAfterPermissions()
            } else if self.openPics == "camera" {
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
                        self.setCameraAccordngToNeed()
                    }
                }
                
                else {
                    NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
                    self.setCameraAccordngToNeed()
                }

            } else if self.openPics == "video" {
                DispatchQueue.main.async {
                    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                        //already authorized
                        self.openPicker_Videos(.camera)
                    } else {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                            if granted {
                                //access allowed
                                self.openPicker_Videos(.camera)
                            } else {
                                //access denied
                                UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                                })
                            }
                        })
                    }
                }
            } else {
                saveDataToExistingCamp()
            }
            //saveDataToExistingCamp()
        }
        else {
            if self.openPics == "gallery" {
                showOptionsAfterPermissions()
            } else if self.openPics == "camera" {
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
                        self.setCameraAccordngToNeed()
                    }
                }
                
                else {
                    NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
                    self.setCameraAccordngToNeed()
                }

            } else if self.openPics == "video" {
                DispatchQueue.main.async {
                    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                        //already authorized
                        self.openPicker_Videos(.camera)
                    } else {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                            if granted {
                                //access allowed
                                self.openPicker_Videos(.camera)
                            } else {
                                //access denied
                                UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                                })
                            }
                        })
                    }
                }
            } else {
                saveDataToExistingCamp()
            }
            //saveDataToExistingCamp()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if campaignListResponse[indexPath.row].assignedRetoucher == "0" {
            return true
        }
        return false
    }
    
    
    // MARK: - Top Bar Delegates
    
    
    
    @IBAction func filterData(_ sender: Any) {
        selectedPhotosData.removeAll()
        selectedVideosData.removeAll()
        selectedPhotosDataCamera.removeAll()
        
        //        NewCampaignDetailStore.sharedInstance.selectedPics = self.selectedPhotosData
        //        NewCampaignDetailStore.sharedInstance.selectedVids = self.selectedVideosData
        //        NewCampaignDetailStore.sharedInstance.selectedPicsCamera = self.selectedPhotosDataCamera
        
        
        
        self.openPics = ""
        self.uploadCampaignHolderView.isHidden = false
        
    }
    
    @IBAction func writeData(_ sender: Any) {
    }
    
    
    
    func leftButtonClicked1() {
//        selectedPhotosData.removeAll()
//        selectedVideosData.removeAll()
//        selectedPhotosDataCamera.removeAll()
//
//        //        NewCampaignDetailStore.sharedInstance.selectedPics = self.selectedPhotosData
//        //        NewCampaignDetailStore.sharedInstance.selectedVids = self.selectedVideosData
//        //        NewCampaignDetailStore.sharedInstance.selectedPicsCamera = self.selectedPhotosDataCamera
//
//
//
//        self.openPics = ""
//        self.uploadCampaignHolderView.isHidden = false
//
        //        let control = CrateCampaignPopUpViewController.control as! CrateCampaignPopUpViewController
        //        control.delegate = self
        //        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
    }
    
    func leftButtonClicked2() {
        
        // let control = StaffInvoiceFIlterPopUpViewController.control as! StaffInvoiceFIlterPopUpViewController
        // control.delegate = self
        // UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        
      
        
    }
    
    func backButtonClicked() {
        
    }
    @IBAction func bgButtonClick(_ sender: Any) {
        self.setAfterUI()
        self.selectedPhotosDataCamera.removeAll()
        self.selectedPhotosData.removeAll()
        self.selectedVideosData.removeAll()
        self.capturedPhotos.removeAll()
        uploadCampaignHolderView.isHidden = true
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if campTitleTF.text == "" && addressLbl.text == "Address" || addressLbl.text == "" {
            SVProgressHUD.showError(withStatus: "Please fill all the fields")
            return
        }else if btnSelectCategory.currentTitle?.lowercased() == "Select Service".lowercased() {
            SVProgressHUD.showError(withStatus: "Please fill all the fields")
            return
        }
        var addressText  = String()
        if addressLbl.text == "Address" {
            addressText = ""
        }
        else {
            addressText = addressLbl.text!
        }
        saveImagesLocally(addressText)
    }
    
    func saveImagesLocally(_ address: String)  {
        SVProgressHUD.show()
        
        var imagesInt = Int()
        var imageNames = [String]()
        imagesInt = 0
        for imageData in self.selectedPhotosDataCamera {
            imagesInt = imagesInt + 1
            let imageName = String(format: "%@%d.jpeg", "image", imagesInt)
            print(imageName)
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? imageData.write(to: filename)
            imageNames.append(imageName)
        }
        
        let localDictData = [
            "images" : imageNames,
            "title" : campTitleTF.text!,
            "address" : address,
            "staffID" : selectedStaffId,
            "existingCamp": selectedCampaignID,
            "serviceId":selectedCampaignCategoriesId
        ] as [String : Any]
        UserDefaults.standard.set(localDictData, forKey: "localCampDetails")
        SVProgressHUD.dismiss()
        if NetworkReachabilityManager()!.isReachable {
            saveCampDataToServer(campTitleTF.text!, address, selectedStaffId, selectedCampaignCategoriesId)
        }
        else {
            UIAlertController.showAlert("Alert", message: "Your internet connection is unavailable, this campaign has been saved locally. Please upload it when your connected to the internet.", buttons: ["OK"]) { (alert, value) in
                self.selectedPhotosDataCamera.removeAll()
                self.selectedPhotosData.removeAll()
                self.selectedVideosData.removeAll()
                self.capturedPhotos.removeAll()
                self.setAfterUI()
                self.uploadCampaignHolderView.isHidden = true
            }
        }
    }
    
    func fetchLocalCampData()  {
        SVProgressHUD.show()
        selectedPhotosDataCamera.removeAll()
        let dataDict = UserDefaults.standard.dictionary(forKey: "localCampDetails")
        print(dataDict as Any)
        var tempImagesNames = [String]()
        tempImagesNames = dataDict!["images"] as! [String]
        
        for itemName in tempImagesNames {
            let fileManager = FileManager.default
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(itemName)
            if fileManager.fileExists(atPath: imagePAth){
                selectedPhotosDataCamera.append(UIImageJPEGRepresentation(UIImage(contentsOfFile: imagePAth)!, 1.0)! as NSData)
                selectedPhotosDataCamera1.append(UIImageJPEGRepresentation(UIImage(contentsOfFile: imagePAth)!, 1.0)! as NSData)
            }else{
                print("No Image")
            }
        }
        SVProgressHUD.dismiss()
        saveCampDataToServer(dataDict!["title"] as! String, dataDict!["address"] as! String, dataDict!["staffID"] as! String, dataDict!["serviceId"] as! String)
    }
    
    func saveCampDataToServer(_ title: String, _ address: String, _ staffId: String, _ catagorieid: String) {
        CreateCampaignStore.sharedInstance.sendCampaignData(self.selectedPhotosData as NSArray, self.selectedPhotosDataCamera as NSArray,self.selectedVideosData as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole , title, address, "", "", "", "", catagorieid, staffId, "",  "") { (response) in
            print(response as Any)
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
   
                //-- Saved to photo library
                UserStore.sharedInstance.title = title
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
                
//                if self.selectedVideosData.count != 0 {
//                    for videoData in 0..<self.selectedVideosData.count {
//                        guard let video = UIImage(data: self.selectedVideosData[videoData] as Data) else { return }
//                        print(video)
//                        CustomPhotoAlbum.sharedInstance.save(image: video)
//                    }
//                }
                
                self.campTitleTF.text = ""
                self.addressLbl.text = "Address"
                SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
                NewCampaignDetailStore.sharedInstance.createdCampaignId = (responseData["result"] as! NSDictionary).value(forKey: "campaign_id") as! Int
                self.removeLocalFiles()
                self.selectedPhotosDataCamera.removeAll()
                self.selectedPhotosData.removeAll()
                self.selectedVideosData.removeAll()
                self.capturedPhotos.removeAll()
                self.setAfterUI()
                self.uploadCampaignHolderView.isHidden = true
                
                if self.openPics == "gallery" {
                    print(UserStore.sharedInstance.showCameraSuggestion)
                    if UserStore.sharedInstance.showCameraSuggestion == "" {
                        UIAlertController.showAlert("Alert!", message: "For best results use uSnap’s camera to automatically capture 9 exposures", buttons: ["Cancel", "Proceed", "Don't show this again" ], completion: { (alert, index) in
                            
                            print(index)
                            if index == 0 {}
                            else if index == 1 {
                                DispatchQueue.main.async {
                                    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                                        //already authorized
                                        self.showOptionsAfterPermissions()
                                    } else {
                                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                                            if granted {
                                                self.showOptionsAfterPermissions()
                                                //access allowed
                                            } else {
                                                //access denied
                                                UIAlertController.showAlert("Alert!", message: "Please allow for gallery in app settings", buttons: ["OK"], completion: { (alert, index) in
                                                })
                                            }
                                        })
                                    }
                                }
                            }
                            else {
                                UserStore.sharedInstance.showCameraSuggestion = "Dont show"
                            }
                            
                        })
                    }
                    
                    else {
                        DispatchQueue.main.async {
                            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                                //already authorized
                                self.showOptionsAfterPermissions()
                            } else {
                                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                                    if granted {
                                        self.showOptionsAfterPermissions()
                                        //access allowed
                                    } else {
                                        //access denied
                                        UIAlertController.showAlert("Alert!", message: "Please allow for gallery in app settings", buttons: ["OK"], completion: { (alert, index) in
                                        })
                                    }
                                })
                            }
                        }
                    }
                }
                else if self.openPics == "camera" {
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
                            self.setCameraAccordngToNeed()
                        }
                    }
                    
                    else {
                        NewCampaignDetailStore.sharedInstance.selectedCameraType = "Wide"
                        self.setCameraAccordngToNeed()
                    }
                }
                else if self.openPics == "video" {
                    DispatchQueue.main.async {
                        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                            //already authorized
                            self.openPicker_Videos(.camera)
                        } else {
                            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                                if granted {
                                    //access allowed
                                    self.openPicker_Videos(.camera)
                                } else {
                                    //access denied
                                    UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                                    })
                                }
                            })
                        }
                    }
                }
                
                else {
                    self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
                }
            } else {
                self.setAfterUI()
                SVProgressHUD.showError(withStatus: "Only one video is allowed per campaign")
            }
        }
    }
    
    func removeLocalFiles() {
        SVProgressHUD.show()
        let dataDict = UserDefaults.standard.dictionary(forKey: "localCampDetails")
        var tempImagesNames = [String]()
        tempImagesNames = dataDict!["images"] as! [String]
        
        for itemName in tempImagesNames {
            let fileManager = FileManager.default
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            guard let dirPath = paths.first else {
                return
            }
            let filePath = "\(dirPath)/\(itemName)\("")"
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        UserDefaults.standard.removeObject(forKey: "localCampDetails")
        SVProgressHUD.dismiss()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func staffButtonClick(_ sender: Any) {
        if MiscDetailStore.sharedInstance.staffMembers.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
        }
        else {
            MiscDetailStore.sharedInstance.pickerTye = "StaffMembers"
            let control = CustomPickerViewController.control as! CustomPickerViewController
            control.delegate = self
            UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        }
    }
    
    // MARK: - New Campaign Pop Up Delegates
    func success(_ value: String?) {
        self.selectedPhotosDataCamera.removeAll()
        
        
        // UIApplication.visibleViewController.dismiss(animated: true, completion: nil)
        //        self.dismiss(animated: true) {
        //            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        //        }
        //  self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        }
        
        //UIApplication.visibleViewController.dismiss(animated: true) {
        // self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        // }
        
        
        
    }
    
    
    deinit {
        print("closeddddddddddddd")
    }
    
    
    // MARK: - Search Bar Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        campaignListResponse = [CampaignListresult]()
        campaignListResponse = modelBackUp
        searchArray = [CampaignListresult]()
        if searchText.length != 0 {
            for i in 0..<campaignListResponse.count {
                if ((campaignListResponse[i].title?.lowercased() as! NSString).range(of: searchText.lowercased())).location != NSNotFound {
                    searchArray.append(campaignListResponse[i])
                    //  searchArray.append(item)
                }
            }
            campaignListResponse = [CampaignListresult]()
            campaignListResponse = searchArray
        }
        else {
            campaignListResponse = [CampaignListresult]()
            campaignListResponse = modelBackUp
            // searchArray = items
        }
        
        listView.reloadData()
    }
    
    // MARK: - IMAGE PICKER DELEGATES
    func assetsPickerController(_ picker: CTAssetsPickerController!, didFinishPickingAssets assets: [Any]!) {
        selectedPhotosData = [NSData]()
        selectedVideosData = [NSData]()
        for image in assets {
            if let currentAsset = image as? PHAsset {
                switch currentAsset.mediaType {
                case .image:
                    let img = getAssetThumbnailwqqwqw(asset: currentAsset)
                    //  let data = UIImagePNGRepresentation(img) as NSData?
                    let data = img.compressTo(3)
                    
                    self.selectedPhotosData.append(data! as NSData)
                    if self.selectedVideosData.count + self.selectedPhotosData.count == assets.count {
                        self.dismiss(animated: true, completion: {
                            self.uploadDataToServer()
                        })
                        
                    }
                    
                case .video:
                    PHImageManager.default().requestAVAsset(forVideo: currentAsset, options: nil, resultHandler: { (asset, mix, nil) in
                        let myAsset = asset as? AVURLAsset
                        do {
                            try DispatchQueue.main.sync {
                                let videoData = try Data(contentsOf: (myAsset?.url)!)
                                
                                self.selectedVideosData.append(videoData as NSData)
                                if self.selectedVideosData.count + self.selectedPhotosData.count == assets.count {
                                    
                                    //   self.dismiss(animated: true, completion: {
                                    self.uploadDataToServer()
                                    //})
                                }
                                else
                                {
                                    
                                }
                                
                            }
                        } catch  {
                        }
                    })
                    
                    print("Video")
                case .audio:
                    print("Audio")
                default:
                    print("Unknown")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    //    func assetsPickerController(_ picker: CTAssetsPickerController!, didFinishPickingAssets assets: [Any]!) {
    //        selectedPhotosData = [NSData]()
    //        selectedVideosData = [NSData]()
    //        for image in assets {
    //            if let currentAsset = image as? PHAsset {
    //                switch currentAsset.mediaType {
    //                case .image:
    //                    let manager = PHImageManager.default()
    //                    let options = PHImageRequestOptions()
    //                    options.version = .original
    //                    options.isSynchronous = true
    //                    manager.requestImageData(for: currentAsset, options: options) { data, _, _, _ in
    //                        if let data = data {
    //
    //                            self.selectedPhotosData.append(data as NSData)
    //                            if self.selectedVideosData.count + self.selectedPhotosData.count == assets.count {
    //
    //
    //                                self.dismiss(animated: true, completion: {
    //                                    self.uploadDataToServer()
    //                                })
    //
    //                               // dismiss(animated:true, completion: nil)
    ////                                self.picker.dismiss(animated: true, completion: {
    ////                                   self.uploadDataToServer()
    ////                                })
    //
    //                               // self.picker.dismiss(animated: true, completion: nil)
    //
    //                            }
    //                            else
    //                            {
    //                            }
    //                        }
    //                        else {
    //                        }
    //                    }
    //
    //                case .video:
    //                    let options: PHVideoRequestOptions = PHVideoRequestOptions()
    //                    options.version = .current
    //                    PHImageManager.default().requestAVAsset(forVideo: currentAsset, options: options, resultHandler: { (asset, audioMix, info) in
    //                        if let urlAsset = asset as? AVURLAsset {
    //                            let localVideoUrl = urlAsset.url
    //                        }
    //                    })
    //
    //
    //
    //
    //
    //
    //                case .audio:
    //                    print("Audio")
    //                default:
    //                    print("Unknown")
    //                }
    //            }
    //        }
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    
    
    func getAssetThumbnailwqqwqw(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            // if (result != nil) {
            thumbnail = result!
            //}
            //else {
            // thumbnail = self.getAssetThumbnailWithSize(asset: asset, width: 500, height: 500)
            
            //}
            
        })
        return thumbnail
    }
    
    func getAssetThumbnailWithSize(asset: PHAsset, width: Int, height: Int) -> UIImage {
        var retimage = UIImage()
        let manager = PHImageManager.default()
        var thumbnail = UIImage()
        manager.requestImage(for: asset, targetSize: CGSize(width: width, height: height), contentMode: .aspectFit, options: nil, resultHandler: {
            (result, info)->Void in
            if (result != nil) {
                retimage = result!
                thumbnail = retimage
            }
            else {
                _ = self.getAssetThumbnailWithSize(asset:asset , width: width - 100, height: height - 100)
            }
        })
        
        return thumbnail
    }
    
    func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale)//(size * retinaScale, size * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x:0, y: 0,width: CGFloat(cropSizeLength),height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        selectedPhotosDataCamera = [NSData]()
        selectedPhotosDataCamera1 = [NSData]()
        for image in images {
            // let imageData = UIImagePNGRepresentation(image) as NSData?
            let imageData =  image.compressTo(3)
            self.selectedPhotosDataCamera.append(imageData! as NSData)
            self.selectedPhotosDataCamera1.append(imageData! as NSData)
        }
        
        //  dismiss(animated:true, completion: nil)
        
        // imagePicker.dismiss(animated: true, completion: nil)
        
        imagePicker.dismiss(animated: true) {
            self.uploadDataToServer()
        }
        
        //imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated:true, completion: nil)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func uploadDataToServer()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
            UIAlertController.showAlert("Upload media in", message: "Choose any option", buttons: ["New Campaign", "Existing Campaign", "Cancel"], completion: { (alert, index) in
                if index == 0 {
                    self.containCampaign = ""
                    self.uploadCampaignHolderView.isHidden = false
                } else if index == 1 {
                    if self.userOldCampaigns.count == 0 {
                        UIAlertController.showAlert("Alert!", message: "No previous campaign found. Do you want to create a new campaign?", buttons: ["Yes","No"], completion: { (alert, index) in
                            if index == 0 {
                                self.containCampaign = ""
                                self.uploadCampaignHolderView.isHidden = false
                            }
                        })
                    } else {
                        self.containCampaign = ""
                        self.pickerView.reloadAllComponents()
                        self.pickerHolder.isHidden = false
                    }
                } else if index == 2 {
                    self.selectedPhotosDataCamera.removeAll()
                    self.selectedPhotosData.removeAll()
                    self.selectedVideosData.removeAll()
                    self.capturedPhotos.removeAll()
                }
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if picker.sourceType == .camera {
                chosenImage = chosenImage.fixOrientation()
            }
            selectedPhotosData = [NSData]()
            let imageData =  chosenImage.compressTo(3)
            self.selectedPhotosData.append(imageData! as NSData)
        } else {
            let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL
            print(fileURL as Any)
            
//            self.saveVideoToAlbum(fileURL as! URL) { _ in
//                print("Saved video to gallery")
//            }
        //    CustomPhotoAlbum.shared.saveMovieToLibrary(movieURL: fileURL as! URL)
         //   CustomPhotoAlbum.shared.saveVideo(outputURL: fileURL as! URL, toAlbum: UserStore.sharedInstance.title)

            
            let videoData = NSData(contentsOf: fileURL! as URL)
            // Set Video Thumbnail
            selectedVideosData = [NSData]()
            self.selectedVideosData.append(videoData as! NSData)
            // self.uploadDataToServer()
            // self.videoThumbnailImage.image = rotatedImage
        }
        
        dismiss(animated: true) {
            print("=-=-=", self.containCampaign)
            if self.containCampaign == "existing" {
                self.saveDataToExistingCamp()
            }
            else if self.containCampaign == "new" {
                self.saveDataToExistingCampign()
            } else {
                self.uploadDataToServer()
            }
        }
    }
    
    // MARK: - Saved video to Gallery
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }
    
    func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: outputURL, options: nil)
            }) { (result, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved successfully")
                    }
                    completion?(error)
                }
            }
        }
    }
    
    // MARK: - PLACE PICKER DELEGATES
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.addressLbl.text = place.formattedAddress
        if self.addressLbl.text == "Address" && self.addressLbl.text == "" {
            self.addressLbl.textColor = UIColor.lightGray
        }
        else {
            self.addressLbl.textColor = UIColor.black
        }
        
        
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        if #available(iOS 11.0, *) {
        } else {
            // Fallback on earlier versions
        }
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if #available(iOS 11.0, *) {
        } else {
            // Fallback on earlier versions
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - Picker View Delegates
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userOldCampaigns[row].title
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userOldCampaigns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserStore.sharedInstance.title = userOldCampaigns[row].title!
        selectedCampaignID = userOldCampaigns[row].internalIdentifier!
    }
    
    func saveDataToExistingCamp() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            CreateCampaignStore.sharedInstance.sendCampaignData(self.selectedPhotosData as NSArray, self.selectedPhotosDataCamera as NSArray, self.selectedVideosData as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole, "", "", "", "", "", "", "", "", self.selectedCampaignID,  "") { (response) in
                print(response as Any)
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
                    
//                    if self.selectedPhotosDataCamera.count != 0 {
//                        for cameraData in 0..<self.selectedPhotosDataCamera.count {
//                            guard let image = UIImage(data: self.selectedPhotosDataCamera[cameraData] as Data) else { return }
//                            print(image)
//                            CustomPhotoAlbum.shared.save(image: image)
//                        }
//                    }
                    
//                    if self.selectedVideosData.count != 0 {
//                        for videoData in 0..<self.selectedVideosData.count {
//                            guard let video = UIImage(data: self.selectedVideosData[videoData] as Data) else { return }
//                            print(video)
//                            CustomPhotoAlbum.sharedInstance.save(image: video)
//                        }
//                    }
                    
                    SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
                    self.selectedPhotosDataCamera.removeAll()
                    self.selectedPhotosData.removeAll()
                    self.selectedVideosData.removeAll()
                    self.capturedPhotos.removeAll()
                    NewCampaignDetailStore.sharedInstance.createdCampaignId = (self.selectedCampaignID as NSString).integerValue
                    self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: (responseData["message"] as! String))
                }
            }
        }
    }
    
    func saveDataToExistingCampign() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            CreateCampaignStore.sharedInstance.sendCampaignData(self.selectedPhotosData as NSArray, self.selectedPhotosDataCamera as NSArray, self.selectedVideosData as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole, "", "", "", "", "", "", "", "", String(NewCampaignDetailStore.sharedInstance.createdCampaignId),  "") { (response) in
                print(response as Any)
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
                    
//                    if self.selectedVideosData.count != 0 {
//                        for videoData in 0..<self.selectedVideosData.count {
//                            guard let video = UIImage(data: self.selectedVideosData[videoData] as Data) else { return }
//                            print(video)
//                            CustomPhotoAlbum.sharedInstance.save(image: video)
//                        }
//                    }
                    
                    SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
                    self.selectedPhotosDataCamera.removeAll()
                    self.selectedPhotosData.removeAll()
                    self.selectedVideosData.removeAll()
                    self.capturedPhotos.removeAll()
                    //NewCampaignDetailStore.sharedInstance.createdCampaignId = (self.selectedCampaignID as NSString).integerValue
                    self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: (responseData["message"] as! String))
                }
            }
        }
    }
    
    func uploadData()  {
        CreateCampaignStore.sharedInstance.sendCampaignData(selectedPhotosData as NSArray, selectedPhotosDataCamera  as NSArray, selectedVideosData as NSArray , UserStore.sharedInstance.userInfo, "", "", "", "", "", "", "", "", "", String(NewCampaignDetailStore.sharedInstance.createdCampaignId),  "") { (response) in
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
//                        guard  let image = UIImage(data: self.selectedPhotosDataCamera[cameraData] as Data) else { return }
//                        print(image)
//                        CustomPhotoAlbum.shared.save(image: image)
//                    }
//                }
                
//                if self.selectedVideosData.count != 0 {
//                    for videoData in 0..<self.selectedVideosData.count {
//                        guard let video = UIImage(data: self.selectedVideosData[videoData] as Data) else { return }
//                        print(video)
//                        CustomPhotoAlbum.sharedInstance.save(image: video)
//                    }
//                }
                
                SVProgressHUD.showSuccess(withStatus: "Uploaded Successfully")
                self.selectedPhotosDataCamera.removeAll()
                self.capturedPhotos.removeAll()
                self.selectedVideosData.removeAll()
                
            } else {
                self.selectedPhotosDataCamera.removeAll()
                self.capturedPhotos.removeAll()
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
 
}

