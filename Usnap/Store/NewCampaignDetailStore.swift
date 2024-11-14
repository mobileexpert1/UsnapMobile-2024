//
//  NewCampaignDetailStore.swift
//  Usnap
//
//  Created by CSPC141 on 23/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewCampaignDetailStore: NSString {
    
    var selectedPhotosIndexes = [Int]()
    var selectedVideosIndexes = [Int]()
    var createdCampaignId = Int()
    var mediaDetail: [NSManagedObject] = []
    var videoDetail: [NSManagedObject] = []
    var selectedPics = [NSData]()
    var selectedPicsCamera = [NSData]()
    var selectedVids = [NSData]()
    var selectedCameraType = String()
    
    // SHARED INSTANCE
    class var sharedInstance: NewCampaignDetailStore {
        struct Static {
            static let instance = NewCampaignDetailStore()
        }
        return Static.instance
    }
}
