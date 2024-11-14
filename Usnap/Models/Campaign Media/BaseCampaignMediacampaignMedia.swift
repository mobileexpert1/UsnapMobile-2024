//
//  BaseCampaignMediacampaignMedia.swift
//
//  Created by CSPC141 on 17/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseCampaignMediacampaignMedia {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseCampaignMediacampaignMediaMediaKey: String = "media"
  private let kBaseCampaignMediacampaignMediaIsRevisionDateKey: String = "is_revision_date"
  private let kBaseCampaignMediacampaignMediaInternalIdentifierKey: String = "id"
  private let kBaseCampaignMediacampaignMediaUserRoleIdKey: String = "user_role_id"
  private let kBaseCampaignMediacampaignMediaAddDateKey: String = "add_date"
  private let kBaseCampaignMediacampaignMediaPresetKey: String = "preset"
  private let kBaseCampaignMediacampaignMediaCommentKey: String = "comment"
  private let kBaseCampaignMediacampaignMediaCampaignIdKey: String = "campaign_id"
  private let kBaseCampaignMediacampaignMediaPriceKey: String = "price"
  private let kBaseCampaignMediacampaignMediaIsRevisionKey: String = "is_revision"
  private let kBaseCampaignMediacampaignMediaTypeKey: String = "type"

  // MARK: Properties
  public var media: String?
  public var isRevisionDate: String?
  public var internalIdentifier: String?
  public var userRoleId: String?
  public var addDate: String?
  public var preset: String?
  public var comment: String?
  public var campaignId: String?
  public var price: String?
  public var isRevision: String?
  public var type: String?

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
    media = json[kBaseCampaignMediacampaignMediaMediaKey].string
    isRevisionDate = json[kBaseCampaignMediacampaignMediaIsRevisionDateKey].string
    internalIdentifier = json[kBaseCampaignMediacampaignMediaInternalIdentifierKey].string
    userRoleId = json[kBaseCampaignMediacampaignMediaUserRoleIdKey].string
    addDate = json[kBaseCampaignMediacampaignMediaAddDateKey].string
    preset = json[kBaseCampaignMediacampaignMediaPresetKey].string
    comment = json[kBaseCampaignMediacampaignMediaCommentKey].string
    campaignId = json[kBaseCampaignMediacampaignMediaCampaignIdKey].string
    price = json[kBaseCampaignMediacampaignMediaPriceKey].string
    isRevision = json[kBaseCampaignMediacampaignMediaIsRevisionKey].string
    type = json[kBaseCampaignMediacampaignMediaTypeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = media { dictionary[kBaseCampaignMediacampaignMediaMediaKey] = value }
    if let value = isRevisionDate { dictionary[kBaseCampaignMediacampaignMediaIsRevisionDateKey] = value }
    if let value = internalIdentifier { dictionary[kBaseCampaignMediacampaignMediaInternalIdentifierKey] = value }
    if let value = userRoleId { dictionary[kBaseCampaignMediacampaignMediaUserRoleIdKey] = value }
    if let value = addDate { dictionary[kBaseCampaignMediacampaignMediaAddDateKey] = value }
    if let value = preset { dictionary[kBaseCampaignMediacampaignMediaPresetKey] = value }
    if let value = comment { dictionary[kBaseCampaignMediacampaignMediaCommentKey] = value }
    if let value = campaignId { dictionary[kBaseCampaignMediacampaignMediaCampaignIdKey] = value }
    if let value = price { dictionary[kBaseCampaignMediacampaignMediaPriceKey] = value }
    if let value = isRevision { dictionary[kBaseCampaignMediacampaignMediaIsRevisionKey] = value }
    if let value = type { dictionary[kBaseCampaignMediacampaignMediaTypeKey] = value }
    return dictionary
  }

}
