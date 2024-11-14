//
//  DownloadCamMediaresult.swift
//
//  Created by Lakhwinder Singh on 05/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct DownloadCamMediaresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kDownloadCamMediaresultMediaKey: String = "media"
  private let kDownloadCamMediaresultIsRevisionDateKey: String = "is_revision_date"
  private let kDownloadCamMediaresultInternalIdentifierKey: String = "id"
  private let kDownloadCamMediaresultUserRoleIdKey: String = "user_role_id"
  private let kDownloadCamMediaresultPresetKey: String = "preset"
  private let kDownloadCamMediaresultDeliverRevisionKey: String = "deliver_revision"
  private let kDownloadCamMediaresultCommentKey: String = "comment"
  private let kDownloadCamMediaresultAddDateKey: String = "add_date"
  private let kDownloadCamMediaresultCampaignIdKey: String = "campaign_id"
  private let kDownloadCamMediaresultIsRevisionKey: String = "is_revision"
  private let kDownloadCamMediaresultTypeKey: String = "type"
  private let kDownloadCamMediaresultTitleKey: String = "title"

  // MARK: Properties
  public var media: String?
  public var isRevisionDate: String?
  public var internalIdentifier: String?
  public var userRoleId: String?
  public var preset: String?
  public var deliverRevision: String?
  public var comment: String?
  public var addDate: String?
  public var campaignId: String?
  public var isRevision: String?
  public var type: String?
  public var title: String?

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
    media = json[kDownloadCamMediaresultMediaKey].string
    isRevisionDate = json[kDownloadCamMediaresultIsRevisionDateKey].string
    internalIdentifier = json[kDownloadCamMediaresultInternalIdentifierKey].string
    userRoleId = json[kDownloadCamMediaresultUserRoleIdKey].string
    preset = json[kDownloadCamMediaresultPresetKey].string
    deliverRevision = json[kDownloadCamMediaresultDeliverRevisionKey].string
    comment = json[kDownloadCamMediaresultCommentKey].string
    addDate = json[kDownloadCamMediaresultAddDateKey].string
    campaignId = json[kDownloadCamMediaresultCampaignIdKey].string
    isRevision = json[kDownloadCamMediaresultIsRevisionKey].string
    type = json[kDownloadCamMediaresultTypeKey].string
    title = json[kDownloadCamMediaresultTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = media { dictionary[kDownloadCamMediaresultMediaKey] = value }
    if let value = isRevisionDate { dictionary[kDownloadCamMediaresultIsRevisionDateKey] = value }
    if let value = internalIdentifier { dictionary[kDownloadCamMediaresultInternalIdentifierKey] = value }
    if let value = userRoleId { dictionary[kDownloadCamMediaresultUserRoleIdKey] = value }
    if let value = preset { dictionary[kDownloadCamMediaresultPresetKey] = value }
    if let value = deliverRevision { dictionary[kDownloadCamMediaresultDeliverRevisionKey] = value }
    if let value = comment { dictionary[kDownloadCamMediaresultCommentKey] = value }
    if let value = addDate { dictionary[kDownloadCamMediaresultAddDateKey] = value }
    if let value = campaignId { dictionary[kDownloadCamMediaresultCampaignIdKey] = value }
    if let value = isRevision { dictionary[kDownloadCamMediaresultIsRevisionKey] = value }
    if let value = type { dictionary[kDownloadCamMediaresultTypeKey] = value }
    if let value = title { dictionary[kDownloadCamMediaresultTitleKey] = value }
    return dictionary
  }

}
