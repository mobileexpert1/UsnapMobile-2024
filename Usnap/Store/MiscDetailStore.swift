//
//  MiscDetailStore.swift
//  Usnap
//
//  Created by CSPC141 on 23/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import Foundation
import UIKit

class MiscDetailStore: NSDictionary {
    
    var pickerDataOldCampaigns = [NewCampaignDatacampaign]()
    var staffMembers = [NewCampaignDatastaffMembers]()
    var allCatories = [BaseAllCatagoriesresult]()
    var statusArray = [String]()
    var pickerTye = String()
    
    // SHARED INSTANCE
    class var sharedInstance: MiscDetailStore {
        struct Static {
            static let instance = MiscDetailStore()
        }
        return Static.instance
    }
    
    
}
