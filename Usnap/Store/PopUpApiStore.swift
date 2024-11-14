//
//  PopUpApiStore.swift
//  Usnap
//
//  Created by CSPC141 on 05/04/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class PopUpApiStore: ApiStore {
    static let sharedInstance = PopUpApiStore()
    
    //MARK:- GET ALL CATAGORIES
    func getCatagories(completion: @escaping (_ : BaseAllCatagories?) -> Void)  {
        requestAPI(APIs.KGETCATAGORIES, parameters: nil) { (response) in
            if response != nil {
                completion(BaseAllCatagories.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET STAFF MEMBERS LIST WITH FILTERS
    func getStaffListFilters(_ user_id: String, _ mobile: String, _ email: String, _ staff_name: String,  completion: @escaping (_ : BaseStaffList?) -> Void)  {
        let parameters = [APIs.KGETSTAFFMEMBERLISTFILTERS_P1_USERID: user_id,
                          APIs.KGETSTAFFMEMBERLISTFILTERS_P2_MOBILE: mobile,
                          APIs.KGETSTAFFMEMBERLISTFILTERS_P3_EMAIL: email,
                          APIs.KGETSTAFFMEMBERLISTFILTERS_P4_STAFFNAME: staff_name]
        requestAPI(APIs.KGETSTAFFMEMBERLISTFILTERS, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffList.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }

    //MARK:- GET CAMPAIGNS LIST WITH FILTERS
    func getCampaignListWITHFILTERS(_ user_id: String, _ user_role: String, _ category: String, _ status: String, _ title: String, _ strdate: String, _ enddate: String, _ retoucher_name: String, _ staff_name: String,  completion: @escaping (_ : BaseCampaignList?) -> Void)  {
        let parameters = [APIs.KCAMPAIGNFILTERS_P1_USERID: user_id,
                          APIs.KCAMPAIGNFILTERS_P2_USERROLE: user_role,
                          APIs.KCAMPAIGNFILTERS_P3_CATEGORY: category,
                          APIs.KCAMPAIGNFILTERS_P4_STATUS: status,
                          APIs.KCAMPAIGNFILTERS_P5_TITLE: title,
                          APIs.KCAMPAIGNFILTERS_P6_STARTDATE: strdate,
                          APIs.KCAMPAIGNFILTERS_P7_ENDDATE: enddate,
                          APIs.KCAMPAIGNFILTERS_P8_RETOUCHERNAME: retoucher_name,
                          APIs.KCAMPAIGNFILTERS_P9_STAFFNAME: staff_name]
        requestAPI(APIs.KCAMPAIGNFILTERS, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCampaignList.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET STAFF INVOICES WITH FILTERS
    func getStaffInvoicesFilters(_ user_id: String, _ catagory_id: String, _ title: String, _ status: String, _ strdate: String, _ enddate: String,  completion: @escaping (_ : BaseStaffInvoice?) -> Void)  {
        let parameters = [APIs.KSTAFFINVOICEFILTERS_P1_USERID: user_id,
                          APIs.KSTAFFINVOICEFILTERS_P2_CATAGORYID: catagory_id,
                          APIs.KSTAFFINVOICEFILTERS_P3_TITLE: title,
                          APIs.KSTAFFINVOICEFILTERS_P4_STATUS: status,
                          APIs.KSTAFFINVOICEFILTERS_P5_STARTDATE: strdate,
                          APIs.KSTAFFINVOICEFILTERS_P6_ENDDATE: enddate]
        
        requestAPI(APIs.KSTAFFINVOICEFILTERS, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffInvoice.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
 
    //MARK:- GET INVOICES WITH FILTERS  
    func allInvoiceWithFilters(_ user_id: String, _ catagory_id: String, _ title: String, _ status: String, _ staff_name: String, _ strdate: String, _ enddate: String, completion: @escaping (_ : BaseAllInvoices?) -> Void)  {
        let parameters = [APIs.KINVOICEFILTER_P1_USERID: user_id,
                          APIs.KINVOICEFILTER_P2_CATAGORID: catagory_id,
                          APIs.KINVOICEFILTER_P3_TITLE: title,
                          APIs.KINVOICEFILTER_P4_STATUS: status,
                          APIs.KINVOICEFILTER_P5_STAFFNAME: staff_name,
                          APIs.KINVOICEFILTER_P6_STARTDATE: strdate,
                          APIs.KINVOICEFILTER_P7_ENDDATE: enddate]
        requestAPI(APIs.KINVOICEFILTER, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseAllInvoices.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
}


