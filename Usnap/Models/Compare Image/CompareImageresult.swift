//
//  CompareImageresult.swift
//
//  Created by CSPC141 on 16/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CompareImageresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCompareImageresultMediaKey: String = "media"
  private let kCompareImageresultInternalIdentifierKey: String = "id"
  private let kCompareImageresultUserRoleIdKey: String = "user_role_id"
  private let kCompareImageresultAddDateKey: String = "add_date"
  private let kCompareImageresultPresetKey: String = "preset"
  private let kCompareImageresultSubmittedByKey: String = "submitted_by"
  private let kCompareImageresultTitleKey: String = "title"
  private let kCompareImageresultCommentKey: String = "comment"
  private let kCompareImageresultCampaignIdKey: String = "campaign_id"
  private let kCompareImageresultPriceKey: String = "price"
  private let kCompareImageresultTypeKey: String = "type"

  // MARK: Properties
  public var media: String?
  public var internalIdentifier: String?
  public var userRoleId: String?
  public var addDate: String?
  public var preset: String?
  public var submittedBy: String?
  public var title: String?
  public var comment: String?
  public var campaignId: String?
  public var price: String?
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
    media = json[kCompareImageresultMediaKey].string
    internalIdentifier = json[kCompareImageresultInternalIdentifierKey].string
    userRoleId = json[kCompareImageresultUserRoleIdKey].string
    addDate = json[kCompareImageresultAddDateKey].string
    preset = json[kCompareImageresultPresetKey].string
    submittedBy = json[kCompareImageresultSubmittedByKey].string
    title = json[kCompareImageresultTitleKey].string
    comment = json[kCompareImageresultCommentKey].string
    campaignId = json[kCompareImageresultCampaignIdKey].string
    price = json[kCompareImageresultPriceKey].string
    type = json[kCompareImageresultTypeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = media { dictionary[kCompareImageresultMediaKey] = value }
    if let value = internalIdentifier { dictionary[kCompareImageresultInternalIdentifierKey] = value }
    if let value = userRoleId { dictionary[kCompareImageresultUserRoleIdKey] = value }
    if let value = addDate { dictionary[kCompareImageresultAddDateKey] = value }
    if let value = preset { dictionary[kCompareImageresultPresetKey] = value }
    if let value = submittedBy { dictionary[kCompareImageresultSubmittedByKey] = value }
    if let value = title { dictionary[kCompareImageresultTitleKey] = value }
    if let value = comment { dictionary[kCompareImageresultCommentKey] = value }
    if let value = campaignId { dictionary[kCompareImageresultCampaignIdKey] = value }
    if let value = price { dictionary[kCompareImageresultPriceKey] = value }
    if let value = type { dictionary[kCompareImageresultTypeKey] = value }
    return dictionary
  }

}
