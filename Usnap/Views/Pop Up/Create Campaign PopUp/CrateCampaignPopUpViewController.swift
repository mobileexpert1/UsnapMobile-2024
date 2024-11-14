//
//  CrateCampaignPopUpViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import GooglePlaces
import GooglePlacePicker
import GooglePlacesSearchController

protocol completionDelegate: class {
    func success(_ value: String?)
}

class CrateCampaignPopUpViewController: AbstractControl, UIActionSheetDelegate, pickerChangedvalueDelegate, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
   
    

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var chooseCatagoryButton: UIButton!
    @IBOutlet var staffMemberButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var holderView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var campaignTitleTF: UITextField!
    
    var selectedStaffName = String()
    var selectedStaffId = String()
    var selectedMediaPics = [NSData]()
    var selectedMediaPicsCamera = [NSData]()
    var selectedMediaVideos = [NSData]()
    var selectedCampaignTypeName = String()
    var selectedCampaignTypId = String()
    var placesClient: GMSPlacesClient!
    weak var delegate: completionDelegate?
  
    class func showControl(){
        let control = self.control
        UIApplication.appWindow.addSubview(control.view)
        control.view.addConstraintToFillSuperview()
    }
    
    override func viewDidLoad() {
        self.bgImageBool = false
        super.viewDidLoad()
        setUI()
        holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4) {
            self.holderView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        placesClient = GMSPlacesClient.shared()
        backButton.touchUpInsideBlock {
            if  SVProgressHUD.isVisible() {
            }else {
                UIView.animate(withDuration: 0.4, animations: {
                    self.holderView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }, completion: { (completed) in
                    self.view.removeFromSuperview()
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
        
        addressLabel.actionBlock {
//                   let autocompleteController = GMSAutocompleteViewController()
//                    autocompleteController.delegate = self
//                    self.present(autocompleteController, animated: true, completion: nil)
            
            
//            self.placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//                if let error = error {
//                    print("Current Place error: \(error.localizedDescription)")
//                    return
//                }
//
//
//
//                if let placeLikelihoodList = placeLikelihoodList {
//                    let place = placeLikelihoodList.likelihoods.first?.place
//                    if let place = place {
//                        print("->>>>>>>>>>>",place.name )
//
//                    }
//                }
//            })

            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self 
            
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue))!
            autocompleteController.placeFields = fields
            
            
            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            autocompleteController.autocompleteFilter = filter
            
            // Display the autocomplete view controller.
            self.present(autocompleteController, animated: true, completion: nil)
        

            
            
            
        }
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        
        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_STAFF),
                       object:nil, queue:nil,
                       using:catchNotification)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeFromParentViewController()
        self.dismiss(animated: true, completion: nil)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func catchNotification(notification:Notification) -> Void {
        guard let userInfo = notification.userInfo,
            let selectedValue  = userInfo["selectedValue"] as? String else {
                return
        }
        staffMemberButton.setTitle(selectedValue, for: .normal)
        selectedStaffName = selectedValue
        selectedStaffId = userInfo["SelectedIndex"]! as! String
    }

    
    func setUI()  {
        addressLabel.addBorder(pinkBorderColor)
        
        campaignTitleTF.addBorder(pinkBorderColor)
        
        if UserStore.sharedInstance.userRole == "3" {
           staffMemberButton.isUserInteractionEnabled = true
            staffMemberButton.backgroundColor = UIColor.white
        }
        else {
            staffMemberButton.isUserInteractionEnabled = false
            staffMemberButton.backgroundColor = UIColor.lightGray
        }
       
        
    }
    @IBAction func chooseCatagoryClick(_ sender: Any) {
        
        if MiscDetailStore.sharedInstance.allCatories.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
        }
        else {
            MiscDetailStore.sharedInstance.pickerTye = "Catagories"
            let control = CustomPickerViewController.control as! CustomPickerViewController
            control.delegate = self
            UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        }
        
      
    }
   
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        print("REMOVEDDDDDDDDDDDDDD")
//        self.removeFromParentViewController()
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if  SVProgressHUD.isVisible() {
            return
        }
        //        if selectedCampaignTypId == "" {
//            SVProgressHUD.showError(withStatus: "Please fill all the fields")
//            return
//        }
        
      //  if selectedCampaignTypId == "1" {
            if campaignTitleTF.text == "" && addressLabel.text == "Address" && addressLabel.text == ""  {
                SVProgressHUD.showError(withStatus: "Please fill all the fields")
                return
            }
        //}
//        else {
//            if campaignTitleTF.text == ""  {
//                SVProgressHUD.showError(withStatus: "Please fill all the fields")
//                return
//            }
//        }
        
        self.view.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
       
        
       selectedMediaPics = NewCampaignDetailStore.sharedInstance.selectedPics
       selectedMediaPicsCamera = NewCampaignDetailStore.sharedInstance.selectedPicsCamera
       selectedMediaVideos = NewCampaignDetailStore.sharedInstance.selectedVids
        
        NewCampaignDetailStore.sharedInstance.selectedPics.removeAll()
        NewCampaignDetailStore.sharedInstance.selectedPicsCamera.removeAll()
        NewCampaignDetailStore.sharedInstance.selectedVids.removeAll()
        
//        // CONVERT IMAGES TO DATA
//        if NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes.count != 0 {
//            for indexValue in NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes {
//                let person = NewCampaignDetailStore.sharedInstance.mediaDetail[indexValue]
//                if person.value(forKeyPath: "mediaType") as! String == "Pic" {
//                    let imageName = person.value(forKeyPath: "mediaName") as! String
//                    let imagePath = fileInDocumentsDirectory(filename: imageName)
//                    if let loadedImage = dataFromPath(path: imagePath) {
//                        selectedPhotosData.append(loadedImage)
//                    } else { print("some error message 2") }
//                }
//
//                else {
//                    let imageName = person.value(forKeyPath: "mediaName") as! String
//                    let imagePath = fileInDocumentsDirectory(filename: imageName)
//                    if let loadedVideo = dataFromPath_video(path: imagePath) {
//                        selectedVideosData.append(loadedVideo)
//                    } else { print("some error message 2") }
//                }
//
//            }
//        }
        
        // CONVERT VIDEOS TO DATA
        
//        if NewCampaignDetailStore.sharedInstance.selectedVideosIndexes.count != 0 {
//            for indexValue in NewCampaignDetailStore.sharedInstance.selectedVideosIndexes {
//                let person = NewCampaignDetailStore.sharedInstance.videoDetail[indexValue]
//                let imageName = person.value(forKeyPath: "mediaName") as! String
//                let imagePath = fileInDocumentsDirectory(filename: imageName)
//                if let loadedVideo = dataFromPath_video(path: imagePath) {
//                    selectedVideosData.append(loadedVideo)
//                } else { print("some error message 2") }
//            }
//        }
        
      
        var addressText  = String()
        if addressLabel.text == "Address" {
            addressText = ""
        }
        else {
            addressText = addressLabel.text!
        }
        
        
        CreateCampaignStore.sharedInstance.sendCampaignData(selectedMediaPics as NSArray, selectedMediaPicsCamera as NSArray,selectedMediaVideos as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole , campaignTitleTF.text!, String(format: "%@ %@", addressText, ""), "", "", "", "", selectedCampaignTypId, selectedStaffId, "",  "") { (response) in
            print(response!)
            let responseData = response?["response"] as! NSDictionary
            
            
            
            self.selectedMediaPics.removeAll()
            NewCampaignDetailStore.sharedInstance.selectedPics.removeAll()
            self.selectedMediaPicsCamera.removeAll()
            NewCampaignDetailStore.sharedInstance.selectedPicsCamera.removeAll()
            self.selectedMediaVideos.removeAll()
            NewCampaignDetailStore.sharedInstance.selectedVids.removeAll()
            
            
            
            
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
                NewCampaignDetailStore.sharedInstance.createdCampaignId = (responseData["result"] as! NSDictionary).value(forKey: "campaign_id") as! Int
                 self.delegate?.success("1")
                self.view.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
                
//                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let controllerToBePresented = self.storyboard?.instantiateViewController(withIdentifier: "CrateCampaignPopUpViewController") as! CrateCampaignPopUpViewController
//                appDelegate.switchControllers(viewControllerToBeDismissed: self, controllerToBePresented: controllerToBePresented)
                
            //UIApplication.visibleNavigationController.pushViewController(CampaignPreviewViewController.control, animated: true)
                
            //UIApplication.visibleNavigationController.pushViewController(CampaignDetailViewController.control, animated: true)
                
            } else {
                SVProgressHUD.showError(withStatus: "Only one video is allowed per campaign")
            }
        }
    }
    
    deinit {
        print("closeddddddddddddd 11111111")
    }
    
//    @IBAction func saveButtonClick(_ sender: Any) {
//        
//        if campaignTitleTF.text == "" || addressLabel.text == "" || selectedCampaignTypId == "" {
//            SVProgressHUD.showError(withStatus: "Please fill all the fields")
//            return
//        }
//        
//        print(NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes)
//        
//        // CONVERT IMAGES TO DATA
//        if NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes.count != 0 {
//            for indexValue in NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes {
//                let person = NewCampaignDetailStore.sharedInstance.mediaDetail[indexValue]
//                let imageName = person.value(forKeyPath: "mediaName") as! String
//                let imagePath = fileInDocumentsDirectory(filename: imageName)
//                if let loadedImage = dataFromPath(path: imagePath) {
//                    selectedPhotosData.append(loadedImage)
//                } else { print("some error message 2") }
//            }
//        }
//        
//        // CONVERT VIDEOS TO DATA
//        
//        if NewCampaignDetailStore.sharedInstance.selectedVideosIndexes.count != 0 {
//            for indexValue in NewCampaignDetailStore.sharedInstance.selectedVideosIndexes {
//                let person = NewCampaignDetailStore.sharedInstance.videoDetail[indexValue]
//                let imageName = person.value(forKeyPath: "mediaName") as! String
//                let imagePath = fileInDocumentsDirectory(filename: imageName)
//                if let loadedVideo = dataFromPath_video(path: imagePath) {
//                    selectedVideosData.append(loadedVideo)
//                } else { print("some error message 2") }
//            }
//        }
//        
//        
//        CreateCampaignStore.sharedInstance.sendCampaignData(selectedPhotosData as NSArray, selectedVideosData as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole , campaignTitleTF.text!, String(format: "%@ %@", addressLabel.text!, "STREET NAME"), "", "STATE NAME", "COUNTRY NAME", "POSTAL CODE", selectedCampaignTypId, selectedStaffId, "",  "") { (response) in
//            print(response!)
//            let responseData = response?["response"] as! NSDictionary
//            if responseData["status"] as! String == "1" {
//                SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
//                NewCampaignDetailStore.sharedInstance.createdCampaignId = (responseData["result"] as! NSDictionary).value(forKey: "campaign_id") as! Int
//                self.view.removeFromSuperview()
//                self.dismiss(animated: true, completion: nil)
//                self.delegate?.success("1")
//                //UIApplication.visibleNavigationController.pushViewController(CampaignPreviewViewController.control, animated: true)
//                
//                
//                
//                //UIApplication.visibleNavigationController.pushViewController(CampaignDetailViewController.control, animated: true)
//            } else {
//                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
//            }
//        }
//    }
    
    

    
    
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL as NSURL
    }
    
    func dataFromPath(path: String) -> NSData? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        let data = UIImagePNGRepresentation(image!)
        return data as NSData?
    }
    
    
    func dataFromPath_video(path: String) -> NSData? {
        let contents = NSData(contentsOfFile: path)
        if contents == nil {
            print("missing image at: \(path)")
        }
        return contents
    }
    
    
    
    
    @IBAction func staffMemberClicked(_ sender: Any) {
       //
        if  MiscDetailStore.sharedInstance.staffMembers.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
        }
        else {
            MiscDetailStore.sharedInstance.pickerTye = "StaffMembers"
            let control = CustomPickerViewController.control as! CustomPickerViewController
            control.delegate = self
            UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        }
        
       
        
           // _ =  CustomPickerViewController.showControl("StaffMembers")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("crashhhhhhhhhhhhhhhhhhhhhh")
        NewCampaignDetailStore.sharedInstance.selectedPics.removeAll()
        NewCampaignDetailStore.sharedInstance.selectedPicsCamera.removeAll()
        NewCampaignDetailStore.sharedInstance.selectedVids.removeAll()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        if MiscDetailStore.sharedInstance.pickerTye == "Catagories" {
            chooseCatagoryButton.setTitle(pickerValue, for: .normal)
            selectedCampaignTypeName = (pickerValue as NSString) as String
            selectedCampaignTypId = valueId
            if valueId == "1" {
                addressLabel.backgroundColor = UIColor.clear
                addressLabel.isUserInteractionEnabled = true
            }
            else {
                addressLabel.backgroundColor = UIColor.lightGray
                addressLabel.isUserInteractionEnabled = false
                clearFields()
            }
        }
        else
        {
            staffMemberButton.setTitle(pickerValue, for: .normal)
            selectedStaffName = (pickerValue as NSString) as String
            selectedStaffId = valueId
        }
    }
    
    func clearFields()  {
        self.addressLabel.textColor = UIColor.lightGray
        addressLabel.text = "Address"
    }
    
    
     // MARK: - PLACE PICKER DELEGATES
    
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
//        dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }

    
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.addressLabel.text = place.formattedAddress
        if self.addressLabel.text == "Address" && self.addressLabel.text == "" {
            self.addressLabel.textColor = UIColor.lightGray
        }
        else {
          self.addressLabel.textColor = UIColor.black
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
