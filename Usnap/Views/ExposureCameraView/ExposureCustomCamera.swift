//
//  ExposureCustomCamera.swift
//  updatedCamera
//
//  Created by CSPC141 on 06/08/19.
//  Copyright © 2019 CSPC141. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

protocol ExposureCustomCameraDelegate {
    func getAllExposures(_ imagesData : [NSData])
}

@available(iOS 11.0, *)
@available(iOS 11.0, *)
class ExposureCustomCamera: NSObject, AVCapturePhotoCaptureDelegate {
    
    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var device:AVCaptureDevice!
    var exposureValues:[Float]!
    var exposureTimeValues = [CMTime]()
    var imageCounter = Int()
    var capturedImages = [NSData]()
    var deviceCurrentDuration = CMTime()
    var delegate : ExposureCustomCameraDelegate?
    let window = UIWindow()
    var currentViewControl = UIViewController()
    
    var tempImageHolder = UIImage()
    
    static let shared = ExposureCustomCamera()
    private override init() {
        
    }
    
    
    func beginCamera(_ targetView: UIView, _ currentVC: UIViewController) {
        print(NewCampaignDetailStore.sharedInstance.selectedCameraType)
        currentViewControl = currentVC
        // Do any additional setup after loading the view, typically from a nib.
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        var deviceTypes = [AVCaptureDevice.DeviceType]()
        
         if NewCampaignDetailStore.sharedInstance.selectedCameraType == "Wide" {
            deviceTypes = [.builtInWideAngleCamera]
        }
        else if NewCampaignDetailStore.sharedInstance.selectedCameraType == "UltraWide" {
            if #available(iOS 13.0, *) {
                deviceTypes = [.builtInUltraWideCamera]
            } else {
               deviceTypes = [.builtInWideAngleCamera]
            }
        }
        
        
        
        
        
        
        
        
        
        if #available(iOS 11.1, *) {
        
            
            
            let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: AVMediaType.video, position: .back).devices
            
//            let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInTrueDepthCamera], mediaType: AVMediaType.video, position: .back).devices
//             let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTelephotoCamera], mediaType: AVMediaType.video, position: .back).devices
            device = availableDevices.first
        } else {
            // Fallback on earlier versions
            device = AVCaptureDevice.default(for: .video)!
        }
        
        if let input = try? AVCaptureDeviceInput(device: device!) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    let connection = cameraOutput.connection(with: AVFoundation.AVMediaType.video)
                    connection?.videoOrientation = .portrait
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    self.previewLayer.frame = targetView.frame
                    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                    setOutputOrientation
                    targetView.layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                 }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
        exposureTimeValues.removeAll()
        exposureValues = calculateExposureRange()
        calculateTimeRange()
        previewLayer?.frame.size = targetView.frame.size
    }
    
    
    func removeAllFromMemory() {
        captureSesssion.stopRunning()
        captureSesssion = nil
        previewLayer = nil
        device = nil
        cameraOutput = nil
        exposureTimeValues.removeAll()
        exposureValues.removeAll()
    }
    
    
    func changeExposure(isoVal: Float, time: CMTime) {
        //MARK: SET CUSTOM EXPOSURE
        do {
            // Lock Camera Configuration
            try device.lockForConfiguration()
            
            // Modify CAM Parameters
            print(time)
            device.setExposureModeCustom(duration: time, iso: AVCaptureDevice.currentISO) { (CMTime) in
                AVCaptureDevice.ExposureMode.custom
            }
            //Unlock Camera Configuration
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func calculateExposureRange() -> [Float]{
        // Determine ISO Range
        let activeFormat = device.activeFormat
        let minISO = activeFormat.minISO
        let maxISO = activeFormat.maxISO
        // Generate Exposure Array
        let ISOStepSize:Float = Float(maxISO - minISO)/8
        var ISOValues:[Float] = [minISO]
        for i in 0 ... 7 {
            ISOValues.append(ISOValues[i] + ISOStepSize)
        }
        return(ISOValues)
    }
    
    //
    //    func calculateTimeRange() -> [CMTime]{
    //        // Determine ISO Range
    //
    //
    //        let activeFormat = device.activeFormat
    //        let minTime = activeFormat.minExposureDuration
    //        let maxTime = activeFormat.maxExposureDuration
    //        print(minTime)
    //        print(maxTime)
    //
    //        var minFloatValue = Float64()
    //        var maxFloatValue = Float64()
    //        minFloatValue  = CMTimeGetSeconds(activeFormat.minExposureDuration)
    //        maxFloatValue = CMTimeGetSeconds(activeFormat.maxExposureDuration)
    //        print(minFloatValue)
    //        print(maxFloatValue)
    //
    //        var timeDifference = Float64()
    //        timeDifference = maxFloatValue - minFloatValue
    //        timeDifference = timeDifference / 9
    //
    ////        var differenceFloat = Float()
    ////
    ////       differenceFloat =  Float(CMTimeGetSeconds(timeDifference))
    ////        differenceFloat = differenceFloat / 8
    //
    //        var timeValues: [Float64] = [minFloatValue]
    //        var finalTimesArray = [CMTime]()
    //
    //
    //        for i in 0 ... 8 {
    //             timeValues.append(timeValues[i] + timeDifference)
    //        }
    //        print(timeValues)
    //        for i in 0 ..< timeValues.count {
    //            let newExposureTime = CMTimeMakeWithSeconds(Float64(timeValues[i]), preferredTimescale: 1000*1000*1000)
    //            finalTimesArray.append(newExposureTime)
    //        }
    //
    //        print(timeValues)
    //         print(finalTimesArray)
    //
    //
    //
    //        print(timeValues)
    //        return(finalTimesArray)
    //
    //    }
    
    
    func calculateTimeRange() {
        // Determine ISO Range
        //         var timeValues = [0.5,0.10,0.17,0.24,0.31,0.38,0.45,0.52,0.59,0.66,0.73,0.80,0.87,0.94,1]
        //var timeValues = [900,0.10,0.18,0.32,0.45,0.59,0.72,0.86,1]
        
        let timeValues = [0.5,0.01,0.10,0.21,0.26,0.35,0.40,0.49,0.59]
        
        // (AUTO) - 0.05 - 0.12 - 0.23 - 0.34 - 0.45, - 0.56 - 0.67 - 0.78- 0.89 - 1.0
        // 0.05,0.19,0.33,0.47,0.61,0.75,0.89,1
        for i in 0 ..< timeValues.count {
            var dummyTime = CMTime()
            dummyTime = getTimeDuration(value: Float(timeValues[i]))
            exposureTimeValues.append(dummyTime)
        }
    }
    
    func getTimeDuration(value: Float) -> CMTime {
        let exposureDurationPower:Float = 4.0
        let exposureMininumDuration:Float64 = 1.0/2000.0
        let p = Float64(pow(value, exposureDurationPower)) // Apply power function to expand slider's low-end range
        let minDurationSeconds = Float64(max(CMTimeGetSeconds(device.activeFormat.minExposureDuration), exposureMininumDuration))
        let maxDurationSeconds = Float64(CMTimeGetSeconds(device.activeFormat.maxExposureDuration))
        let newDurationSeconds = Float64(p * (maxDurationSeconds - minDurationSeconds)) + minDurationSeconds // Scale from 0-1 slider range to actual duration
        let newExposureTime = CMTimeMakeWithSeconds(Float64(newDurationSeconds), 1000*1000*1000)
        return newExposureTime
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let imageSize: Int = imageData!.count
        print(imageSize)
        
        tempImageHolder = UIImage(data: (imageData! as NSData) as Data)!

        print("Angle Image = ",angle)
        
        if angle != 0 {
            tempImageHolder = tempImageHolder.rotateImage(radians: angle)
        }
        
        tempImageHolder = tempImageHolder.fixedOrientationOfImage()!
        
        // -- To save images in one created campaign folder
      //  CustomPhotoAlbum.shared.save(image: tempImageHolder)
     
        
        // -- Create usnap folder and created campaign name album and save images to that album
        PhotoManager.instance.saveImageToAlbumInRootFolder(image: tempImageHolder) { (error) in
             // Handle error
        }
        
        //Change by Sham And comment above line 
        //tempImageHolder = UIImage(cgImage: tempImageHolder.cgImage!, scale: tempImageHolder.scale, orientation: .up)
        
        capturedImages.append(tempImageHolder.compressTo(2)! as NSData)
        
        print("Data saved", imageCounter)
        
        if imageCounter < exposureTimeValues.count {
            changeExposure(isoVal: exposureValues[imageCounter], time: exposureTimeValues[imageCounter])
            // usleep(1000000)
            usleep(200000)
            imageCounter = imageCounter + 1
            startCapturing()
        }
        else {
            // SVProgressHUD.dismiss()
            do {
                // Lock Camera Configuration
                try device.lockForConfiguration()
                device.exposureMode = .continuousAutoExposure
                //device.focusMode = .continuousAutoFocus
                device.isFocusModeSupported(.continuousAutoFocus)

                // Unlock Camera Configuration
                device.unlockForConfiguration()
            } catch {
                print(error.localizedDescription)
            }
            print("start new programmmmmmmmmmm")
            imageCounter = 0
            self.delegate?.getAllExposures(capturedImages)
            capturedImages.removeAll()
        }
        //        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func setOutputOrientation() {
        var outputOrientation: AVCaptureVideoOrientation!
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            outputOrientation = AVCaptureVideoOrientation.landscapeRight
        }
            
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            outputOrientation = AVCaptureVideoOrientation.landscapeLeft
        }
            
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            outputOrientation = AVCaptureVideoOrientation.portrait
        }
            
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            outputOrientation = AVCaptureVideoOrientation.portraitUpsideDown
        }
        
        self.previewLayer.connection?.videoOrientation = outputOrientation!
    }
    
    func rotateImage(image:UIImage) -> UIImage {
        var rotatedImage = UIImage()
        switch image.imageOrientation {
        case .right:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .down)
            
        case .down:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .left)
            
        case .left:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            
        default:
            rotatedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .right)
        }
        
        return rotatedImage
    }
    
    func getImageFromSampleBuffer(buffer:CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right )
            }
        }
        return nil  //if it doesn't work return a nil
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            currentViewControl.present(alert, animated: true)
        } else {
            //
            //            if imageCounter < exposureTimeValues.count {
            //                changeExposure(isoVal: exposureValues[imageCounter], time: exposureTimeValues[imageCounter])
            
            //                imageCounter = imageCounter + 1
            //                startCapturing()
            //            }
            //            else {
            //                //SVProgressHUD.dismiss()
            //                do {
            //                    // Lock Camera Configuration
            //                    try device.lockForConfiguration()
            //                    device.exposureMode = .continuousAutoExposure
            //                    device.focusMode = .continuousAutoFocus
            //                    // Unlock Camera Configuration
            //                    device.unlockForConfiguration()
            //                } catch {
            //                    print(error.localizedDescription)
            //                }
            //                print("start new programmmmmmmmmmm")
            //                imageCounter = 0
            //
            //                self.delegate?.getAllExposures(capturedImages)
            //
            //                let alert = UIAlertController(title: "Done", message: "Completed", preferredStyle: .alert)
            //                alert.addAction(UIAlertAction(title: "OK", style: .default))
            //               currentViewControl.present(alert, animated: true)
            //
            //}
        }
    }
    
    func captureClick()  {
        // SVProgressHUD.show()
        imageCounter = 0
        // usleep(2000000)
        usleep(20000)
        deviceCurrentDuration = device.exposureDuration
        exposureTimeValues[0] = deviceCurrentDuration
        
        do {
            // Lock Camera Configuration
            try device.lockForConfiguration()
            device.exposureMode = .custom
            //device.focusMode = .locked
            device.isFocusModeSupported(.continuousAutoFocus)
            // Unlock Camera Configuration
            device.unlockForConfiguration()
        } catch {
            print(error.localizedDescription)
        }
        changeExposure(isoVal: exposureValues[imageCounter], time: exposureTimeValues[imageCounter])
        //usleep(1000000)
        usleep(200000)
        imageCounter = imageCounter + 1
        
        
        startCapturing()
    }
    
    
    func startCapturing()  {
        //        if let photoOutputConnection = CustomCamera.photoOutput.connection(with: AVMediaType.video) {
        //            photoOutputConnection.videoOrientation = videoDeviceOrientation
        //        }
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // This method you can use somewhere you need to know camera permission   state
    func askPermission() {
        let cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraPermissionStatus {
        case .authorized:
            print("Authorized")
        case .denied:
            
            let alert = UIAlertController(title: "Sorry :(" , message: "But could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            
            currentViewControl.present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("Camera Permission = Restricted")
        default:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                
                if granted == true {
                    // User granted
                    DispatchQueue.main.async(){
                        //Do smth that you need in main thread
                    }
                }
                else {
                    // User Rejected
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self!.currentViewControl.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
}

extension UIImage {
    func rotateImage(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
}
