//
//  MessageHistoryresult.swift
//
//  Created by CSPC141 on 10/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MessageHistoryresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMessageHistoryresultUserFirstNameKey: String = "user_first_name"
  private let kMessageHistoryresultSenderIdKey: String = "sender_id"
  private let kMessageHistoryresultInternalIdentifierKey: String = "id"
  private let kMessageHistoryresultMessageByKey: String = "message_by"
  private let kMessageHistoryresultReciverIdKey: String = "reciver_id"
  private let kMessageHistoryresultUserLastNameKey: String = "user_last_name"
  private let kMessageHistoryresultMessageKey: String = "message"
  private let kMessageHistoryresultCampaignIdKey: String = "campaign_id"
  private let kMessageHistoryresultReadUnreadKey: String = "read_unread"
  private let kMessageHistoryresultTimeKey: String = "time"

  // MARK: Properties
  public var userFirstName: String?
  public var senderId: String?
  public var internalIdentifier: String?
  public var messageBy: String?
  public var reciverId: String?
  public var userLastName: String?
  public var message: String?
  public var campaignId: String?
  public var readUnread: String?
  public var time: String?

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
    userFirstName = json[kMessageHistoryresultUserFirstNameKey].string
    senderId = json[kMessageHistoryresultSenderIdKey].string
    internalIdentifier = json[kMessageHistoryresultInternalIdentifierKey].string
    messageBy = json[kMessageHistoryresultMessageByKey].string
    reciverId = json[kMessageHistoryresultReciverIdKey].string
    userLastName = json[kMessageHistoryresultUserLastNameKey].string
    message = json[kMessageHistoryresultMessageKey].string
    campaignId = json[kMessageHistoryresultCampaignIdKey].string
    readUnread = json[kMessageHistoryresultReadUnreadKey].string
    time = json[kMessageHistoryresultTimeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userFirstName { dictionary[kMessageHistoryresultUserFirstNameKey] = value }
    if let value = senderId { dictionary[kMessageHistoryresultSenderIdKey] = value }
    if let value = internalIdentifier { dictionary[kMessageHistoryresultInternalIdentifierKey] = value }
    if let value = messageBy { dictionary[kMessageHistoryresultMessageByKey] = value }
    if let value = reciverId { dictionary[kMessageHistoryresultReciverIdKey] = value }
    if let value = userLastName { dictionary[kMessageHistoryresultUserLastNameKey] = value }
    if let value = message { dictionary[kMessageHistoryresultMessageKey] = value }
    if let value = campaignId { dictionary[kMessageHistoryresultCampaignIdKey] = value }
    if let value = readUnread { dictionary[kMessageHistoryresultReadUnreadKey] = value }
    if let value = time { dictionary[kMessageHistoryresultTimeKey] = value }
    return dictionary
  }

}
