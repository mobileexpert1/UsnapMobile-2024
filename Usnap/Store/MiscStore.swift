//
//  MiscStore.swift
//  Usnap
//
//  Created by CSPC141 on 20/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Foundation

class MiscStore: ApiStore {
 static let sharedInstance = MiscStore()
    
    //MARK:- CONTACT TO ADMIN
    func contactToAdmin(_ userID: String, _ subject: String, _ message: String, _ contactType: String, _ email: String, _ name: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCONTACTADMIN_P1_USERID: userID,
                          APIs.KCONTACTADMIN_P2_SUBJECT: subject,
                          APIs.KCONTACTADMIN_P3_MESSAGE:message,
                          APIs.KCONTACTADMIN_P4_CONTACTTYPE: contactType,
                          APIs.KCONTACTADMIN_P5_email: email,
                          APIs.KCONTACTADMIN_P6_name: name]
        requestAPI(APIs.KCONTACTADMIN, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- CONTACT TO ADMIN
    func learn(completion: @escaping (_ : BaseLearnerResponse?) -> Void)  {
        requestAPI(APIs.KLEARN, parameters: nil) { (response) in
            if response != nil {
                completion(BaseLearnerResponse.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- UPLOAD IMAGE  TO SANDBOX
    func saveImagesToSandBox(_ image: UIImage, _ imageName: String, completion: @escaping (_ : String?) -> Void)  {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
            completion(imageName)
        }
        else {
            completion(nil)
        }
    }
    
    //MARK:- SAVE VIDEO TO SANDBOX
    func saveVideoToSandBox(_ videoData: NSData, _ videoName: String, _ videoThumbnail: UIImage, _ thumbnailName: String, completion: @escaping (_ : NSArray?) -> Void)  {
        // Save video
        let filename = getDocumentsDirectory().appendingPathComponent(videoName)
            try? videoData.write(to: filename)
        
        // Save thumbnail
        if let data = UIImagePNGRepresentation(videoThumbnail) {
            let filename = getDocumentsDirectory().appendingPathComponent(thumbnailName)
            try? data.write(to: filename)
            
        }
            completion([videoName,thumbnailName])
    }
    
    // FAQ QUESTIONS
    func faq(_ user_role: String, completion: @escaping (_ : BaseFaq?) -> Void)  {
        let parameters = [APIs.KFAQ_P1_USERROLE: user_role]
        requestAPI(APIs.KFAQ, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseFaq.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}
