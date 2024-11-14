//
//  AddVideoViewController.swift
//  Usnap
//
//  Created by CSPC141 on 16/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI
import MobileCoreServices
import SVProgressHUD
import AVKit

class AddVideoViewController: AbstractControl, AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    
    
    
    @IBOutlet var saveButton: UIButton!
    var player: AVAudioPlayer?
    @IBOutlet var playRecording: UIButton!
    @IBOutlet var deleteRecording: UIButton!
    @IBOutlet var noDataFoundLabel: UILabel!
    @IBOutlet var videoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var videosCollectionView: UICollectionView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var conclusionButton: UIButton!
    @IBOutlet var introductoryVideoButton: UIButton!
    @IBOutlet var radioButtonAnimatedLogo: UIButton!
    @IBOutlet var radioButtonWaterMark: UIButton!
    @IBOutlet weak var topBarViews: TopBarView!
    
    var videoDataArray = [NSData]()
    var RecordedDataArray = [NSData]()
    var recoredFile = NSData()
    var thumbNailImagesArray = [UIImage]()
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    let picker = UIImagePickerController()
    var filePath: URL!
    var watermarkLogo : String = "0"
    var animatedLogo : String = "0"
    var introductoryVideo : String = "0"
    var conclusionVideo : String = "0"
    var existingAudio =  String()
    var existingVideo =  String()
    
    
    class func Control(_ audio: String, _ video: String) -> AddVideoViewController {
        let control = self.control as! AddVideoViewController
        control.existingAudio = audio
        control.existingVideo = video
        return control
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        centeredNavBarImageView()
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(AddVideoViewController.barButtonDidTap(_:)))
        
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        picker.delegate = self
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isUserInteractionEnabled = true
                    } else {
                        SVProgressHUD.showError(withStatus: "Please set microphone permissions in setting to record a file")
                        self.recordButton.isUserInteractionEnabled = false
                    }
                }
            }
        } catch {  print("failed to record!") }
        
        // Audio Settings
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        print(existingAudio)
        print(existingVideo)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
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
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordSound(_ sender: Any) {
        if existingAudio != "" {
            UIAlertController.showAlert("Alert!", message: "This campaign already has a audio. If you upload another audio, the previous one will be replaced. Are you sure you want to continue?", buttons: ["Yes","NO"], completion: { (alert, index) in
                print(index)
                if index == 0 {
                    self.setUpRecording()
                }
            })
            
        }
        else {
            setUpRecording()
        }
        
        
        
        
        
        //        if existingAudio != "" {
        //            SVProgressHUD.show(withStatus: "This campaign already has a audio. If you upload another audio, the previous one will be replaced. Are you sure you want to continue?")
        //        }
        //        else {
        //            setUpRecording()
        //        }
        
    }
    
    
    func setUpRecording() {
        if audioRecorder == nil {
            self.recordButton.setTitle("Stop", for: UIControlState.normal)
            self.startRecording()
            self.playRecording.isHidden = true
            self.deleteRecording.isHidden = true
        } else {
            self.recordButton.setTitle("Record Audio File", for: UIControlState.normal)
            self.finishRecording(success: true)
            self.playRecording.isHidden = false
            self.deleteRecording.isHidden = false
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                
                // if you want to filter the directory contents you can do like this:
                let mp3Files = directoryContents.filter{ $0.pathExtension == "m4a" }
                print("mp3 urls:",mp3Files)
                do {
                    let weatherData = try NSData(contentsOf: mp3Files[0], options: NSData.ReadingOptions())
                    recoredFile = weatherData
                    filePath  = mp3Files[0]
                    
                    
                    // Prepare to play
                    
                    do {
                        let url = filePath
                        player = try AVAudioPlayer(contentsOf: url!)
                        
                        player?.prepareToPlay()
                        let audioSession = AVAudioSession.sharedInstance()
                        do {
                            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                        }
                        catch let sessionError {
                            print(sessionError)
                        }
                    } catch let songPlayerError {
                        print(songPlayerError)
                    }
                    
                    // Prepare to play
                    
                    
                } catch { print("ERROR IN SOUND FILE")
                    
                }
            } catch {
                
            }
        }
        
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    
    
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            print(success)
        } else {
            audioRecorder = nil
            SVProgressHUD.showError(withStatus: "Somthing Wrong.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbNailImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddVideoCollectionViewCell", for: indexPath as IndexPath) as! AddVideoCollectionViewCell
        cell.thumbnailImageView.image = thumbNailImagesArray[indexPath.row]
        cell.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        cell.playButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(videoDeleteButton), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    
    @objc func videoDeleteButton(sender: UIButton!) {
        deleteOptioins(sender.tag)
        
    }
    
    func deleteOptioins(_ tag: Int) {
        let alertController = UIAlertController(title: "", message: "Do you want to delete this Video", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.videoDataArray.remove(at: tag)
            self.thumbNailImagesArray.remove(at: tag)
            self.noDataFoundLabelShowHide()
            self.videosCollectionView.reloadData()
            
        }
        let action2 = UIAlertAction(title: "No", style: .default) { (action) in
            
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = saveButton
            popoverPresentationController.sourceRect = saveButton.bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func playButtonTapped(sender: UIButton!) {
        
        let filePath = documentsPath(forFileName: "video.mp4")
        let fileExists: Bool = FileManager.default.fileExists(atPath: filePath!)
        if !fileExists {
            // your data here
            do {
                var videoAsData = Data()
                videoAsData = videoDataArray[sender.tag] as Data
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
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        RecordedDataArray.removeAll()
        if recoredFile.length != 0 {
            RecordedDataArray.append(recoredFile)
        }
        
        submitData()
    }
    
    
    @IBAction func deleteClick(_ sender: Any) {
        UIAlertController.showAlert("Alert!", message: "Are you sure", buttons: ["Cancel", "Delete"], completion: { (alert, index) in
            print(index)
            if index == 1 {
                self.RecordedDataArray.removeAll()
                self.playRecording.isHidden = true
                self.deleteRecording.isHidden = true
            }
            else {
                
            }
        })
        
        
        
        
    }
    
    @IBAction func playClick(_ sender: Any) {
        
        if playRecording.currentImage == #imageLiteral(resourceName: "PauseVideo") {
            player?.pause()
            playRecording.setImage(#imageLiteral(resourceName: "PlayRecording"), for: UIControlState())
        }
        else {
            player?.play()
            playRecording.setImage(#imageLiteral(resourceName: "PauseVideo"), for: UIControlState())
        }
        
        
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        playRecording.setImage(#imageLiteral(resourceName: "PlayRecording"), for: UIControlState())
        // Your code here
        do {
            let url = filePath
            player = try AVAudioPlayer(contentsOf: url!)
            
            player?.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch let sessionError {
                print(sessionError)
            }
        } catch let songPlayerError {
            print(songPlayerError)
        }
        
    }
    
    
    //    @IBAction func playClick(_ sender: Any) {
    //        let url = filePath
    //        do {
    //            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
    //            try AVAudioSession.sharedInstance().setActive(true)
    //
    //            let player = try AVAudioPlayer(contentsOf: url!)
    //
    //            player.play()
    //
    //        } catch let error {
    //        }
    //    }
    
    
    func submitData()  {
        CreateCampaignStore.sharedInstance.mediaSupportingFiles(UserStore.sharedInstance.userInfo, RecordedDataArray as NSArray,videoDataArray as NSArray, String(NewCampaignDetailStore.sharedInstance.createdCampaignId), "", watermarkLogo, animatedLogo, introductoryVideo, conclusionVideo) { (response) in
            print(response as Any)
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                
                
                if responseData.value(forKey: "message" ) as? String == "please add preset first" {
                    SVProgressHUD.showError(withStatus: "To upload watermark logo please add preset first in the profile screen")
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: responseData.value(forKey: "message" ) as? String)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.popOrDismissViewController(true)
                    }
                }
                // SVProgressHUD.showSuccess(withStatus: responseData.value(forKey: "message" ) as? String)
            }
            else {
                SVProgressHUD.showError(withStatus: responseData.value(forKey: "message" ) as? String)
            }
        }
    }
    
    @IBAction func addVideoClips(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            showVideoOptionsAfterPermissions()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.showVideoOptionsAfterPermissions()
                } else {
                    UIAlertController.showAlert("Alert!", message: "Please allow for camera in app settings", buttons: ["OK"], completion: { (alert, index) in
                    })
                }
            })
        }
    }
    
    func showVideoOptionsAfterPermissions()  {
        if existingVideo != "" {
            UIAlertController.showAlert("Alert!", message: "This campaign already has a video. If you upload another video, the previous one will be replaced. Are you sure you want to continue?", buttons: ["Yes","NO"], completion: { (alert, index) in
                print(index)
                if index == 0 {
                    self.sourceOptions()
                }
            })
            
        }
        else {
            sourceOptions()
        }
    }
    
    @IBAction func waterMarkLogoClick(_ sender: Any) {
        if radioButtonWaterMark.currentImage == #imageLiteral(resourceName: "Tick") {
            radioButtonWaterMark.setImage(#imageLiteral(resourceName: "UnTick"), for: .normal)
            watermarkLogo = "0"
        }
        else {
            radioButtonWaterMark.setImage(#imageLiteral(resourceName: "Tick"), for: .normal)
            watermarkLogo = "1"
        }
        //        radioButtonWaterMark.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
        //        radioButtonAnimatedLogo.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
        //        watermarkLogo = "1"
        //        animatedLogo = "0"
    }
    
    @IBAction func animatedLogoClick(_ sender: Any) {
        radioButtonWaterMark.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
        radioButtonAnimatedLogo.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
        watermarkLogo = "0"
        animatedLogo = "1"
    }
    
    @IBAction func introductionVideoClick(_ sender: UIButton) {
        changeCheckBox(targetButton: introductoryVideoButton)
        introductoryVideo = introductoryVideo.makeOppositeString(introductoryVideo)
    }
    
    @IBAction func conclusionButtonClick(_ sender: UIButton) {
        changeCheckBox(targetButton: conclusionButton)
        conclusionVideo = conclusionVideo.makeOppositeString(conclusionVideo)
    }
    
    func changeCheckBox(targetButton: UIButton)  {
        if targetButton.currentImage == #imageLiteral(resourceName: "Tick") {
            targetButton.setImage(UIImage(named: "UnTick"), for: .normal)
        }
        else {
            targetButton.setImage(UIImage(named: "Tick"), for: .normal)
        }
    }
    
    // MARK: - Image Picker
    
    func sourceOptions() {
        let alertController = UIAlertController(title: "", message: "Select type", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "From camera", style: .default) { (action) in
            self.openPicker_Videos(.camera)
        }
        let action2 = UIAlertAction(title: "From Gallery", style: .default) { (action) in
            self.openPicker_Videos(.photoLibrary)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = saveButton
            popoverPresentationController.sourceRect = saveButton.bounds
        }
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openPicker_Videos(_ sourceType: UIImagePickerControllerSourceType)  {
        picker.sourceType = sourceType
        picker.delegate = self
         self.picker.videoQuality = .typeHigh
        picker.mediaTypes = [kUTTypeMovie as NSString as String]
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Image picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            SVProgressHUD.showError(withStatus: Constants.PHOTOONLY_ERROR)
        } else {
            let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL
            
//            self.saveVideoToAlbum(fileURL as! URL) { _ in
//                print("Saved video to gallery")
//            }
        //    CustomPhotoAlbum.shared.saveMovieToLibrary(movieURL: fileURL as! URL)
            //CustomPhotoAlbum.shared.saveVideo(outputURL: fileURL as! URL, toAlbum: UserStore.sharedInstance.title)

            
            let videoData = NSData(contentsOf: fileURL! as URL)
            videoDataArray.append(videoData!)
            // Set Video Thumbnail
            var thumnailImage = UIImage()
            thumnailImage = thumbnailForVideoAtURL(url:fileURL! )!
            thumbNailImagesArray.append(thumnailImage)
            
            noDataFoundLabelShowHide()
            
            videosCollectionView.reloadData()
        }
        // self.videoThumbnailImage.image = rotatedImage
        
        dismiss(animated:true, completion: nil)
    }
    
    func noDataFoundLabelShowHide()  {
        if thumbNailImagesArray.count == 0 {
            noDataFoundLabel.isHidden = false
            videosCollectionView.isHidden = true
        }
        else {
            noDataFoundLabel.isHidden = true
            videosCollectionView.isHidden = false
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
            return  #imageLiteral(resourceName: "DummyVideo")
        }
    }
}
