//
//  ApiStore.swift
//  Usnap
//
//  Created by CSPC141 on 19/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMarketingKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

class ApiStore {
    
    static let shared = ApiStore()
    
    var showProgress: Bool = true
    var retry: Int = 0
    var showError = true
    var controller = UIViewController()
    
    class var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func requestBaseAPI(_ url: URLConvertible, parameters: Parameters? = nil, completion: @escaping (_ : BaseAPIModel) -> Void) {
        requestAPI(url, parameters: parameters, completion: { (dict) in
            let baseModel = BaseAPIModel.init(object: dict!)
            completion (baseModel)
        })
    }
    
    func requestDict(_ url: URLConvertible, parameters: Parameters? = nil, completion: @escaping (_ : BaseAPIModel, _ : NSDictionary?) -> Void) {
        requestAPI(url, parameters: parameters, completion: { (dict) in
            let baseModel = BaseAPIModel.init(object: dict!)
            completion (baseModel, dict)
        })
    }
    
    
    // MARK:- Alamofire common function to get dictionary.
    func requestAPI(_ url: URLConvertible, parameters: Parameters? = nil, requestType: HTTPMethod? = nil, completion: @escaping (_ : NSDictionary?) -> Void) {
        
        print(url)
        
        if NetworkReachabilityManager()!.isReachable {
            if showProgress && !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            } else {
                showProgress = true
            }
            
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.request(url,method: requestType ?? .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
                print(response)
                SVProgressHUD.dismiss()
                if response.response?.statusCode == 200 {
                    self.getValidDict(result: response.result, completion: {(dict, error, retry) in
                        if retry! {
                            self.requestAPI(url, parameters: parameters, completion: completion)
                            return
                        }
                        let errorMessage = "Some error has been occured"
                        if dict == nil {
                            SVProgressHUD.show()
                            
                            SVProgressHUD.showError(withStatus: error != nil ? error?.localizedDescription : errorMessage)
                        } else {
                            print(dict)
                            print(dict?["response"])
                            let response = dict?["response"] as! NSDictionary
                            if (response["status"] as! String != "1") {
                                if (response["status"] as! String != "4"){
                                    SVProgressHUD.show()
                                    SVProgressHUD.setDefaultMaskType(.clear)
                                    SVProgressHUD.showError(withStatus: errorMessage)
                                }
                            }
                            
                            else {
                                self.showError = true
                            }
                        }
                        completion (dict)
                    })
                } else if response.response?.statusCode == 401 {
                    self.getValidDict(result: response.result, completion: {(dict, error, retry) in
                        if retry! {
                            self.requestAPI(url, parameters: parameters, completion: completion)
                            return
                        }
                        let errorMessage = "Some error has been occured"
                        if dict == nil {
                            SVProgressHUD.show()
                            
                            SVProgressHUD.showError(withStatus: error != nil ? error?.localizedDescription : errorMessage)
                        } else {
                            let response = dict?["response"] as! NSDictionary
                            if response["status"] as! String != "1" {
                                SVProgressHUD.show()
                                SVProgressHUD.setDefaultMaskType(.clear)
                                // SVProgressHUD.showError(withStatus: errorMessage)
                                UIAlertController.showAlert("Alert", message: "Token expired", buttons: ["Ok"]) { _, index in
                                    if index == 0 {
                                        self.goToLogin()
                                    }
                                }
                            } else {
                                self.showError = true
                            }
                        }
                        completion (dict)
                    })
                }
                
            }
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.INTERNETNOTAVALIABLE)
        }
    }
    
    //MARK:- Upload Images
    
    func uploadImage(endUrl: String, imageDataArray: NSMutableArray, parameters: [String : Any], completion: @escaping (_ : NSDictionary?) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showProgress && !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            } else {
                showProgress = true
            }
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                // import image to request
                for imageData in imageDataArray {
                    var tempData = Data()
                    tempData = imageData as! Data
                    multipartFormData.append(tempData , withName: "files", fileName: "files.jpg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: endUrl,
                             
                             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        SVProgressHUD.showProgress(Float(Progress.fractionCompleted), status: "Uploading")
                        SVProgressHUD.setDefaultMaskType(.clear)
                    })
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        completion (response.result.value as? NSDictionary)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                }
            })
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.INTERNETNOTAVALIABLE)
        }
    }
    
    //MARK:- Upload Images
    
    func uploadImageAndVideo(endUrl: String, imageDataArray: NSArray, imageDataArrayCamera: NSArray,  videosDataArray: NSArray, parameters: [String : Any], completion: @escaping (_ : NSDictionary?) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            
            if showProgress && !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            } else {
                showProgress = true
            }
            
            // UPLOAD IMAGES
            Alamofire.upload(multipartFormData: { multipartFormData in
                var imagesInt = Int()
                imagesInt = 0
                for imageData in imageDataArray {
                    var tempData = Data()
                    tempData = imageData as! Data
                    multipartFormData.append(tempData , withName: String(format: "files%d", imagesInt), fileName: String(format: "files%d.jpeg", imagesInt), mimeType: "jpeg")
                    imagesInt = imagesInt + 1
                }
                
                // UPLOAD VIDEOS
                
                for imageData in videosDataArray {
                    var tempData = Data()
                    tempData = imageData as! Data
                    multipartFormData.append(tempData , withName: String(format: "files%d", imagesInt), fileName: String(format: "files%d.MOV", imagesInt), mimeType: "MOV")
                    imagesInt = imagesInt + 1
                    
                    
                    //                    var imageSize: Int = tempData.count
                    //                    print("video size ------- of image in KB: %f ", Double(imageSize) / 1000.0)
                }
                
                
                // UPLOAD CAMERA
                
                for imageData in imageDataArrayCamera {
                    var tempData = Data()
                    tempData = imageData as! Data
                    multipartFormData.append(tempData , withName: String(format: "camerafiles%d", imagesInt), fileName: String(format: "camerafiles%d.jpeg", imagesInt), mimeType: "jpeg")
                    imagesInt = imagesInt + 1
                }
                
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: endUrl,
                             
                             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    //                    var uploadedMediaCounter = Int64()
                    //                    uploadedMediaCounter = 1
                    //
                    //                    var totalMediabytes = Int64()
                    //                    var perImageByteCount = Int64()
                    //
                    //                    var allMediaFilesCount = Int64()
                    //                    allMediaFilesCount = Int64(imageDataArray.count + imageDataArrayCamera.count + videosDataArray.count)
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(String(describing: Progress.fractionCompleted))")
                        
                        
                        SVProgressHUD.showProgress(Float(Progress.fractionCompleted), status: "Uploading")
                        
                        SVProgressHUD.setDefaultMaskType(.clear)
                        
                        //                        var compltedString:String = String(format:"%f", Progress.fractionCompleted)
                        //                         print("Upload Progress111: \(compltedString)")
                        //                        compltedString.remove(at: compltedString.startIndex)
                        //                        compltedString.remove(at: compltedString.startIndex)
                        //                         print("Upload Progress111: \(compltedString)")
                        //
                        //                        var completedValue = Double()
                        //                        completedValue = Double(compltedString)!
                        //
                        //
                        //
                        //                        totalMediabytes = Progress.totalUnitCount
                        //                        perImageByteCount = Progress.totalUnitCount / allMediaFilesCount
                        //
                        //                        if Progress.completedUnitCount >= (perImageByteCount * uploadedMediaCounter) {
                        //                            uploadedMediaCounter = uploadedMediaCounter + 1
                        //                        }
                        //
                        //                        SVProgressHUD.showProgress(Float(uploadedMediaCounter), status: "Uploading")
                    })
                    
                    
                    
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        completion (response.result.value as? NSDictionary)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    completion(nil)
                }
            })
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.INTERNETNOTAVALIABLE)
        }
    }
    
    //MARK:- Upload CAMPAIGN SUPPORTING FILES
    
    func uploadCampaignSupportingFiles(endUrl: String, imageDataArray: NSArray, videosDataArray: NSArray, parameters: [String : Any], completion: @escaping (_ : NSDictionary?) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showProgress && !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            } else {
                showProgress = true
            }
            
            // UPLOAD IMAGES
            Alamofire.upload(multipartFormData: { multipartFormData in
                // import image to request
                var imagesInt = Int()
                imagesInt = 0
                
                for imageData in imageDataArray {
                    var tempData = Data()
                    tempData = imageData as! Data
                    
                    multipartFormData.append(tempData , withName: String(format: "files%d", imagesInt), fileName: String(format: "files%d.m4a", imagesInt), mimeType: "m4a")
                    imagesInt = imagesInt + 1
                }
                
                // UPLOAD VIDEOS
                
                for imageData in videosDataArray {
                    var tempData = Data()
                    tempData = imageData as! Data
                    multipartFormData.append(tempData , withName: String(format: "files%d", imagesInt), fileName: String(format: "files%d.MOV", imagesInt), mimeType: "MOV")
                    imagesInt = imagesInt + 1
                }
                
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: endUrl,
                             
                             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        //  SVProgressHUD.showProgress(Float(Progress.fractionCompleted))
                        SVProgressHUD.showProgress(Float(Progress.fractionCompleted), status: "Uploading")
                        SVProgressHUD.setDefaultMaskType(.clear)
                    })
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        
                        completion (response.result.value as? NSDictionary)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    completion(nil)
                }
            })
            
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.INTERNETNOTAVALIABLE)
            
        }
        
    }
    
    //MARK:- UPLOAD PRESET MEDIA
    
    func uploadPresetMedia(endUrl: String, logoImageData: NSData, animatedVideoData: NSData, introVideoData: NSData, conclusionVideoData: NSData, parameters: [String : Any], completion: @escaping (_ : NSDictionary?) -> Void) {
        
        
        if NetworkReachabilityManager()!.isReachable {
            if showProgress && !SVProgressHUD.isVisible() {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            } else {
                showProgress = true
            }
            
            // UPLOAD IMAGES
            Alamofire.upload(multipartFormData: { multipartFormData in
                // import image to request
                var imagesInt = Int()
                imagesInt = 0
                
                
                if logoImageData.length != 0 {
                    var tempData = Data()
                    tempData = logoImageData as Data
                    multipartFormData.append(tempData , withName: String(format: "logo", imagesInt), fileName: String(format: "logo.jpeg", imagesInt), mimeType: "jpeg")
                }
                
                if  animatedVideoData.length != 0 {
                    var tempData = Data()
                    tempData = animatedVideoData as Data
                    multipartFormData.append(tempData , withName: String(format: "animated_logo_file", imagesInt), fileName: String(format: "animated_logo_file.MOV", imagesInt), mimeType: "MOV")
                }
                
                if  introVideoData.length != 0 {
                    var tempData = Data()
                    tempData = introVideoData as Data
                    multipartFormData.append(tempData , withName: String(format: "intro_video_file", imagesInt), fileName: String(format: "intro_video_file.MOV", imagesInt), mimeType: "MOV")
                }
                
                if  conclusionVideoData.length != 0 {
                    var tempData = Data()
                    tempData = conclusionVideoData as Data
                    multipartFormData.append(tempData , withName: String(format: "conclud_video_file", imagesInt), fileName: String(format: "conclud_video_file.MOV", imagesInt), mimeType: "MOV")
                }
                
                
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: endUrl,
                             
                             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        //  SVProgressHUD.showProgress(Float(Progress.fractionCompleted))
                        SVProgressHUD.showProgress(Float(Progress.fractionCompleted), status: "Uploading")
                        SVProgressHUD.setDefaultMaskType(.clear)
                    })
                    
                    upload.responseJSON { response in
                        SVProgressHUD.dismiss()
                        
                        completion (response.result.value as? NSDictionary)
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    completion(nil)
                }
            })
            
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.INTERNETNOTAVALIABLE)
        }
        
        
        
    }
    
    
    
    
    
    
    
    //     func uploadImage(endUrl: String, imageDataArray: NSMutableArray,imageData: Data, parameters: [String : Any], completion: @escaping (_ : NSDictionary?) -> Void) {
    //
    //        let userparameters = ["userId" :  "userId"   , "firstName" : "me" , "lastName" : "lastName"  , "email" : "email"  , "dob" : "dob"  , "website" : "website"  , "description" : "description" ,"changeVideo":"changeVideo","deleteStatus":"deleteStatus" ]
    //
    //        Alamofire.upload(multipartFormData: { (multipartFormData) in
    //            multipartFormData.append(imageData, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
    ////            multipartFormData.append(imageData, withName: "image", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
    //        //
    //        //            multipartFormData.append(UIImageJPEGRepresentation(image!, 0.5)!, withName: "video", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
    //
    ////        if (imageData.count > 0) {
    ////
    ////        multipartFormData.append(imageData[0], withName: "image", fileName: "swift_file.png", mimeType: "image/png")
    ////        }
    ////
    ////        if (videoData.count > 0) {
    ////        multipartFormData.append(videoData, withName: "video", fileName: "MOV", mimeType: "MOV")
    ////        }
    ////
    //        for (key, value) in userparameters {
    //
    //            multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
    //            }
    //
    //        }, to:endUrl)
    //        { (result) in
    //            switch result {
    //            case .success(let upload, _, _):
    //
    //                upload.uploadProgress(closure: { (Progress) in
    //
    //                    //                    let twoDecimalPlaces = String(format: "%.2d", Progress.fractionCompleted)
    //                    //                    var floatValue11 : Double = NSString(string: twoDecimalPlaces).doubleValue // 3.09999990463257
    //                    //                    floatValue11 = floatValue11 * 100
    //                    //                    let aStr = String(format: "%@%d", "Uploaded", floatValue11)
    //                    //
    //                    //                    SVProgressHUD.show(withStatus: aStr)
    //
    //                })
    //
    //                upload.responseJSON { response in
    //                    //self.delegate?.showSuccessAlert()
    //                    SVProgressHUD.dismiss()
    //
    //
    //                    // result of response serialization
    //                    //                        self.showSuccesAlert()
    //                    //self.removeImage("frame", fileExtension: "txt")
    //                    if let JSON = response.result.value {
    //                        print("JSON: \(JSON)")
    //
    //                        self.getValidDict(result: response.result, completion: {(dict, error) in
    //                            SVProgressHUD.dismiss()
    //
    //                            if (dict != nil) {
    //                                print(response.result)
    //                                completion(true, "success", dict)
    //
    //                            }
    //                            else {
    //                                completion(false, "failure", nil)
    //
    //                            }
    //                        })
    //
    //                    }
    //                }
    //
    //            case .failure(let encodingError):
    //                //self.delegate?.showFailAlert()
    //                print(encodingError)
    //            }
    //
    //        }
    //
    //
    //    }
    
    
    private func getValidDict(result: Result<Any>, completion: @escaping (_ : NSDictionary?, _ : NSError?, _ : Bool?) -> Void) {
        var dict: NSDictionary!
        let errorNew = result.error as NSError?
        if let json = result.value {
            dict = json as! NSDictionary
        }
        if dict == nil && errorNew != nil && (errorNew?._code == NSURLErrorTimedOut || errorNew?.localizedDescription == "The network connection was lost.") {
            if retry >= 1 {
                UIAlertController.showAlert((errorNew?.localizedDescription)!, message: "", buttons: ["Cancel", "Retry"], completion: { (alert, index) in
                    if index == 0 {
                        completion (dict, errorNew, false)
                    } else {
                        completion (dict, errorNew, true)
                    }
                })
            } else {
                retry += 1
                DispatchQueue.dispatch_main_after(1.0, block: {
                    completion (dict, errorNew, true)
                })
            }
        } else {
            completion (dict, errorNew, false)
        }
    }
    
    func goToLogin() {
        UserStore.sharedInstance.userInfo = "logout"
        GIDSignIn.sharedInstance()?.signOut()
        FBSDKLoginManager().logOut()
        
        
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
    }
    
}

