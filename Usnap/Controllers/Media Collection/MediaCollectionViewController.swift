//
//  MediaCollectionViewController.swift
//  Usnap
//
//  Created by CSPC141 on 17/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import SVProgressHUD
import CoreData
import MobileCoreServices
import ImagePicker
import AVFoundation
import AVKit
import CTAssetsPickerController


@available(iOS 13.0, *)
class MediaCollectionViewController: AbstractControl, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate, userSelectionButtonDelegate, pickerChangedvalueDelegate, completionDelegate, AVCapturePhotoCaptureDelegate, ImagePickerDelegate, CTAssetsPickerControllerDelegate {
   
    
   
    func assetsPickerController(_ picker: CTAssetsPickerController!, didFinishPickingAssets assets: [Any]!) {
        for image in assets {
            if let currentAsset = image as? PHAsset {
                switch currentAsset.mediaType {
                case .image:
                   
                    var chosenImage: UIImage?
                    let manager = PHImageManager.default()
                    let options = PHImageRequestOptions()
                    options.version = .original
                    options.isSynchronous = true
                    manager.requestImageData(for: currentAsset, options: options) { data, _, _, _ in
                        
                        if let data = data {
                            chosenImage = UIImage(data: data)
                            MiscStore.sharedInstance.saveImagesToSandBox(chosenImage!, DateStore.sharedDate.imageNameWithDate()) { (response) in
                                if (response != nil)  {
                                    // For saving to core data
                                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                                        return
                                    }
                                    let managedContext = appDelegate.persistentContainer.viewContext
                                    let entity = NSEntityDescription.entity(forEntityName: "MediaDetail",
                                                                            in: managedContext)!
                                    let person = NSManagedObject(entity: entity,
                                                                 insertInto: managedContext)
                                    
                                    
                                    person.setValue(response, forKeyPath: "mediaName")
                                    person.setValue(self.picConstant, forKeyPath: "mediaType")
                                    person.setValue(UserStore.sharedInstance.userInfo, forKeyPath: "userId")
                                    
                                    do {
                                        try managedContext.save()
                                        
                                    } catch let error as NSError {
                                        print("Could not save. \(error), \(error.userInfo)")
                                    }
                                    var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                    print("\(paths[0])")
                                }
                        }
                    }
                    

            }
                  
                case .video:
             
                    
                    PHImageManager.default().requestAVAsset(forVideo: currentAsset, options: nil, resultHandler: { (asset, mix, nil) in
                        let myAsset = asset as? AVURLAsset
                        do {
                            
                           try DispatchQueue.main.sync {
                                let videoData = try Data(contentsOf: (myAsset?.url)!)
                                // Set Video Thumbnail
                                var thumnailImage = UIImage()
                                thumnailImage = self.thumbnailForVideoFromAsset(asset: currentAsset, size: 400)
                                MiscStore.sharedInstance.saveVideoToSandBox(videoData as NSData, DateStore.sharedDate.videoNameWithDate(), thumnailImage, DateStore.sharedDate.imageNameWithDate(), completion: { (response) in
                                    if (response != nil)  {
                                        var responseArray = NSArray()
                                        responseArray = response!
                                        
                                        // For saving to core data
                                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                                            return
                                        }
                                        let managedContext = appDelegate.persistentContainer.viewContext
                                        let entity = NSEntityDescription.entity(forEntityName: "MediaDetail",
                                                                                in: managedContext)!
                                        let person = NSManagedObject(entity: entity,
                                                                     insertInto: managedContext)
                                        
                                        
                                        person.setValue(responseArray[0], forKeyPath: "mediaName")
                                        person.setValue(self.vidConstant, forKeyPath: "mediaType")
                                        person.setValue(responseArray[1], forKeyPath: "mediaThumbnail")
                                        person.setValue(UserStore.sharedInstance.userInfo, forKeyPath: "userId")
                                        
                                        do {
                                            try managedContext.save()
                                            
                                        } catch let error as NSError {
                                            print("Could not save. \(error), \(error.userInfo)")
                                        }
                                        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        print("\(paths[0])")
                                    }
                                    
                                })
                            }
                        } catch  {
                            print("exception catch at block - while uploading video")
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
    
    func success(_ value: String?) {
        deleteImage()
        self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
    }
    
    func pickerValueSelected(_ pickerValue: String, _ valueId: String) {
        selectCampaignButton.setTitle(pickerValue, for: .normal)
        selectedCampaignID = valueId
    }
    
    func selectedButtonClicked(string: String) {
       
    }
    
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var camersView: UIView!
    @IBOutlet var videosNoDataFound: UILabel!
    @IBOutlet var imagesNotDataFound: UILabel!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var dropDownImage: UIImageView!
    @IBOutlet var selectCampaignButton: UIButton!
    @IBOutlet var videosCollectionView: UICollectionView!
    @IBOutlet var photosCollectionView: UICollectionView!
    
//    var session: AVCaptureSession?
//    var stillImageOutput: AVCaptureStillImageOutput?
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var imagesMutableArray = NSMutableArray()
    var userOldImages = [NewCampaignDataimages]()
    var userOldVideos = [NewCampaignDatavideos]()
    var userOldCampaigns = [NewCampaignDatacampaign]()
    var mediaDetail: [NSManagedObject] = []
    var videoDetail: [NSManagedObject] = []
    var imagesCounter = [Int]()
    var videosCounter = [Int]()
    var picker = UIImagePickerController()
    
    var selectedPhotosData = [NSData]()
    var selectedVideosData = [NSData]()
    
    var picConstant = "Pic"
    var vidConstant = "Vid"
    var selectedCampaignID = String()
    var imagePickerController = ImagePickerController()
    var cameraScreenType = String()
    
    
    // MARK: - Class Functions
    class func Control(_ value: String) -> MediaCollectionViewController {
        let control = self.control as! MediaCollectionViewController
        control.cameraScreenType = value
        return control
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
               button.setImage(UIImage(named: "Tick"), for: .normal)
               button.addTarget(self, action: #selector(RightbButtonPressed), for: .touchUpInside)
               button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
               let barButton = UIBarButtonItem(customView: button)
               self.navigationItem.rightBarButtonItem = barButton
        
//        topBar.delegate = self
        setUI()
        picker.delegate = self
        if cameraScreenType == "Camers" {
            self.openPicker_Photos(.photoLibrary)
        }
        else {
            QuickAcessPopUpViewController.showCustomControl(controller: self)
        }
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
        nc.removeObserver(self)
        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.ITEMPICKERNOTIFICATION_KEY_CAMPAIGN),
                       object:nil, queue:nil,
                       using:catchNotification_PickerView)
        nc.addObserver(self, selector: #selector(catchNotification_HomeActions), name: Notification.Name(rawValue:ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
  
    
    func catchNotification_PickerView(notification:Notification) -> Void {
        NotificationCenter.default.removeObserver(self)
        guard let userInfo = notification.userInfo,
            let selectedValue  = userInfo["selectedValue"] as? String else {
                return
        }
        selectCampaignButton.setTitle(selectedValue, for: .normal)
        selectedCampaignID = userInfo["SelectedIndex"]! as! String
    }

    @objc func catchNotification_HomeActions(notification:Notification) -> Void {
            let nc = NotificationCenter.default
         nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
        guard let userInfo = notification.userInfo,
            let buttonText  = userInfo["ButtonAction"] as? String else {
                return
        }
        if buttonText == "Camera" {
            
             self.openPicker_Photos(.photoLibrary)
            
        // sourceOptions(.camera)
        }

        if buttonText == "gallery" {
            
            let picker = CTAssetsPickerController()
            picker.delegate = self
            if UI_USER_INTERFACE_IDIOM() == .pad {
                picker.modalPresentationStyle = .formSheet
            }
            present(picker, animated: true) {() -> Void in }
           //sourceOptions(.photoLibrary)
        }

        if buttonText == "createCampaign" {
           //CrateCampaignPopUpViewController.showControl()
            let control = CrateCampaignPopUpViewController.control as! CrateCampaignPopUpViewController
            control.delegate = self
            UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        }

        if buttonText == "campaignList" {
            if #available(iOS 13.0, *) {
                navigationController?.pushViewController(HomeViewController.control, animated: true)
            } else {
                // Fallback on earlier versions
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCampaignData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.removeObserver(self)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.HOMEPOPNOTIFICATION_KEY), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//         NotificationCenter.default.removeObserver(self)
//        let nc = NotificationCenter.default
    }
    
    @IBAction func deleteMultiple(_ sender: Any) {
        
            deleteImage()
        
    }
    
    @IBAction func selectAllClick(_ sender: Any) {
        
        if  mediaDetail.count == 0 {
            return
        }
        
        if imagesCounter.count == mediaDetail.count {
           imagesCounter = [Int]()
        }
        else {
            imagesCounter = [Int]()
            for i in 0 ..< mediaDetail.count {
                imagesCounter.append(i)
            }
        }
        
        if imagesCounter.count == mediaDetail.count {
            selectAllButton.setTitle("Unselect all",for: .normal)
        }
        else {
            selectAllButton.setTitle("Select all",for: .normal)
        }
        
        photosCollectionView.reloadData()
    }
    
    
    func deleteImage()  {
        if  mediaDetail.count == 0 {
            return
        }
        
        //  DELETE IMAGES
        for item in imagesCounter {
            let moc = self.getContext()
            let person = self.mediaDetail[(item)]
            let myImageName = person.value(forKeyPath: "mediaName") as! String
            moc.delete(person)
            do {
                try moc.save()
                imagesCounter.remove(at: imagesCounter.index(of:item)!)
                self.removeFromSandbox(itemName:myImageName)
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        
        // DELETE VIDEOS
        
        for item in videosCounter {
            let moc = self.getContext()
            let person = self.mediaDetail[(item)]
            
            //            let person = self.videoDetail[(item)]
            let myImageName = person.value(forKeyPath: "mediaName") as! String
            let myVideoName = person.value(forKeyPath: "mediaThumbnail") as! String
            moc.delete(person)
            do {
                try moc.save()
                let tempArray = [myImageName, myVideoName]
                for i in 0..<tempArray.count {
                    self.removeFromSandbox(itemName:tempArray[i])
                }
                videosCounter.remove(at: videosCounter.index(of:item)!)
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        
        if imagesCounter.count == mediaDetail.count {
            selectAllButton.setTitle("Unselect all",for: .normal)
        }
        else {
            selectAllButton.setTitle("Select all",for: .normal)
        }
        
        self.fetchLocalMediaFiles()
    }
    
    func fetchCampaignData() {
        CreateCampaignStore.sharedInstance.getDataForNewCampaign(UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole) { (response) in
            if response?.newCampaignDataresponse?.status == "1" {
                self.userOldCampaigns = (response?.newCampaignDataresponse?.newCampaignDataresult?.newCampaignDatacampaign)!
                MiscDetailStore.sharedInstance.staffMembers = (response?.newCampaignDataresponse?.newCampaignDataresult?.newCampaignDatastaffMembers)!
                self.fetchLocalMediaFiles()
            }  else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func fetchLocalMediaFiles()  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MediaDetail")
        //fetchRequest.predicate = NSPredicate(format: "mediaType == %@", picConstant)
       // let fetchRequestVideo = NSFetchRequest<NSManagedObject>(entityName: "MediaDetail")
       // fetchRequestVideo.predicate = NSPredicate(format: "mediaType == %@", vidConstant)
        do {
            mediaDetail = try managedContext.fetch(fetchRequest)
            //videoDetail = try managedContext.fetch(fetchRequestVideo)
            self.photosCollectionView.reloadData()
            //self.videosCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        if mediaDetail.count == 0 {
            imagesNotDataFound.isHidden = false
        }
        else {
            imagesNotDataFound.isHidden = true
        }
        
        if videoDetail.count == 0 {
            videosNoDataFound.isHidden = false
        }
        else {
            videosNoDataFound.isHidden = true
        }
        
    }
        
//    func fetchLocalMediaFiles()  {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MediaDetail")
//        fetchRequest.predicate = NSPredicate(format: "mediaType == %@", picConstant)
//        let fetchRequestVideo = NSFetchRequest<NSManagedObject>(entityName: "MediaDetail")
//        fetchRequestVideo.predicate = NSPredicate(format: "mediaType == %@", vidConstant)
//        do {
//            mediaDetail = try managedContext.fetch(fetchRequest)
//            videoDetail = try managedContext.fetch(fetchRequestVideo)
//            self.photosCollectionView.reloadData()
//            self.videosCollectionView.reloadData()
//        } catch let error as NSError {
//        }
//
//
//
//        if mediaDetail.count == 0 {
//            imagesNotDataFound.isHidden = false
//        }
//        else {
//            imagesNotDataFound.isHidden = true
//        }
//
//        if videoDetail.count == 0 {
//            videosNoDataFound.isHidden = false
//        }
//        else {
//            videosNoDataFound.isHidden = true
//        }
//
//    }
    
    func setUI()  {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func proceedButtonClick(_ sender: Any) {
        
        if selectedCampaignID == "" || imagesCounter.count == 0 && videosCounter.count == 0  {
            SVProgressHUD.showError(withStatus: "please select campaign name and images or videos")
        }
        else {
            selectedPhotosData = [NSData]()
            selectedVideosData = [NSData]()
                        
            // CONVERT IMAGES TO DATA
            if imagesCounter.count != 0 {
                for indexValue in  imagesCounter {
                    let person = mediaDetail[indexValue]
                    let imageName = person.value(forKeyPath: "mediaName") as! String
                    let imagePath = fileInDocumentsDirectory(filename: imageName)
                    if let loadedImage = dataFromPath(path: imagePath) {
                        selectedPhotosData.append(loadedImage)
                    } else { print("some error message 2") }
                }
            }
 
            // CONVERT VIDEOS TO DATA
            
            if videosCounter.count != 0 {
                for indexValue in videosCounter {
                    let person = mediaDetail[indexValue]
//                    let person = videoDetail[indexValue]
                    let imageName = person.value(forKeyPath: "mediaName") as! String
                    let imagePath = fileInDocumentsDirectory(filename: imageName)
                    if let loadedVideo = dataFromPath_video(path: imagePath) {
                        selectedVideosData.append(loadedVideo)
                    } else { print("some error message 2") }
                }
            }
            
            CreateCampaignStore.sharedInstance.sendCampaignData(selectedPhotosData as NSArray, selectedPhotosData as NSArray, selectedVideosData as NSArray, UserStore.sharedInstance.userInfo, UserStore.sharedInstance.userRole, "", "", "", "", "", "", "", "", selectedCampaignID,  "") { (response) in
                print(response!)
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
                    
//                    if self.selectedVideosData.count != 0 {
//                        for videoData in 0..<self.selectedVideosData.count {
//                            guard let video = UIImage(data: self.selectedVideosData[videoData] as Data) else { return }
//                            print(video)
//                            CustomPhotoAlbum.shared.save(image: video)
//                        }
//                    }
                    
                    
                    
                    SVProgressHUD.showSuccess(withStatus: "Campaign Created Successfully")
                    NewCampaignDetailStore.sharedInstance.createdCampaignId = Int(self.selectedCampaignID)! 
                    self.deleteImage()
                    self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
                    
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    func changeImageOrientation(orientation:UIDeviceOrientation,cgImage:CGImage) -> UIImage {
        let image: UIImage!
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
    
    @IBAction func createNewCampaign(_ sender: Any) {
        NewCampaignDetailStore.sharedInstance.mediaDetail = mediaDetail
        NewCampaignDetailStore.sharedInstance.videoDetail = videoDetail
        NewCampaignDetailStore.sharedInstance.selectedPhotosIndexes = imagesCounter
        NewCampaignDetailStore.sharedInstance.selectedVideosIndexes = videosCounter
        let control = CrateCampaignPopUpViewController.control as! CrateCampaignPopUpViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
    }
    
    // MARK: - Collection View Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.tag == 1 {
//            return mediaDetail.count
//        }
//        return videoDetail.count
        
        return mediaDetail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // FOR IMAGES
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollection", for: indexPath as IndexPath) as! MediaCollectionViewCell
            let person = mediaDetail[indexPath.row]
            if person.value(forKeyPath: "mediaType") as! String == picConstant {
                let imageName = person.value(forKeyPath: "mediaName") as! String
                let imagePath = fileInDocumentsDirectory(filename: imageName)
                if let loadedImage = loadImageFromPath(path: imagePath) {
                    cell.cellImage.isUserInteractionEnabled = true
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapImage(_:)))
                    cell.cellImage.tag = indexPath.row
                    cell.cellImage.addGestureRecognizer(longGesture)
                    cell.cellImage.image = loadedImage as UIImage
                } else { print("some error message 2") }
                
                if imagesCounter.contains(indexPath.row){
                    cell.tickImageView.image = #imageLiteral(resourceName: "Tick")
                }
                else{
                    cell.tickImageView.image = #imageLiteral(resourceName: "UnTick")
                }
                cell.playButton.isHidden = true
            }
                
                // FOR VIDEOS
            else {
                let imageName = person.value(forKeyPath: "mediaThumbnail") as! String
                let imagePath = fileInDocumentsDirectory(filename: imageName)
                if let loadedImage = loadImageFromPath(path: imagePath) {
                    
                    cell.cellImage.image = loadedImage as UIImage
                } else { print("some error message 2") }
                
                if imagesCounter.contains(indexPath.row){
                    cell.tickImageView.image = #imageLiteral(resourceName: "Tick")
                }
                else{
                    cell.tickImageView.image = #imageLiteral(resourceName: "UnTick")
                }
                cell.cellImage.isUserInteractionEnabled = true
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapVideo(_:)))
                cell.cellImage.addGestureRecognizer(longGesture)
                cell.playButton.isHidden = false
            }
            
            cell.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            cell.playButton.tag = indexPath.row
            
            return cell
        }
        
        
       
        // FOR VIDEOS
        
        if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaVideosCollection", for: indexPath as IndexPath) as! MediaVideosCollectionViewCell
            let person = videoDetail[indexPath.row]
            let imageName = person.value(forKeyPath: "mediaThumbnail") as! String
            let imagePath = fileInDocumentsDirectory(filename: imageName)
            if let loadedImage = loadImageFromPath(path: imagePath) {
                
                cell.cellImage.image = loadedImage as UIImage
            } else { print("some error message 2") }
            
            if videosCounter.contains(indexPath.row){
                cell.tickImageView.image = #imageLiteral(resourceName: "Tick")
            }
            else{
                cell.tickImageView.image = #imageLiteral(resourceName: "UnTick")
            }
            cell.cellImage.isUserInteractionEnabled = true
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapVideo(_:)))
            cell.cellImage.addGestureRecognizer(longGesture)
         
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaVideosCollection", for: indexPath as IndexPath) as! MediaVideosCollectionViewCell
        return cell
    }
    
    
    @objc func playButtonTapped(sender: UIButton!) {
        let person = mediaDetail[sender.tag]
        let fileName = person.value(forKeyPath: "mediaName") as! String
        let filePath = documentsPath(forFileName: fileName)
        let player = AVPlayer(url: URL(string: filePath!)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
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
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @objc func longTapImage(_ sender: UIGestureRecognizer){
//        print(sender.view?.tag as Any)
//        if sender.state == .ended {
//            print("UIGestureRecognizerStateEnded")
//
//            sourceOptions((sender.view?.tag)!, "photo")
//
//            //Do Whatever You want on End of Gesture
//        }
//        else if sender.state == .began {
//            print("UIGestureRecognizerStateBegan.")
//            //Do Whatever You want on Began of Gesture
//        }
    }
    
    @objc func longTapVideo(_ sender: UIGestureRecognizer){
//        if sender.state == .ended {
//            print("UIGestureRecognizerStateEnded")
//            sourceOptions((sender.view?.tag)!, "video")
//            //Do Whatever You want on End of Gesture
//        }
//        else if sender.state == .began {
//            print("UIGestureRecognizerStateBegan.")
//            //Do Whatever You want on Began of Gesture
//        }
    }
    
    
    func sourceOptions( _ tagValue: Int, _ dataType: String) {
        let alertController = UIAlertController(title: "", message: "Do you want to delete this item", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "yes", style: .default) { (action) in
            // FOR PHOTOS
            if dataType == "photo" {
                let moc = self.getContext()
                let person = self.mediaDetail[(tagValue)]
                let myImageName = person.value(forKeyPath: "mediaName") as! String
                moc.delete(person)
                do {
                    try moc.save()
                    self.removeFromSandbox(itemName:myImageName)
                } catch let error as NSError {
                    print("Error While Deleting Note: \(error.userInfo)")
                }
            }
                // FOR VIDEO
            else {
                let moc = self.getContext()
                let person = self.videoDetail[(tagValue)]
                let myImageName = person.value(forKeyPath: "mediaName") as! String
                let myVideoName = person.value(forKeyPath: "mediaThumbnail") as! String
                moc.delete(person)
                do {
                    try moc.save()
                    let tempArray = [myImageName, myVideoName]
                    for i in 0..<tempArray.count {
                      self.removeFromSandbox(itemName:tempArray[i])
                    }
                    
                } catch let error as NSError {
                    print("Error While Deleting Note: \(error.userInfo)")
                }
            }
        }
        let action2 = UIAlertAction(title: "No", style: .default) { (action) in
            
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func removeFromSandbox(itemName:String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItem(atPath: filePath)
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainBounds.width/3.55, height: UIScreen.mainBounds.width/3.55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // For Images Collection view
        if collectionView.tag == 1 {
             let person = mediaDetail[indexPath.row]
            if imagesCounter.contains(indexPath.row){
                let index = imagesCounter.index(of: indexPath.row)
//                if person.value(forKeyPath: "mediaType") as! String == picConstant {
                   imagesCounter.remove(at: index!)
//                }
//                else {
                 //  videosCounter.remove(at: index!)
                //}
                
                photosCollectionView.reloadItems(at: [indexPath])
            }
            else{
                // if person.value(forKeyPath: "mediaType") as! String == picConstant {
                    imagesCounter.append(indexPath.row)
//                }
//                 else {
//                    videosCounter.append(indexPath.row)
//                }
                photosCollectionView.reloadItems(at: [indexPath])
            }
            if imagesCounter.count == mediaDetail.count {
                selectAllButton.setTitle("Unselect all",for: .normal)
            }
            else {
                selectAllButton.setTitle("Select all",for: .normal)
            }
            
            
        }
        // For Videos Collection view
        if collectionView.tag == 2 {
            if videosCounter.contains(indexPath.row){
                let index = videosCounter.index(of: indexPath.row)
                videosCounter.remove(at: index!)
                videosCollectionView.reloadItems(at: [indexPath])
            }
            else{
                videosCounter.append(indexPath.row)
                videosCollectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    
    //MARK: - Image picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        if var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if picker.sourceType == .camera {
                chosenImage = chosenImage.fixOrientation()
            }
         
            
            // self.changeImageOrientation(orientation:orientation,cgImage: cgImaCGImageRef
            MiscStore.sharedInstance.saveImagesToSandBox(chosenImage, DateStore.sharedDate.imageNameWithDate()) { (response) in
                if (response != nil)  {
                    // For saving to core data
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "MediaDetail",
                                                            in: managedContext)!
                    let person = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                    
                    
                    person.setValue(response, forKeyPath: "mediaName")
                    person.setValue(self.picConstant, forKeyPath: "mediaType")
                    person.setValue(UserStore.sharedInstance.userInfo, forKeyPath: "userId")
                    
                    do {
                        try managedContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    print("\(paths[0])")
                }
            }
            
        } else {
            let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL
            
//            self.saveVideoToAlbum(fileURL as! URL) { _ in
//                print("Saved video to gallery")
//            }
          //  CustomPhotoAlbum.shared.saveMovieToLibrary(movieURL: fileURL as! URL)
          //  CustomPhotoAlbum.shared.saveVideo(outputURL: fileURL as! URL, toAlbum: UserStore.sharedInstance.title)

            
            let videoData = NSData(contentsOf: fileURL! as URL)
            // Set Video Thumbnail
            var thumnailImage = UIImage()
            thumnailImage = thumbnailForVideoAtURL(url:fileURL! )!
           // thumnailImage = thumnailImage.fixOrientation()
            
            if picker.sourceType == .camera {
                thumnailImage = ImageStore.sharedDate.rotateImage(thumnailImage, clockwise: true)
            }
            
            
            MiscStore.sharedInstance.saveVideoToSandBox(videoData!, DateStore.sharedDate.videoNameWithDate(), thumnailImage, DateStore.sharedDate.imageNameWithDate(), completion: { (response) in
                if (response != nil)  {
                    var responseArray = NSArray()
                    responseArray = response!
                    
                    // For saving to core data
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "MediaDetail",
                                                            in: managedContext)!
                    let person = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                    
                    
                    person.setValue(responseArray[0], forKeyPath: "mediaName")
                    person.setValue(self.vidConstant, forKeyPath: "mediaType")
                    person.setValue(responseArray[1], forKeyPath: "mediaThumbnail")
                    person.setValue(UserStore.sharedInstance.userInfo, forKeyPath: "userId")
                    
                    do {
                        try managedContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    print("\(paths[0])")
                }
               
            })
           // self.videoThumbnailImage.image = rotatedImage
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

    

    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        time.value = min(time.value, 2)
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return #imageLiteral(resourceName: "DummyVideo")
        }
    }
    

        
    func thumbnailForVideoFromAsset(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale

        let retinaSquare = CGSize(width: size * retinaScale, height: size * retinaScale )
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
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

    

    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
 
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
        
    }
    
    func dataFromPath_video(path: String) -> NSData? {
        let contents = NSData(contentsOfFile: path)
        if contents == nil {
            print("missing image at: \(path)")
        }
        return contents
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL as NSURL
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
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
    
    
    @IBAction func campaignButtonSelected(_ sender: Any) {
       
        if userOldCampaigns.count == 0 {
            SVProgressHUD.showError(withStatus: "No previous campaign found")
        }
        else {
            MiscDetailStore.sharedInstance.pickerTye = ""
            MiscDetailStore.sharedInstance.pickerDataOldCampaigns =  userOldCampaigns
            let control = CustomPickerViewController.control as! CustomPickerViewController
            control.delegate = self
            UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        }
        
        
//       _ =  CustomPickerViewController.showControl("oldCampaign")
    }
    

    
    // MARK: - Top Bar Delegates
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        //sourceOptions(.camera)
        
        
        self.openPicker_Photos(.photoLibrary)
        
        
       // self.openPicker_Videos(.camera)
    }
    
    @IBAction func shootVideoButton(_ sender: Any) {
        self.openPicker_Videos(.camera)
    }
    
    @objc func RightbButtonPressed() {
        
        let picker = CTAssetsPickerController()
        picker.delegate = self
        if UI_USER_INTERFACE_IDIOM() == .pad {
            picker.modalPresentationStyle = .formSheet
        }
        present(picker, animated: true) {() -> Void in }
        
        //self.openPicker_Photos(.photoLibrary)
       // sourceOptions(.photoLibrary)
    }
    
   
    
    
    func sourceOptions(_ sourceType: UIImagePickerControllerSourceType) {
        let alertController = UIAlertController(title: "", message: "Select type", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.openPicker_Photos(sourceType)
        }
        let action2 = UIAlertAction(title: "Video", style: .default) { (action) in
            self.openPicker_Videos(sourceType)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    let imagePicker = ImagePickerController()
   
    func openPicker_Photos(_ sourceType: UIImagePickerControllerSourceType)  {
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
//        var configuration = Configuration()
        let configuration = ImagePickerConfiguration()
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
    
    func openPicker_Videos(_ sourceType: UIImagePickerControllerSourceType)  {
        picker.sourceType = sourceType
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as NSString as String]
        
      // picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker, animated: true, completion: nil)
    }
    
 
    public var imageAssets: [UIImage] {
        return AssetManager.resolveAssets(imagePicker.stack.assets)
    }
                                                                                                             
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        
        for image in images {
            MiscStore.sharedInstance.saveImagesToSandBox(image, DateStore.sharedDate.imageNameWithDate()) { (response) in
                if (response != nil)  {
                    // For saving to core data
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "MediaDetail",
                                                            in: managedContext)!
                    let person = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                    person.setValue(response, forKeyPath: "mediaName")
                    person.setValue(self.picConstant, forKeyPath: "mediaType")
                    person.setValue(UserStore.sharedInstance.userInfo, forKeyPath: "userId")
                    
                    do {
                        try managedContext.save()
                        
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    print("\(paths[0])")
                }
            }
        }
        
        // self.changeImageOrientation(orientation:orientation,cgImage: cgImaCGImageRef
        
        
        
      //  dismiss(animated:true, completion: nil)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
         dismiss(animated:true, completion: nil)
        imagePickerController.dismiss(animated: true, completion: nil)
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
