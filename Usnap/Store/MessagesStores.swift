//
//  MessagesStores.swift
//  Usnap
//
//  Created by CSPC141 on 09/05/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit
import Foundation

class MessagesStores: ApiStore {
    static let sharedInstance = MessagesStores()
    
    // MESSAGE TITLES
    func MessageList(_ user_role_id: String, completion: @escaping (_ : BaseClassMessageList?) -> Void)  {
        let parameters = [APIs.KMESSAGESTITLES_P1_USERID: user_role_id]
        requestAPI(APIs.KMESSAGESTITLES, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassMessageList.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
  
    // MESSAGE HISTORY
    func MessageHistory(_ user_role_id: String, _ campaign_id: String, _ page_no: String, completion: @escaping (_ : BaseClassMessageHistory?) -> Void)  {
        let parameters = [APIs.KMESSAGESHISTORY_P1_USERID: user_role_id, APIs.KMESSAGESHISTORY_P2_CAMPAIGNID: campaign_id, APIs.KMESSAGESHISTORY_P3_PAGENO: page_no]
        requestAPI(APIs.KMESSAGESHISTORY, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassMessageHistory.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    // MESSAGE REFRESH
    func MessageRefresh(_ user_role_id: String, _ campaign_id: String, _ lastMessageID: String, completion: @escaping (_ : BaseClassMessageHistory?) -> Void)  {
        let parameters = [APIs.KREFRESHMESSAGE_P1_USERID: user_role_id, APIs.KREFRESHMESSAGE_P2_CAMPAIGNID: campaign_id, APIs.KREFRESHMESSAGE_P3_LASTMESSAGEID: lastMessageID]
        requestAPI(APIs.KREFRESHMESSAGE, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassMessageHistory.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
    // SEND CHAT MESSAGE
    func sendChatMessage(_ user_role_id: String, _ campaign_id: String, _ sender_id: String, _ message: String, _ message_load: String, completion: @escaping (_ : BaseClassMessageHistory?) -> Void)  {
        let parameters = [APIs.KSENDCHATMESSAGE_P1_USERID: user_role_id, APIs.KSENDCHATMESSAGE_P2_CAMPAIGNID: campaign_id, APIs.KSENDCHATMESSAGE_P3_SENDERID: sender_id, APIs.KSENDCHATMESSAGE_P4_MESSAGE: message, APIs.KSENDCHATMESSAGE_P5_MESSAGELOAD: message_load]
        requestAPI(APIs.KSENDCHATMESSAGE, parameters: parameters) { (response) in
            if response != nil {
                completion(BaseClassMessageHistory.init(object: response!))
            } else {
                completion(nil)
            }
        }
    }
    
    
}
