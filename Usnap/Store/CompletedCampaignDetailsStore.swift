//
//  CompletedCampaignDetailsStore.swift
//  Usnap
//
//  Created by CSPC141 on 14/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import Foundation
import UIKit

class CompletedCampaignStore: NSString {
   
    var CompletedCampaignId: String = ""
    var CompletedCampaignName: String = ""
    var CompletedcampaignImageId: String = ""
    var mediaImage = UIImage()
    var firstImageUrl: String = ""
    var lastImageUrl: String = ""
    var imageHeight = Float()
    var imageWidth = Float()
    var mediaComment = String()
    
    var selectedCategoryId: String = "0"
    
    // SHARED INSTANCE
    class var sharedInstance: CompletedCampaignStore {
        struct Static {
            static let instance = CompletedCampaignStore()
        }
        return Static.instance
    }
    
    
}
