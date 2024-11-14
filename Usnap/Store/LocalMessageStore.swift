//
//  LocalMessageStore.swift
//  Usnap
//
//  Created by CSPC141 on 09/05/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import Foundation
import UIKit
import os.log

class LocalMessageStore: NSString {

    var chatCampaignId: String = ""
   
    class var sharedInstance: LocalMessageStore {
        struct Static {
            static let instance = LocalMessageStore()
        }
        return Static.instance
    }
    
    
}





