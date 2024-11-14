//
//  CampaignDetailcampaignImages.swift
//
//  Created by CSPC141 on 16/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CampaignDetailcampaignImages {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCampaignDetailcampaignImagesMediaKey: String = "media"
    private let kCampaignDetailcampaignImagesInternalIdentifierKey: String = "id"
    private let kCampaignDetailcampaignImagesUserRoleIdKey: String = "user_role_id"
    private let kCampaignDetailcampaignImagesPresetKey: String = "preset"
    private let kCampaignDetailcampaignImagesLastRevisionKey: String = "last_revision"
    private let kCampaignDetailcampaignImagesCommentKey: String = "comment"
    private let kCampaignDetailcampaignImagesAddDateKey: String = "add_date"
    private let kCampaignDetailcampaignImagesCampaignIdKey: String = "campaign_id"
    private let kCampaignDetailcampaignImagesNoOfRevisionKey: String = "no_of_revision"
    private let kCampaignDetailcampaignImagesPriceKey: String = "price"
    private let kCampaignDetailcampaignImagesTypeKey: String = "type"
    private let kCampaignDetailcampaignImagesWidthKey: String = "width"
    private let kCampaignDetailcampaignImagesHeightKey: String = "height"
    private let kCampaignDetailresultThumbnailKey: String = "thumbnail"
    private let kCampaignDetailresultwaterMarkImageKey: String = "watermark"
    private let kCampaignDetailresultWebSizeVersionsImageKey: String = "websizeversion"
    private let kCampaignDetailresultCampaignCategoryIdKey: String = "campaign_category_id"
    
    
    
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
    public var width: String?
    public var height: String?
    public var thumbnail: String?
    public var waterMark: String?
    public var WebSizeVersions: String?
    public var CampaignCategoryId: Int?
    
    
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
        media = json[kCampaignDetailcampaignImagesMediaKey].string
        internalIdentifier = json[kCampaignDetailcampaignImagesInternalIdentifierKey].string
        userRoleId = json[kCampaignDetailcampaignImagesUserRoleIdKey].string
        preset = json[kCampaignDetailcampaignImagesPresetKey].string
        lastRevision = json[kCampaignDetailcampaignImagesLastRevisionKey].string
        comment = json[kCampaignDetailcampaignImagesCommentKey].string
        addDate = json[kCampaignDetailcampaignImagesAddDateKey].string
        campaignId = json[kCampaignDetailcampaignImagesCampaignIdKey].string
        noOfRevision = json[kCampaignDetailcampaignImagesNoOfRevisionKey].string
        price = json[kCampaignDetailcampaignImagesPriceKey].string
        type = json[kCampaignDetailcampaignImagesTypeKey].string
        width = json[kCampaignDetailcampaignImagesWidthKey].string
        height = json[kCampaignDetailcampaignImagesHeightKey].string
        thumbnail = json[kCampaignDetailresultThumbnailKey].string
        waterMark = json[kCampaignDetailresultwaterMarkImageKey].string
        WebSizeVersions = json[kCampaignDetailresultWebSizeVersionsImageKey].string
        CampaignCategoryId = json[kCampaignDetailresultCampaignCategoryIdKey].int
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = media { dictionary[kCampaignDetailcampaignImagesMediaKey] = value }
        if let value = internalIdentifier { dictionary[kCampaignDetailcampaignImagesInternalIdentifierKey] = value }
        if let value = userRoleId { dictionary[kCampaignDetailcampaignImagesUserRoleIdKey] = value }
        if let value = preset { dictionary[kCampaignDetailcampaignImagesPresetKey] = value }
        if let value = lastRevision { dictionary[kCampaignDetailcampaignImagesLastRevisionKey] = value }
        if let value = comment { dictionary[kCampaignDetailcampaignImagesCommentKey] = value }
        if let value = addDate { dictionary[kCampaignDetailcampaignImagesAddDateKey] = value }
        if let value = campaignId { dictionary[kCampaignDetailcampaignImagesCampaignIdKey] = value }
        if let value = noOfRevision { dictionary[kCampaignDetailcampaignImagesNoOfRevisionKey] = value }
        if let value = price { dictionary[kCampaignDetailcampaignImagesPriceKey] = value }
        if let value = type { dictionary[kCampaignDetailcampaignImagesTypeKey] = value }
        if let value = width { dictionary[kCampaignDetailcampaignImagesWidthKey] = value }
        if let value = height { dictionary[kCampaignDetailcampaignImagesHeightKey] = value }
        if let value = thumbnail { dictionary[kCampaignDetailresultThumbnailKey] = value }
        if let value = waterMark { dictionary[kCampaignDetailresultwaterMarkImageKey] = value }
        if let value = WebSizeVersions { dictionary[kCampaignDetailresultWebSizeVersionsImageKey] = value }
        if let value = CampaignCategoryId { dictionary[kCampaignDetailresultCampaignCategoryIdKey] = value }
        return dictionary
    }
}
