//
//  CreateCampaignStore.swift
//  Usnap
//
//  Created by CSPC141 on 22/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import CoreImage
import SVProgressHUD

class CreateCampaignStore: ApiStore {
    
    static let sharedInstance = CreateCampaignStore()
    
    var brightnessFilter: CIFilter!;
    var contrastFilter: CIFilter!;
    var outputImage = CIImage();
    var brightness = [Float]()
    var newUIImage = UIImage();
    var context = CIContext();
    var aCIImage = CIImage();
    
    
    //MARK:- GET DETAIL FOR NEW CAMPAIGN
    func getDataForNewCampaign(_ user_id: String, _ user_role: String, completion: @escaping (_ : BaseNewCampaignData?) -> Void)  {
        let parameters = [APIs.KNEWCAMPAIGNDETAIL_P1_USERID: user_id,
                          APIs.KNEWCAMPAIGNDETAIL_P2_USERROLE: user_role]
        requestAPI(APIs.KNEWCAMPAIGNDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseNewCampaignData.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SEND IMAGE AND OTHER DETAILS
    func sendCampaignData( _ imagesData: NSArray, _ cameraImagesData: NSArray, _ videosData: NSArray, _ user_id: String, _ user_role: String, _ title : String, _ address : String, _ city : String, _ state : String, _ country : String, _ postel_code : String, _ catagories : String, _ assigned_to: String, _ campaign_id: String,  _ submit : String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        
        let parameters = [APIs.KCREATECAMPAIGN_P1_USERID: user_id,
                          APIs.KCREATECAMPAIGN_P2_USERROLE: user_role,
                          APIs.KCREATECAMPAIGN_P3_TITLE: title,
                          APIs.KCREATECAMPAIGN_P4_ADDRESS: address,
                          APIs.KCREATECAMPAIGN_P5_CITY: city,
                          APIs.KCREATECAMPAIGN_P6_STATE: state,
                          APIs.KCREATECAMPAIGN_P7_COUNTRY: country,
                          APIs.KCREATECAMPAIGN_P8_POSTALCODE: postel_code,
                          APIs.KCREATECAMPAIGN_P14_SERVICEID: catagories,
                          APIs.KCREATECAMPAIGN_P10_ASSIGNEDTO: assigned_to,
                          APIs.KCREATECAMPAIGN_P11_CAMPAIGNID: campaign_id,
                          APIs.KCREATECAMPAIGN_P12_STATIC: submit,
                          APIs.KCREATECAMPAIGN_P13_STATICDEVICETYPE: "ios"]
        print(parameters)
        
        var tempImageData = [Data]()
        //        for imageData in cameraImagesData {
        //            brightness = [0.0, 0.39, 0.21, 0.10, -0.10, -0.22, -0.34]
        //            for i in 0 ... 6 {
        //                if i  == 0 {
        //                    tempImageData.append(imageData as! Data)
        //                }
        //                else {
        //                    let currentImage : UIImage = UIImage(data: imageData as! Data)!
        //                    let aUIImage = currentImage;
        //                    let aCGImage = aUIImage.cgImage;
        //                    aCIImage = CIImage(cgImage: aCGImage!)
        //                    context = CIContext(options: nil);
        //                    contrastFilter = CIFilter(name: "CIColorControls");
        //                    contrastFilter.setValue(aCIImage, forKey: "inputImage")
        //                    brightnessFilter = CIFilter(name: "CIColorControls");
        //                    brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        //                    brightnessFilter.setValue(NSNumber(value: brightness[i]), forKey: "inputBrightness");
        //                    outputImage = brightnessFilter.outputImage!
        //                    let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        //                    newUIImage = UIImage(cgImage: imageRef!, scale: 1.0, orientation:.up)
        //                    let data = UIImagePNGRepresentation(newUIImage)
        //                    tempImageData.append(data!)
        //                }
        //            }
        //        }
        uploadImageAndVideo(endUrl: APIs.KCREATECAMPAIGN, imageDataArray: imagesData as NSArray, imageDataArrayCamera: cameraImagesData as NSArray,  videosDataArray: videosData, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SET PRESETS
    func setPresets(_ user_role_id: String, _ dimension : String, _ logo: NSData, _ animated_logo_file: NSData, _ intro_video_file : NSData, _ conclud_video_file : NSData, _ custom_size : String, _ opacity: String, _ submit: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNPRESET_P1_USERID: user_role_id,
                          APIs.KCAMPAIGNPRESET_P2_DIMENSIONS: dimension,
                          APIs.KCAMPAIGNPRESET_P7_CUSTOMSIZE: custom_size,
                          APIs.KCAMPAIGNPRESET_P8_OPACITY: opacity,
                          APIs.KCAMPAIGNPRESET_P9_SUBMIT: submit]
        
        uploadPresetMedia(endUrl: APIs.KCAMPAIGNPRESET, logoImageData: logo, animatedVideoData: animated_logo_file, introVideoData: intro_video_file, conclusionVideoData: conclud_video_file, parameters: parameters) { (response) in
            print(response as Any)
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET PRESET
    func getPreset(_ user_id: String, completion: @escaping (_ : BaseClassGetPreset?) -> Void)  {
        let parameters = [APIs.KGETPRESET_P1_USERID: user_id]
        requestAPI(APIs.KGETPRESET, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassGetPreset.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SEND IMAGE AND OTHER DETAILS
    func mediaSupportingFiles(_ user_role_id: String, _ audioFiles : NSArray, _ files: NSArray, _ campaign_id: String, _ submit : String, _ waterMarkLogo : String, _ animatedLogo : String, _ conclusionvideo: String, _ introvideo: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KMediaSupports_P1_USERID: user_role_id,
                          APIs.KMediaSupports_P3_CAMPAIGNID: campaign_id,
                          APIs.KMediaSupports_P4_SUBMIT: submit,
                          APIs.KMediaSupports_P5_WATERMARKLOGO: waterMarkLogo,
                          APIs.KMediaSupports_P6_ANIMATEDLOGO: animatedLogo,
                          APIs.KMediaSupports_P7_CONCLUSIONVIDEO: conclusionvideo,
                          APIs.KMediaSupports_P8_INTRODUCTIONVIDEO: introvideo]
        uploadCampaignSupportingFiles(endUrl: APIs.KMediaSupports, imageDataArray: audioFiles , videosDataArray: files, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET NEW CAMPAIGN DETAIL
    func getNewCampaignDETAIL(_ campaign_id: String, _ user_role: String, completion: @escaping (_ : BaseNewCampaignDetail?) -> Void)  {
        let parameters = [APIs.KNEWCAMPAIGNSAVEDDETAIL_P1_CAMPAIGNID: campaign_id,
                          APIs.KNEWCAMPAIGNSAVEDDETAIL_P2_USERROLEID:user_role]
        print(parameters)
        requestAPI(APIs.KNEWCAMPAIGNSAVEDDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseNewCampaignDetail.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- DELETE IMAGE
    func deleteImage(_ image_id: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KDELETEIMAGE_P1_IMAGEID: image_id]
        requestAPI(APIs.KDELETEIMAGE, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- NEW CAMPAIGN MEDIA
    func campaignMediaImage(_ campaign_id: String,  completion: @escaping (_ : BaseCampaignMedia?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNMEDIA_P1_CAMPAIGNID: campaign_id]
        requestAPI(APIs.KCAMPAIGNMEDIA, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCampaignMedia.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- Submit Campaign
    func submitCampaign(_ campaign_category_id: String, _ urgent_type: String, _ campaign_id: String, _ user_role_id: String, _ save_only: String, completion: @escaping (_ : NSDictionary?) -> Void) {
        let parameters = [
            APIs.CAMPAIGN_CATEGORY_ID: campaign_category_id,
            APIs.KSAVECAMPAIGN_P1_URGENT: urgent_type,
            APIs.KSAVECAMPAIGN_P2_CAMPAIGNID: campaign_id,
            APIs.KSAVECAMPAIGN_P3_USERID: user_role_id,
            APIs.KSAVECAMPAIGN_P4_SAVETYPE: save_only
           
        ]
        
        print(parameters)
        
        requestAPI(APIs.KSUBMITCAMPAIGN, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
}

