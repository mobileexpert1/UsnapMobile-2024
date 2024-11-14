//
//  CampaignDetailaddOnServices.swift
//  Usnap
//
//  Created by Mobile on 23/06/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

public struct CampaignDetailaddOnServices {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCampaignDetailcampaignImagesInternalIdentifierKey: String = "id"
    private let kCampaignDetailcampaignImagesUserRoleIdKey: String = "user_role_id"
    private let kCampaignDetailcampaignImagesServiceIdKey: String = "serviceId"
    private let kCampaignDetailcampaignImagesCampaignMediaIdKey: String = "campaignMediaId"
    private let kCampaignDetailcampaignImagesCampaignIdKey: String = "campaignId"
    private let kCampaignDetailcampaignImagesQtyKey: String = "qty"
    private let kCampaignDetailcampaignImagesSubCategoryNameKey: String = "subCategoryName"
    
    // MARK: Properties
    public var internalIdentifier: String?
    public var userRoleId: String?
    public var serviceId: String?
    public var campaignMediaId: String?
    public var campaignId: String?
    public var qty: String?
    public var subCategoryName: String?
    
    
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
        internalIdentifier = json[kCampaignDetailcampaignImagesInternalIdentifierKey].string
        userRoleId = json[kCampaignDetailcampaignImagesUserRoleIdKey].string
        serviceId = json[kCampaignDetailcampaignImagesServiceIdKey].string
        campaignMediaId = json[kCampaignDetailcampaignImagesCampaignMediaIdKey].string
        campaignId = json[kCampaignDetailcampaignImagesCampaignIdKey].string
        qty = json[kCampaignDetailcampaignImagesQtyKey].string
        subCategoryName = json[kCampaignDetailcampaignImagesSubCategoryNameKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = internalIdentifier { dictionary[kCampaignDetailcampaignImagesInternalIdentifierKey] = value }
        if let value = userRoleId { dictionary[kCampaignDetailcampaignImagesUserRoleIdKey] = value }
        if let value = serviceId { dictionary[kCampaignDetailcampaignImagesServiceIdKey] = value }
        if let value = campaignMediaId { dictionary[kCampaignDetailcampaignImagesCampaignMediaIdKey] = value }
        if let value = campaignId { dictionary[kCampaignDetailcampaignImagesCampaignIdKey] = value }
        if let value = qty { dictionary[kCampaignDetailcampaignImagesQtyKey] = value }
        if let value = subCategoryName { dictionary[kCampaignDetailcampaignImagesSubCategoryNameKey] = value }
        return dictionary
    }
}
