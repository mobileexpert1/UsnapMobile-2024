//
//  NewCampaignDetailcampaignMedia.swift
//
//  Created by CSPC141 on 16/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NewCampaignDetailcampaignMedia {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kNewCampaignDetailcampaignMediaMediaKey: String = "media"
    private let kNewCampaignDetailcampaignMediaInternalIdentifierKey: String = "id"
    private let kNewCampaignDetailcampaignMediaUserRoleIdKey: String = "user_role_id"
    private let kNewCampaignDetailcampaignMediaPresetKey: String = "preset"
    private let kNewCampaignDetailcampaignMediaLastRevisionKey: String = "last_revision"
    private let kNewCampaignDetailcampaignMediaCommentKey: String = "comment"
    private let kNewCampaignDetailcampaignMediaAddDateKey: String = "add_date"
    private let kNewCampaignDetailcampaignMediaCampaignIdKey: String = "campaign_id"
    private let kNewCampaignDetailcampaignMediaNoOfRevisionKey: String = "no_of_revision"
    private let kNewCampaignDetailcampaignMediaPriceKey: String = "price"
    private let kNewCampaignDetailcampaignMediaTypeKey: String = "type"
    private let kNewCampaignDetailcampaignMediaHeightKey: String = "height"
    private let kNewCampaignDetailcampaignMediaWidthKey: String = "width"
    private let kNewCampaignDetailcampaignThumbnailKey: String = "thumbnail"
    private let kCampaignDetailresultCampaignCategoryIdKey: String = "campaign_category_id"
    private let kCampaignDetailresultCampaignDetailaddOnServicesKey: String = "addOnServices"
    
    
    
    // MARK: Properties
    public var media: String?
    public var internalIdentifier: String?
    public var userRoleId: String?
    public var preset: String?
    public var lastRevision: String?
    public var comment: String?
    public var addDate: String?
    public var campaignId: String?
    public var noOfRevision: String?
    public var price: String?
    public var type: String?
    public var height: String?
    public var width: String?
    public var thumbnail: String?
    public var CampaignCategoryId: Int?
    public var campaignDetailaddOnServices: [CampaignDetailaddOnServices]?
    
    
    
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        media = json[kNewCampaignDetailcampaignMediaMediaKey].string
        internalIdentifier = json[kNewCampaignDetailcampaignMediaInternalIdentifierKey].string
        userRoleId = json[kNewCampaignDetailcampaignMediaUserRoleIdKey].string
        preset = json[kNewCampaignDetailcampaignMediaPresetKey].string
        lastRevision = json[kNewCampaignDetailcampaignMediaLastRevisionKey].string
        comment = json[kNewCampaignDetailcampaignMediaCommentKey].string
        addDate = json[kNewCampaignDetailcampaignMediaAddDateKey].string
        campaignId = json[kNewCampaignDetailcampaignMediaCampaignIdKey].string
        noOfRevision = json[kNewCampaignDetailcampaignMediaNoOfRevisionKey].string
        price = json[kNewCampaignDetailcampaignMediaPriceKey].string
        type = json[kNewCampaignDetailcampaignMediaTypeKey].string
        height = json[kNewCampaignDetailcampaignMediaHeightKey].string
        width = json[kNewCampaignDetailcampaignMediaWidthKey].string
        thumbnail = json[kNewCampaignDetailcampaignThumbnailKey].string
        CampaignCategoryId = json[kCampaignDetailresultCampaignCategoryIdKey].int
        if let items = json[kCampaignDetailresultCampaignDetailaddOnServicesKey].array { campaignDetailaddOnServices = items.map { CampaignDetailaddOnServices(json: $0) } }

        
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = media { dictionary[kNewCampaignDetailcampaignMediaMediaKey] = value }
        if let value = internalIdentifier { dictionary[kNewCampaignDetailcampaignMediaInternalIdentifierKey] = value }
        if let value = userRoleId { dictionary[kNewCampaignDetailcampaignMediaUserRoleIdKey] = value }
        if let value = preset { dictionary[kNewCampaignDetailcampaignMediaPresetKey] = value }
        if let value = lastRevision { dictionary[kNewCampaignDetailcampaignMediaLastRevisionKey] = value }
        if let value = comment { dictionary[kNewCampaignDetailcampaignMediaCommentKey] = value }
        if let value = addDate { dictionary[kNewCampaignDetailcampaignMediaAddDateKey] = value }
        if let value = campaignId { dictionary[kNewCampaignDetailcampaignMediaCampaignIdKey] = value }
        if let value = noOfRevision { dictionary[kNewCampaignDetailcampaignMediaNoOfRevisionKey] = value }
        if let value = price { dictionary[kNewCampaignDetailcampaignMediaPriceKey] = value }
        if let value = type { dictionary[kNewCampaignDetailcampaignMediaTypeKey] = value }
        if let value = height { dictionary[kNewCampaignDetailcampaignMediaHeightKey] = value }
        if let value = width { dictionary[kNewCampaignDetailcampaignMediaWidthKey] = value }
        if let value = thumbnail { dictionary[kNewCampaignDetailcampaignThumbnailKey] = value }
        if let value = CampaignCategoryId { dictionary[kCampaignDetailresultCampaignCategoryIdKey] = value }
        if let value = campaignDetailaddOnServices { dictionary[kCampaignDetailresultCampaignDetailaddOnServicesKey] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }
}
