//
//  CampaignStore.swift
//  Usnap
//
//  Created by CSPC141 on 08/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class CampaignStore: ApiStore {
    static let sharedInstance = CampaignStore()
    
    var targetCampaignId = String()
    
    
    //MARK:- GET CAMPAIGNS LIST
    func getCampaignList(_ user_id: String, completion: @escaping (_ : BaseCampaignList?) -> Void)  {
        let parameters = [APIs.KGETCOMPAIGNSLIST_P1_USERID: user_id,
                          APIs.KGETCOMPAIGNSLIST_P3_USERROLE: UserStore.sharedInstance.userRole]
        requestAPI(APIs.KGETCOMPAIGNSLIST, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCampaignList.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- GET CAMPAIGN DETAIL
    func getCampaignDETAIL(_ campaign_id: String, _ dataType: String, completion: @escaping (_ : BaseCampaignDetail?) -> Void)  {
        let parameters = [APIs.KGETCOMPAIGNSDETAIL_P1_CAMPAIGNID: campaign_id,
                          APIs.KGETCOMPAIGNSDETAIL_P2_DATATYPE: dataType]
        print(">>", parameters)
        requestAPI(APIs.KGETCOMPAIGNSDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCampaignDetail  .init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- DELETE AFTER DOWNLOAD
    func deleteAfterDownload(_ campaign_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KDeleteAfterDownload_P1_CAMPAIGNID: campaign_id]
        requestAPI(APIs.KDeleteAfterDownload, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    //MARK:- GET ADDITIONAL SERVICES CAMPAIGN SERVICES
    func getAdditionalServicesList(_ user_id: String, _ campaignid: String,  completion: @escaping (_ : BaseAdditionalServices?) -> Void)  {
        let parameters = [APIs.KADDITIONALSERVICES_P1_USERID: user_id,
                          APIs.KADDITIONALSERVICES_P2_CAMPAIGNID: campaignid]
        requestAPI(APIs.KADDITIONALSERVICES, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseAdditionalServices.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- RATE CAMPAIGN
    func rateCampaign(_ user_id: String, _ campaign_id: String, _ rating: String, _ comment: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KRATECAMPAIGN_P1_USERID: user_id,
                          APIs.KRATECAMPAIGN_P2_CAMPAIGNID: campaign_id,
                          APIs.KRATECAMPAIGN_P3_RATING: rating,
                          APIs.KRATECAMPAIGN_P4_COMMENT: comment]
        requestAPI(APIs.KRATECAMPAIGN, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- DELETE CAMPAIGN
    func deleteCampaign(_ campaign_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KDeleteCampaign_P1_CAMPAIGNID: campaign_id]
        requestAPI(APIs.KDeleteCampaign, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- COMMENT ON CAMPAIGN IMAGE
    func campaignImageComment(_ user_id: String, _ campaign_id: String, _ image_id: String, _ comment: String, _ apply_all: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNIMAGECOMMENT_P1_USERID: user_id,
                          APIs.KCAMPAIGNIMAGECOMMENT_P2_CAMPAIGNID: campaign_id,
                          APIs.KCAMPAIGNIMAGECOMMENT_P3_IMAGEID: image_id,
                          APIs.KCAMPAIGNIMAGECOMMENT_P4_COMMENTTEXT: comment,
                          APIs.KCAMPAIGNIMAGECOMMENT_P5_APPLYALL: apply_all]
        requestAPI(APIs.KCAMPAIGNIMAGECOMMENT, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- ACCEPT DECLINE ADDITIONAL SERVICE
    func AdditionalServiceUserAction(_ user_id: String, _ service_id: String, _ user_action: String, _ staticValue: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KADDITIONALSERVICESUSERACTION_P1_USERID: user_id,
                          APIs.KADDITIONALSERVICESUSERACTION_P2_SERVICEID: service_id,
                          APIs.KADDITIONALSERVICESUSERACTION_P3_USERACTION: user_action,
                          APIs.KADDITIONALSERVICESUSERACTION_P4_STATICVALUE: staticValue]
        requestAPI(APIs.KADDITIONALSERVICESUSERACTION, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SEND IMAGE IN COMMENT
    func sendCommentImage( _ campaign_id: String, _ image_id: String, _ comment: String, _ apply_all: String, _ imagesDataArray : NSMutableArray,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P1_CAMPAIGNID: campaign_id,
                          APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P2_IMAGEID: image_id,
                          APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P3_COMMENTTEXT: comment,
                          APIs.KCAMPAIGNCOMMENRTWITHIMAGE_P4_APPLYALL: apply_all]
        print(parameters)
        uploadImage(endUrl:APIs.KCAMPAIGNCOMMENRTWITHIMAGE , imageDataArray: imagesDataArray, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- COMPARE IMAGES
    func CompareImage(_ image_id: String,  completion: @escaping (_ : BaseCompareImage?) -> Void)  {
        let parameters = [APIs.KCOMPAREIMAGE_P1_IMAGEID: image_id]
        requestAPI(APIs.KCOMPAREIMAGE, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCompareImage.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- COMPARE VIDEOS
    func CompareVideos(_ video_id: String,  completion: @escaping (_ : BaseCompareImage?) -> Void)  {
        let parameters = [APIs.KCOMPAREVIDEOS_P1_VIDEOID: video_id]
        requestAPI(APIs.KCOMPAREVIDEO, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCompareImage.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- COMMENT ON MEDIA
    func CommentOnMedia(_ file_id: String, _ file_name: String, _ comment: String, _ campaign_id: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KMEDIACOMMENT_P1_FILEID: file_id,
                          APIs.KMEDIACOMMENT_P2_FILENAME: file_name,
                          APIs.KMEDIACOMMENT_P3_COMMENT: comment,
                          APIs.KMEDIACAMPAIGNID_P4_COMMENT: campaign_id]
        requestAPI(APIs.KMEDIACOMMENT, parameters: parameters) { (response) in
            if response != nil {
                print(response as Any)
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SAVE CAMPAIGN
    func SaveCampaign(_ urgent_type: String, _ campaign_id: String, _ user_id: String, _ save_only: String,_ totapPayableAmount:String,_ creditUsed:String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSAVECAMPAIGN_P1_URGENT: urgent_type,
                          APIs.KSAVECAMPAIGN_P2_CAMPAIGNID: campaign_id,
                          APIs.KSAVECAMPAIGN_P3_USERID: user_id,
                          APIs.KSAVECAMPAIGN_P4_SAVETYPE: save_only,
                          "total_payable_amount": totapPayableAmount,"credit_used_server": creditUsed
        ]
        requestAPI(APIs.KSAVECAMPAIGN, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- SAVE USER EMAIL
    func SaveUserEmail(_ emailID: String, _ user_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSAVEUSEREMAIL_P1_EMAIL: emailID,
                          APIs.KSAVEUSEREMAIL_P2_USERID: user_id]
        requestAPI(APIs.KSAVEUSEREMAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- SHARE MEDIA
    func shareMediaViaServer(_ campaign_id: String, _ user_role_id: String, _ media_id: String, _ emails: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSHAREMEDIAVIASERVEER_P1_CAMPAIGNID: campaign_id,
                          APIs.KSHAREMEDIAVIASERVEER_P2_USERROLE: user_role_id,
                          APIs.KSHAREMEDIAVIASERVEER_P3_MEDIAID: media_id,
                          APIs.KSHAREMEDIAVIASERVEER_P4_EMAILS: emails]
        requestAPI(APIs.KSHAREMEDIAVIASERVEER, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET SHARING LINK
    func getMediaSharingLink(_ campaign_id: String, _ user_role_id: String, _ media_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSHAREMEDIAVIALINK_P1_CAMPAIGNID: campaign_id,
                          APIs.KSHAREMEDIAVIALINK_P2_USERROLE: user_role_id,
                          APIs.KSHAREMEDIAVIALINK_P3_MEDIAID: media_id]
        requestAPI(APIs.KSHAREMEDIAVIALINK, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    //MARK:- DOWNLOAD CAMPAIGN MEDIA
    func downloadCampaignMedia(_ campaign_id: String,  completion: @escaping (_ : BaseClassDownloadCamMedia?) -> Void)  {
        let parameters = [APIs.KDownloadCampaign_P1_CAMPAIGNID: campaign_id]
        requestAPI(APIs.KDownloadCampaign, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassDownloadCamMedia.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
}
