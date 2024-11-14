//
//  StaffStore.swift
//  Usnap
//
//  Created by CSPC141 on 21/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import Foundation

class StaffStore: ApiStore {
    static let sharedInstance = StaffStore()

    //MARK:- INVITE STAFF MEMBER
    func inviteStaffMember(_ userID: String, _ emails: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSENDSTAFFINVITATION_P1_USERID: userID,
                          APIs.KSENDSTAFFINVITATION_P2_EMAILS: emails]
        requestAPI(APIs.KSENDSTAFFINVITATION, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET STAFF MEMBERS LIST
    func getStaffList(_ user_id: String, completion: @escaping (_ : BaseStaffList?) -> Void)  {
        let parameters = [APIs.KGETSTAFFMEMBERLIST_P1_USERID: user_id]
        
        requestAPI(APIs.KGETSTAFFMEMBERLIST, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffList.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET STAFF MEMBERS DETAIL
    func getStaffMemberDetail(_ user_id: String, completion: @escaping (_ : BaseStaffMemberDetail?) -> Void)  {
        let parameters = [APIs.KGETSTAFFMEMBERDETAIL_P1_USERID: user_id]
        requestAPI(APIs.KGETSTAFFMEMBERDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffMemberDetail.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- DELETE STAFF MEMBER
    func deleteStaffMember(_ staff_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KDELETESTAFFMEMBER_P1_USERID: staff_id]
        requestAPI(APIs.KDELETESTAFFMEMBER, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- SET STAFF PERMISSIONS
    func setStaffMemberPermissions(_ staff_user_id: String, _ invoice_update: String, _ paid_by_admin: String, _ all_invoice: String, _ all_media: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KSETSTAFFPERMISSIONS_P1_STAFFID: staff_user_id,
                          APIs.KSETSTAFFPERMISSIONS_P2_STATICVALUE: invoice_update,
                          APIs.KSETSTAFFPERMISSIONS_P3_PAIDBY: paid_by_admin,
                          APIs.KSETSTAFFPERMISSIONS_P4_ALLINVOICES: all_invoice,
                          APIs.KSETSTAFFPERMISSIONS_P5_ALLMEDIA: all_media]
        requestAPI(APIs.KSETSTAFFPERMISSIONS, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- ADD STAFF MEMBER
    func addNewStaffMember(_ user_id: String, _ staticSaveValue: String, _ first_name: String, _ last_name: String, _ number: String, _ email: String, _ invoice_by: String, _ all_media: String, _ all_invoice: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KADDSTAFFMEMBER_P1_USERID: user_id,
                          APIs.KADDSTAFFMEMBER_P2_STATICVALUE: staticSaveValue,
                          APIs.KADDSTAFFMEMBER_P3_FIRSTNAME: first_name,
                          APIs.KADDSTAFFMEMBER_P4_LASTNAME: last_name,
                          APIs.KADDSTAFFMEMBER_P5_NUMBER: number,
                          APIs.KADDSTAFFMEMBER_P6_EMAIL: email,
                          APIs.KADDSTAFFMEMBER_P7_INVOICEBY: invoice_by,
                          APIs.KADDSTAFFMEMBER_P8_ALLMEDIA:all_media,
                          APIs.KADDSTAFFMEMBER_P9_ALLINVOICES: all_invoice]
        requestAPI(APIs.KADDSTAFFMEMBER, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    // MARK:- STAFF MEMBERS REQUEST
    func getStaffRequests(_ user_id: String, completion: @escaping (_ : BaseStaffRequest?) -> Void) {
        let parameters = [APIs.KSTAFFMEMBERREQUEST_P1_USERID: user_id]
        requestAPI(APIs.KSTAFFMEMBERREQUEST, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffRequest.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    // MARK:- STAFF MEMBERS REQUEST ACTION
    
    func getStaffRequestsAction(_ user_id: String, _ email : String, _ user_action : String, _ submit: String,  completion: @escaping (_ : NSDictionary?) -> Void) {
        let parameters = [APIs.KSTAFFMEMBERREQUESTACTION_P1_USERID: user_id,
                          APIs.KSTAFFMEMBERREQUESTACTION_P2_EMAIL: email,
                          APIs.KSTAFFMEMBERREQUESTACTION_P3_USER_ACTION: user_action,
                          APIs.KSTAFFMEMBERREQUESTACTION_P4_SUBMIT:submit]
        requestAPI(APIs.KSTAFFMEMBERREQUESTACTION, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
}
