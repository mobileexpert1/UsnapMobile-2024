//
//  UserStore.swift
//  Usnap
//
//  Created by Mobile on 20/12/17.
//  Copyright © 2017 Bikramjit Singh. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


class UserStore : ApiStore {
    
    static let sharedInstance = UserStore()
    
    var requestStatus: String = ""
    var detailRoleKey: String = "roles"
    var showTutorial : String = ""
    
    
    
    // GETTER SETTER FOR USER LOGIN ID
        var userInfo: String {
            
            get {
                return UserDefaults.standard.object(forKey: "LoginUserId") as? String ?? String()
            }
          
            set {
                let defaults = UserDefaults.standard
                defaults.set(newValue, forKey: "LoginUserId")
                defaults.synchronize()
            }
        }
    
    
    
    var showTutorialScreens: String {
        
        get {
            return UserDefaults.standard.object(forKey: "showTutorial") as? String ?? String()
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "showTutorial")
            defaults.synchronize()
        }
    }
    
    var showCameraSuggestion: String {
          
          get {
              return UserDefaults.standard.object(forKey: "showCameraSuggestion") as? String ?? String()
          }
          
          set {
              let defaults = UserDefaults.standard
              defaults.set(newValue, forKey: "showCameraSuggestion")
              defaults.synchronize()
          }
      }
    
    
    
    var installedFirstTime: String {
        
        get {
            return UserDefaults.standard.object(forKey: "InstalledFirstTime") as? String ?? String()
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "InstalledFirstTime")
            defaults.synchronize()
        }
    }
    
    
    var userRole: String {
        get {
            return UserDefaults.standard.object(forKey: "loginUserRole") as? String ?? String()
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "loginUserRole")
            defaults.synchronize()
        }
    }
    
    
    
    var deviceToken: String {
        get {
            return UserDefaults.standard.object(forKey: "deviceToken") as? String ?? String()
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "deviceToken")
            defaults.synchronize()
        }
    }
    
    
    
    var userDetails: LoginResult! {
        get {
            let dict = UserDefaults.standard.value(forKey: "loginUserDetail")
            if dict == nil {
                return nil
            } else {
                return LoginResult.init(object: dict!)
            }
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "loginUserDetail")
            } else {
                UserDefaults.standard.set(newValue.dictionaryRepresentation(), forKey: "loginUserDetail")
            }
        }
    }
    
    var title: String {
        
        get {
            return UserDefaults.standard.object(forKey: "titleId") as? String ?? String()
        }
      
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "titleId")
            defaults.synchronize()
        }
    }
    
    var selectedPhotos: String {
        
        get {
            return UserDefaults.standard.object(forKey: "selectedPhotosId") as? String ?? String()
        }
      
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "selectedPhotosId")
            defaults.synchronize()
        }
    }

    //MARK: - REQUEST LOGIN
    func requestLogin(_ email: String, _ password: String, completion: @escaping (_ : BaseLogin?) -> Void)  {
        let parameters = [APIs.KLOGIN_P1_EMAIL: email,
                      APIs.KLOGIN_P2_PASSWORD: password,
                      APIs.KLOGIN_P3_DEVICE_TOKEN: UserStore.sharedInstance.deviceToken,
                      APIs.KLOGIN_P4_DEVICE_TYPE: Constants.DEVICE_TYPE]
    
        requestAPI(APIs.KLOGIN, parameters: parameters ) { (response) in
            print(response as Any)
            if response != nil {
                completion(BaseLogin.init(object: response!))
            } else {
                completion(nil)
            }
        }

    }
    
   // social_type   social_id  device_token  device_type  first_name  last_name country
    //MARK: - REQUEST SOCIAL LOGIN
    func requestSocialLogin(_ email: String, _ social_type: String,  _ social_id: String, _ first_name: String, _ last_name: String, _ country: String, completion: @escaping (_ : BaseLogin?) -> Void)  {
        let parameters = [APIs.KSOCIALLOGIN_P1_EMAIL: email,
                          APIs.KSOCIALLOGIN_P2_SOCIALTYPE: social_type,
                          APIs.KSOCIALLOGIN_P3_DEVICE_TOKEN: UserStore.sharedInstance.deviceToken,
                          APIs.KSOCIALLOGIN_P4_DEVICE_TYPE: Constants.DEVICE_TYPE,
                          APIs.KSOCIALLOGIN_P5_SOCIALID: social_id,
                          APIs.KSOCIALLOGIN_P6_FIRSTNAME:first_name,
                          APIs.KSOCIALLOGIN_P7_LASTNAME:last_name,
                          APIs.KSOCIALLOGIN_P8_COUNTRY:country]
        requestAPI(APIs.KSOCIALLOGIN, parameters: parameters ) { (response) in
            print(response as Any)
            if response != nil {
                completion(BaseLogin.init(object: response!))
            } else {
                completion(nil)
            }
        }
        
    }
    
    //MARK: - REQUEST REGISTER
    func requestRegister(_ roll: String, _ first_name: String, _ last_name: String, _ email: String, _ password: String, _ number: String, _ ref_code: String, _ deviceToken: String, _ deviceType: String, _ country: String, _ company_name: String, _ allMedia: String, _ allInvoice: String,_ hearAboutUs:String,  completion: @escaping (_ : BaseLogin?) -> Void)  {
        let parameters = [APIs.KREGISTER_P1_ROLL: roll,
                          APIs.KREGISTER_P2_FIRSTNAME: first_name,
                          APIs.KREGISTER_P3_LASTNAME: last_name,
                          APIs.KREGISTER_P4_EMAIL: email,
                          APIs.KREGISTER_P5_PASSWORD: password,
                          APIs.KREGISTER_P6_PHONENUMBER: number,
                          APIs.KREGISTER_P7_AGENTCODE: ref_code,
                          APIs.KREGISTER_P8_SIGNUP: "",
                          APIs.KREGISTER_P9_DEVICE_TOKEN: deviceToken,
                          APIs.KREGISTER_P10_DEVICE_TYPE: deviceType,
                          APIs.KREGISTER_P11_COUNTRY: country,
                          APIs.KREGISTER_P12_COMPANY_NAME: company_name,
                          APIs.KREGISTER_P13_ALL_MEDIA: allMedia,
                          APIs.KREGISTER_P14_ALL_INVOICE: allInvoice,
                          "hear_about_us": hearAboutUs]
        
        requestAPI(APIs.KREGISTER, parameters: parameters) { (response) in
            print(response as Any)
            if response != nil {
                completion(BaseLogin.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - REQUEST REGISTER
    func keepData(_ user_role_id: String, _ action: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KKEEPDATA_P1_USERROLE: user_role_id,
                          APIs.KKEEPDATA_P2_ACTION: action]
        
        requestAPI(APIs.KKEEPDATA, parameters: parameters) { (response) in
            print(response as Any)
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
        
    }
    
    //MARK: - REQUEST USER PROFILE
    func requestUserProfile(_ user_id: String, _ get_data: String, completion: @escaping (_ : BaseProfile?) -> Void)  {
        let parameters = [APIs.KGETUSERPROFILE_P1_USERID: user_id,
                          APIs.KGETUSERPROFILE_P2_GETDATA: get_data]
        requestAPI(APIs.KGETUSERPROFILE, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseProfile.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }

    //MARK: - REQUEST USER PROFILE
    func membership(_ user_id: String,  completion: @escaping (_ : BaseClassMemberShip?) -> Void)  {
        let parameters = [APIs.KMEMBERSHIP_P1_USERROLE: user_id]
        requestAPI(APIs.KMEMBERSHIP, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassMemberShip.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - REQUEST USER PROFILE
    func purchaseMembership(_ user_id: String, _ planId: String, _ buttonAction: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSUBSCRIBE_P1_USERROLE: user_id,
                          APIs.KSUBSCRIBE_P2_PLANID: planId,
                          APIs.KSUBSCRIPTIONTYPE_P3_SUBTYPE: buttonAction]
        requestAPI(APIs.KSUBSCRIBE, parameters: parameters) { (response) in
            if response != nil {
                 completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - REQUEST USER NOTIFICATIONS
    func getUserNotifications(_ user_role_id: String, completion: @escaping (_ : BaseClassNotification?) -> Void)  {
        let parameters = [APIs.KNOTIFICATIONS_USERROLEID: user_role_id]
        
        requestAPI(APIs.KNOTIFICATIONS, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassNotification.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }

    //MARK: - SET NOTIFICATION STATUS
    func changeNotificationStatus(_ userID: String, _ noti_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCHANGENOTIFICATIONSTATUS_USERROLEID: userID,
                          APIs.KCHANGENOTIFICATIONSTATUS_NOTIFICATIONID: noti_id]
        requestAPI(APIs.KCHANGENOTIFICATIONSTATUS, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - SET NOTIFICATION READ/UNREAD
    func setNotificationReadUnread(_ userID: String, _ noti_id: String, _ action: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCHANGENOTIFICATIONSTATUS_USERROLEID: userID,
                          APIs.KCHANGENOTIFICATIONSTATUS_NOTIFICATIONID: noti_id,
                          APIs.KCHANGENOTIFICATIONREADUNREAD_action: action]
        requestAPI(APIs.KCHANGENOTIFICATIONREADUNREAD, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - REQUEST USER PROFILE
    func notificationsPaymentAction(_ campaign_id: String, _ keep_camp: String, _ default_value: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCAMPNOTIFICATIONSPAYMENT_P1_CAMPAIGNID: campaign_id,
                          APIs.KCAMPNOTIFICATIONSPAYMENT_P2_KEEPCAMP: keep_camp,
                          APIs.KCAMPNOTIFICATIONSPAYMENT_P3_DEFAULTVALUE: default_value]
        requestAPI(APIs.KCAMPNOTIFICATIONSPAYMENT, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - UPDATE USER PROFILE
    func UpdateUserProfile(_ user_id: String, _ update_profile: String, _ first_name: String, _ last_name: String, _ number: String, _ add1: String, _ add2: String, _ state: String, _ country: String, _ company_name: String, _ all_media_to: String, _ all_invoices_to: String,   completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KUPDATEPROFILE_P1_USERID: user_id,
                          APIs.KUPDATEPROFILE_P2_UPDATEDATA: update_profile,
                          APIs.KUPDATEPROFILE_P3_FIRSTNAME: first_name,
                          APIs.KUPDATEPROFILE_P4_LASTNAME: last_name,
                          APIs.KUPDATEPROFILE_P5_MOBILENUMBER: number,
                          APIs.KUPDATEPROFILE_P6_ADDRESS1: add1,
                          APIs.KUPDATEPROFILE_P7_ADDRESS2: add2,
                          APIs.KUPDATEPROFILE_P8_STATE: state,
                          APIs.KUPDATEPROFILE_P9_COUNTRY: country,
                          APIs.KUPDATEPROFILE_P10_COMPANYNAME: company_name,
                          APIs.KUPDATEPROFILE_P11_ALLMEDIATO: all_media_to,
                          APIs.KUPDATEPROFILE_P12_ALLINVOICETO: all_invoices_to]
        
        requestAPI(APIs.KUPDATEPROFILE, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
        
    }
    
    //MARK: - FORGOT PASSWORD
    func forgotPassword(_ email: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KFORGOT_P1_EMAIL: email]
        requestAPI(APIs.KFORGOTPASSWORD, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - USER PRICING
    func getUserPricings(_ userRoleId: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KUSERPRICING_P1_USERID: userRoleId]
        requestAPI(APIs.KUSERPRICING, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - GET COUNTER
    func getCounter(_ user_role_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCOUNTER_P1_USERID: user_role_id]
        requestAPI(APIs.KCOUNTER, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK: - CHANGE USER ROLE
    func chnageUserRole(_ user_id: String, _ value: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNINVOICE_P1_USERID: user_id,
                          APIs.KCAMPAIGNINVOICE_P2_VALUE: value]
        requestAPI(APIs.KCAMPAIGNINVOICE, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK: - GET USER PROFILE TYPE
    func getUserProfileType(_ user_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KGETUSERPROFILETYPE_P1_USERID: user_id]
        requestAPI(APIs.KGETUSERPROFILETYPE, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: - CHANGE PASSWORD
    func ChangePassword(_ userID: String, _ currentPassword: String, _ newPassword: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KCHANGEPASSWORD_P1_USERID: userID,
                          APIs.KCHANGEPASSWORD_P2_CURRENTPASSWORD: currentPassword,
                          APIs.KCHANGEPASSWORD_P3_NEWPASSWORD: newPassword]
        requestAPI(APIs.KCHANGEPASSWORD, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - DISABLE USER
    func disableUser(_ email: String,  completion: @escaping (_ : NSDictionary?) -> Void)  {
        
        let parameters = [APIs.DISABLE_USER_EMAIL: email]
        
        requestAPI(APIs.DISABLE_USER, parameters: parameters) { (response) in
            print(response as Any)
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
}
