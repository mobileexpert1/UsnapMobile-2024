//
//  CampaignPresentViewController.swift
//  Usnap
//
//  Created by CSPC141 on 18/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices
import SVProgressHUD
import AVFoundation
import AVKit


@available(iOS 13.0, *)
class CampaignPresentViewController: AbstractControl, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var waterMarkPaymentLabel: UILabel!
    @IBOutlet var newCampaignLabel: UILabel!
    @IBOutlet var customSizeTextView: UITextView!
    @IBOutlet var animatedPlay: UIButton!
    @IBOutlet var animatedDelete: UIButton!
    @IBOutlet var introPlay: UIButton!
    @IBOutlet var introDelete: UIButton!
    @IBOutlet var conclusionPlay: UIButton!
    @IBOutlet var conclusionDelete: UIButton!
    @IBOutlet var emailAddress: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var agentCodeLabel: UILabel!
    @IBOutlet var smallLogoImage: UIImageView!
    @IBOutlet var previewImageHolder: UIView!
    @IBOutlet var alphaSlider: UISlider!
    @IBOutlet var moveAbleGesture: UIPanGestureRecognizer!
    @IBOutlet var moveAbleLogo: UIImageView!
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var logoBgView: UIView!
    @IBOutlet var backScrollView: UIScrollView!
    //@IBOutlet var bannerAddButton: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bannerHolderView: UIView!
    @IBOutlet var topBar: TopBarView!
    
    
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    
    
    let picker = UIImagePickerController()
    var videoDataArray = [NSData]()
    var animatedVideoData = NSData()
    var introVideoData = NSData()
    var conclusionVideoData = NSData()
    var thumbNailImagesArray = [UIImage]()
    var currentVideoCameraType = NSString()
    var bannerFieldsArray = [UITextField]()
    var bannerCrossButtonsArray = [UIButton]()
    var data: [String] = [""]
    var imageAlpha = String()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        
        
        topBar.leftButton1.isUserInteractionEnabled = false
        topBar.leftButton2.isUserInteractionEnabled = false
        setUI()
        imageAlpha = "1"
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        gestureRecognizer.delegate = self
        moveAbleLogo.addGestureRecognizer(gestureRecognizer)
        let leftTrackImage = UIImage(named: "SlidThumb")
        alphaSlider.setThumbImage( leftTrackImage, for: UIControlState.normal)
    //agentCodeLabel.text = String(format: "%@ %@", "Code:", UserStore.sharedInstance.userDetails.userRefCode!)

        agentCodeLabel.text = String(format: "%@ %@", "Agent Code:", UserStore.sharedInstance.userInfo)
        firstName.text = String(format: "%@ %@", "First Name: ",UserStore.sharedInstance.userDetails.userFirstName!)
        lastName.text = String(format: "%@ %@", "Last Name: ",UserStore.sharedInstance.userDetails.userLastName!)
        emailAddress.text = String(format: "%@ %@", "Email:",UserStore.sharedInstance.userDetails.userEmail!)
        
        newCampaignLabel.actionBlock {
         //self.navigationController?.pushViewController(MediaCollectionViewController.control, animated: true)
            if #available(iOS 13.0, *) {
                self.navigationController?.pushViewController(HomeViewController.control, animated: true)
            } else {
                // Fallback on earlier versions
            }
        }
        getExistingPreset()
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
    
    
    
    
    
    func getExistingPreset()  {
        CreateCampaignStore.sharedInstance.getPreset(UserStore.sharedInstance.userInfo) { (response) in
            if response?.getPresetresponse?.status == "1"{
                if response?.getPresetresponse?.getPresetresult?.count == 0 {
                    SVProgressHUD.showSuccess(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else
                {
                    let aStr = String(format: "%@%@", APIs.KIMAGEBASEURL, (response?.getPresetresponse?.getPresetresult![0].logo!)!)
                    self.smallLogoImage.sd_setImage(with: URL(string: aStr), placeholderImage: UIImage(named: "DummySmallImage"))
                    self.moveAbleLogo.sd_setImage(with: URL(string: aStr), placeholderImage: UIImage(named: "DummySmallImage"))
                    
//                    self.smallLogoImage.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(String(describing: response?.getPresetresponse?.getPresetresult![0].logo!))"), placeholderImage: UIImage(named: "DummySmallImage"))
//                    self.moveAbleLogo.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(String(describing: response?.getPresetresponse?.getPresetresult![0].logo!))"), placeholderImage: UIImage(named: "DummySmallImage"))
                    
                    self.customSizeTextView.text = response?.getPresetresponse?.getPresetresult![0].customSize
                    self.waterMarkPaymentLabel.text =  String(format: "You have to pay $%@ for watermark Logo.", (response?.getPresetresponse?.PriceForWatermark)!)
                    let alphaValue = (response?.getPresetresponse?.getPresetresult![0].opacity! as! NSString).floatValue
                    self.moveAbleLogo.alpha = CGFloat(alphaValue)
                    self.imageAlpha = String(format: "%f", alphaValue)
                    self.alphaSlider.setValue(alphaValue, animated: true)
                    
                    var moveableDimensions = [String]()
                    moveableDimensions = (response?.getPresetresponse?.getPresetresult![0].placeLogo?.seprateRoleStrings((response?.getPresetresponse?.getPresetresult![0].placeLogo)!))! as! [String]
                    
                     print(moveableDimensions)
                    
                    moveableDimensions = (response?.getPresetresponse?.getPresetresult![0].placeLogo?.seprateStringWithCharacter((response?.getPresetresponse?.getPresetresult![0].placeLogo)!, "*"))! as! [String]
                    
             
                   
                    
                    self.moveAbleLogo.frame = CGRect(x:Double(moveableDimensions[0])!, y: Double(moveableDimensions[1])!, width:  Double(self.moveAbleLogo.frame.size.width), height: Double(self.moveAbleLogo.frame.size.height))
                    
                    
                    // CHECK ANIMATED LOGO
                    if response?.getPresetresponse?.getPresetresult![0].animatedLogoFile == "" {
                        self.animatedPlay.isHidden = true
                        self.animatedDelete.isHidden = true
                    }
                    else {
                        let url = NSURL(string: String(format: "%@%@", APIs.KIMAGESPRESETURL, (response?.getPresetresponse?.getPresetresult![0].animatedLogoFile)!))
                        self.animatedVideoData = self.convertUrlToData(url! as URL)
                        self.animatedPlay.isHidden = false
                        self.animatedDelete.isHidden = false
                    }
                
                    // CHECK INTRO VIDEO
                    if response?.getPresetresponse?.getPresetresult![0].introVideo == "" {
                        self.introPlay.isHidden = true
                        self.introDelete.isHidden = true
                    }
                    else {
                        let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOSPRESETURL, (response?.getPresetresponse?.getPresetresult![0].introVideo)!))
                        self.introVideoData = self.convertUrlToData(url! as URL)
                        self.introPlay.isHidden = false
                        self.introDelete.isHidden = false
                    }
                    
                    // CHECK CONCLUSION VIDEO
                    if response?.getPresetresponse?.getPresetresult![0].concludVideo == "" {
                        self.conclusionPlay.isHidden = true
                        self.conclusionDelete.isHidden = true
                    }
                    else {
                        let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOSPRESETURL, (response?.getPresetresponse?.getPresetresult![0].concludVideo)!))
                        self.conclusionVideoData = self.convertUrlToData(url! as URL)
                        self.conclusionPlay.isHidden = false
                        self.conclusionDelete.isHidden = false
                    }
                }
            }
        }
    }
    
    
    func convertUrlToData(_ webUrl: URL) -> NSData  {
        
//        KIMAGESPRESETUR
//KVIDEOSPRESETURL
        
       // let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOBASEURL, webUrl))
        var imgData = NSData()
        do {
            imgData = try NSData(contentsOf: webUrl, options: NSData.ReadingOptions())
            
        } catch {
            print(error)
        }
        return imgData
    }
    
    @objc func handleTap(recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        if let view = recognizer.view {
//            view.center = CGPoint(x:view.center.x + translation.x,
//                                  y:view.center.y + translation.y)
//        }
//
//
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        

        if recognizer.state == .began || recognizer.state == .changed {
            
            let translation = recognizer.translation(in: self.view)
            
            if recognizer.view!.center.x + translation.x >= moveAbleLogo.frame.size.width / 2 && recognizer.view!.center.y + translation.y >= previewImage.frame.origin.y + (moveAbleLogo.frame.size.height / 2) && recognizer.view!.center.x + translation.x <= previewImage.frame.maxX - (moveAbleLogo.frame.size.width / 2) && recognizer.view!.center.y + translation.y <= previewImage.frame.maxY - (moveAbleLogo.frame.size.height / 2) {
                recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            
            // note: 'view' is optional and need to be unwrapped
           
        }
      
        
        
    }

    
//    static func insideDraggableArea(point : CGPoint) -> Bool {
//        return point.x > 50 && point.x < 200 &&
//            point.y > 20 && point.y < 400
//    }

    
     func insideDraggableArea(point : CGPoint) -> Bool {
        return point.x > previewImage.frame.origin.x && point.x < previewImage.frame.origin.x + previewImage.frame.size.width &&
            point.y > previewImage.frame.origin.y && point.y < previewImage.frame.origin.x + previewImage.frame.size.height
    }
    
    @IBAction func handleLogoPan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func setUI()  {
        logoBgView.addBorderlayer(UIColor.gray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addMoreBanner(_ sender: Any) {
        if data.last != "" {
            data.insert("", at: data.count )
           // webSizeTableViewHeightConstaint.constant += 45
        }
//        data.removeLast()
//        data.insert("", at: data.count )
//         webSizeTableViewHeightConstaint.constant += 45
       // webSizeTableView.reloadData()
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
      let joinedString = data.flatMap{ $0 }.joined(separator: ",")
        
        //20/320
        //0.162*320
        
        var xPercentage = Float()
        xPercentage =  Float( moveAbleLogo.frame.origin.x / previewImage.frame.width)
        xPercentage = Float(xPercentage) * Float(previewImage.frame.width)       
        
        var yPercentage = Float()
        yPercentage =  Float(moveAbleLogo.frame.origin.y / previewImage.frame.height)
        yPercentage = Float(yPercentage) * Float(previewImage.frame.height)
      
        CreateCampaignStore.sharedInstance.setPresets(UserStore.sharedInstance.userInfo, String(format: "%f*%f", moveAbleLogo.frame.origin.x, moveAbleLogo.frame.origin.y), UIImagePNGRepresentation(moveAbleLogo.image!)! as NSData, animatedVideoData, introVideoData, conclusionVideoData, customSizeTextView.text!, imageAlpha, "") { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: responseData.value(forKey: "message" ) as? String)
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.popOrDismissViewController(true)
    }
    
    @IBAction func createAnimateLogoClick(_ sender: Any) {
        currentVideoCameraType = "AnimatedLogo"
         self.openPicker_Videos(.photoLibrary)
    }
    
    @IBAction func createIntroVideoClick(_ sender: Any) {
        currentVideoCameraType = "IntroVideo"
         self.openPicker_Videos(.photoLibrary)
    }
    
    @IBAction func addConclusionVideoClick(_ sender: Any) {
        currentVideoCameraType = "ConclusionVideo"
         self.openPicker_Videos(.photoLibrary)
    }
    
    @IBAction func animatedPlay(_ sender: Any) {
           createVideoPlayer(animatedVideoData)
    }
    
    @IBAction func animatedDelete(_ sender: Any) {
       animatedVideoData = NSData()
        animatedPlay.isHidden = true
        animatedDelete.isHidden = true
    }
    
    @IBAction func introPlay(_ sender: Any) {
        createVideoPlayer(introVideoData)
    }
    
    @IBAction func introDelete(_ sender: Any) {
        introVideoData = NSData()
        introPlay.isHidden = true
        introDelete.isHidden = true
    }
    
    @IBAction func conclusionPlay(_ sender: Any) {
        createVideoPlayer(conclusionVideoData)
    }
    
    @IBAction func conclusionDelete(_ sender: Any) {
        conclusionVideoData = NSData()
        conclusionPlay.isHidden = true
        conclusionDelete.isHidden = true
    }
    
    func createVideoPlayer(_ targetData: NSData)  {
        let filePath = documentsPath(forFileName: "video.mp4")
        let fileExists: Bool = FileManager.default.fileExists(atPath: filePath!)
        if !fileExists {
            // your data here
            do {
                var videoAsData = Data()
                videoAsData = targetData as Data
                try videoAsData.write(to: URL(string: filePath!)! as URL)
            } catch {  print(error) }
        }
        
        let player = AVPlayer(url: URL(string: filePath!)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func playServerVideo(_ videoUrl: String)  {
        let url = NSURL(string: String(format: "%@%@", APIs.KVIDEOBASEURL, videoUrl))
        let player = AVPlayer(url: url! as URL as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
    @IBAction func uploadButtonClick(_ sender: Any) {
        self.openPicker_Photos(.photoLibrary)
       // sourceOptions("Photo From Gallery", "Photo From Camera", _dataType: "photo")
    }
    
    @IBAction func removeButtonClick(_ sender: Any) {
        smallLogoImage.image = #imageLiteral(resourceName: "DummyLogo")
        moveAbleLogo.image = #imageLiteral(resourceName: "DummySmallImage")
    }
  
    func sourceOptions(_ firstOption: String, _ secondOption: String, _dataType: String) {
        let alertController = UIAlertController(title: "", message: "Select Type", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: firstOption, style: .default) { (action) in
            if _dataType == "photo" {
                self.openPicker_Photos(.photoLibrary)
            }
            else {
                 self.openPicker_Videos(.photoLibrary)
            }
        }
        let action2 = UIAlertAction(title: secondOption, style: .default) { (action) in
            if _dataType == "photo" {
              self.openPicker_Photos(.camera)
            }
            else {
                self.openPicker_Videos(.camera)
            }
            
        }
      
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openPicker_Photos(_ sourceType: UIImagePickerControllerSourceType)  {
        picker.allowsEditing = false
        picker.sourceType = sourceType
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func openPicker_Videos(_ sourceType: UIImagePickerControllerSourceType)  {
        picker.sourceType = sourceType
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as NSString as String]
        present(picker, animated: true, completion: nil)
    }
    
    
    //MARK: - Image picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            smallLogoImage.image = chosenImage
           // previewImage.image = chosenImage
            moveAbleLogo.image = chosenImage
        }
        else {
            let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL
            
//            self.saveVideoToAlbum(fileURL as! URL) { _ in
//                print("Saved video to gallery")
//            }
        //   CustomPhotoAlbum.shared.saveMovieToLibrary(movieURL: fileURL as! URL)
            
            
            let videoData = NSData(contentsOf: fileURL! as URL)
           
            if currentVideoCameraType == "AnimatedLogo" {
                animatedVideoData = videoData!
                animatedPlay.isHidden = false
                animatedDelete.isHidden = false
            }
            else if currentVideoCameraType == "IntroVideo" {
                introVideoData = videoData!
                introPlay.isHidden = false
                introDelete.isHidden = false
            }
            else  {
                conclusionVideoData = videoData!
                conclusionPlay.isHidden = false
                conclusionDelete.isHidden = false
            }
            
          //  videoDataArray.append(videoData!)
            // Set Video Thumbnail
//            var thumnailImage = UIImage()
//            thumnailImage = thumbnailForVideoAtURL(url:fileURL! )!
//            thumbNailImagesArray.append(thumnailImage)
//            print(thumbNailImagesArray)
        }

        dismiss(animated:true, completion: nil) //5
        
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
    
    // MARK: - Convert Video to thumbnail
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        time.value = min(time.value, 2)
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return  #imageLiteral(resourceName: "DummyVideo")
        }
    }
    
    //MARK:- Delegate of Textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != "" {
            
                let index = data.count
                if index == 0 {
                    data.insert(textField.text!, at: 0)
                } else {
                    data.insert(textField.text!, at: index - 1 )
                }
                //textField.isUserInteractionEnabled = false
              //  webSizeTableViewHeightConstaint.constant += 45
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
          
//            if updatedText != "" {
//                let index = data.count
//                if index == 0 {
//                    data.insert(updatedText, at: 0)
//                } else {
//                    data.insert(updatedText, at: index - 1 )
//                }
//            }
        }
        return true
    }
    
  
    
    @IBAction func alphaSliderChanged(_ sender: UISlider) {
        moveAbleLogo.alpha = CGFloat(sender.value)
        imageAlpha = String(format: "%f", sender.value)
    }
   
    //MARK:- Function of Delete Row
    @objc func deleteRow(sender:UIButton) {
        
//        var finalImageToShare = UIImage()
//
//        UIGraphicsBeginImageContext(previewImageHolder.frame.size)
//        let size = self.previewImageHolder.frame.size
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        previewImageHolder.layer.render(in: UIGraphicsGetCurrentContext()!)
//        finalImageToShare = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//       previewImage.image = finalImageToShare
//        let savedName = getImageName()
//
    
        
        if  sender.tag != 0 {
            self.data.remove(at: sender.tag )
           // webSizeTableViewHeightConstaint.constant -= 45
           // webSizeTableView.reloadData()
        }
    }
  
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL as Any)
        return soundURL as NSURL?
    }
    
    
    func documentsPath(forFileName name: String?) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = paths[0]
        return URL(fileURLWithPath: documentsPath).appendingPathComponent(name!).absoluteString
    }
    
}




//extension CampaignPresentViewController:UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: "WebsizeCustomCell",
//            for: indexPath) as! WebsizeCustomCell
//        cell.webSizeTextField.delegate = self
//        cell.webSizeTextField.text = data[indexPath.row]
//        cell.crossButton.tag = indexPath.row
//        cell.webSizeTextField.tag = indexPath.row
//        cell.crossButton.addTarget(self, action: #selector(deleteRow(sender:)), for: .touchUpInside)
//        return cell
//
//    }
//}


