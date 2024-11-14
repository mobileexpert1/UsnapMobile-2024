//
//  PaymentStore.swift
//  Usnap
//
//  Created by CSPC141 on 21/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class PaymentStore: ApiStore {
    
    static let sharedInstance = PaymentStore()

    //MARK:- GET CREDIT CARD DETAILS
    func getCreditCardDetails(_ userID: String, completion: @escaping (_ : BaseCreditCard?) -> Void)  {
        let parameters = [APIs.KGETCREDITCARDDETAIL_P1_USERID: userID]
        requestAPI(APIs.KGETCREDITCARDDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCreditCard.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- UPDATE CREDIT CARD DETAILS
    func UpdateCreditCard(_ user_id: String, _ user_name: String, _ card_number: String, _ cvv: String, _ exp_date: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KUPDATECREDITCARDDETAIL_P1_USERID: user_id,
                          APIs.KUPDATECREDITCARDDETAIL_P2_NAME: user_name,
                          APIs.KUPDATECREDITCARDDETAIL_P3_CARDNUMBER: card_number,
                          APIs.KUPDATECREDITCARDDETAIL_P4_CVV: cvv,
                          APIs.KUPDATECREDITCARDDETAIL_P5_EXPDATE: exp_date]
        requestAPI(APIs.KUPDATECREDITCARDDETAIL, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- GET INVOICE LIST OF COMPLETED CAMPAIGNS
    func getCompletedCampaignInvoice(_ campaignId: String, completion: @escaping (_ : BaseCompletedCampaignInvoice?) -> Void)  {
        let parameters = [APIs.KCOMPLETEDINVOICECAMPAIGN_P1_CAMPAIGNID: campaignId]
        requestAPI(APIs.KCOMPLETEDINVOICECAMPAIGN, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseCompletedCampaignInvoice.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- RESEND CAMPAIGN INVOICE
    func resendCampaignInvoice(_ user_id: String, _ invoice_id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KRESENDINVOICE_P1_USERID: user_id,
                          APIs.KRESENDINVOICE_P1_INVOICEID:invoice_id]
        requestAPI(APIs.KRESENDINVOICE, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK:- ALL INVOICES
    func allInvoice(_ user_id: String, completion: @escaping (_ : BaseAllInvoices?) -> Void)  {
        let parameters = [APIs.KUSERINVOICES_P1_USERID: user_id]
        requestAPI(APIs.KUSERINVOICES, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseAllInvoices.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }

    
    //MARK:- PAY INVOICE NOW
    func payInvoiceNow(_ user_id: String, _ invoices_Id: String, completion: @escaping (_ : NSDictionary?) -> Void)  {
        let parameters = [APIs.KUSERINVOICESPAYNOW_P1_USERID: user_id,
                          APIs.KUSERINVOICESPAYNOW_P2_INVOICEID: invoices_Id]
        requestAPI(APIs.KUSERINVOICESPAYNOW, parameters: parameters) { (response) in
            if response != nil {
                completion(response)
            } else {
                completion(nil)
            }
        }
    }
    
    
    //MARK:- STAFF INVOICES
    func staffInvoices(_ user_id: String, completion: @escaping (_ : BaseStaffInvoice?) -> Void)  {
        let parameters = [APIs.KSTAFFINVOICE_P1_USERID: user_id]
        requestAPI(APIs.KSTAFFINVOICE, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseStaffInvoice.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
}
