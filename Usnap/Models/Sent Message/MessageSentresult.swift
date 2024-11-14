//
//  MessageSentresult.swift
//
//  Created by CSPC141 on 10/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MessageSentresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMessageSentresultUserFirstNameKey: String = "user_first_name"
  private let kMessageSentresultSenderIdKey: String = "sender_id"
  private let kMessageSentresultInternalIdentifierKey: String = "id"
  private let kMessageSentresultMessageByKey: String = "message_by"
  private let kMessageSentresultReciverIdKey: String = "reciver_id"
  private let kMessageSentresultUserLastNameKey: String = "user_last_name"
  private let kMessageSentresultMessageKey: String = "message"
  private let kMessageSentresultCampaignIdKey: String = "campaign_id"
  private let kMessageSentresultReadUnreadKey: String = "read_unread"
  private let kMessageSentresultTimeKey: String = "time"

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
    userFirstName = json[kMessageSentresultUserFirstNameKey].string
    senderId = json[kMessageSentresultSenderIdKey].string
    internalIdentifier = json[kMessageSentresultInternalIdentifierKey].string
    messageBy = json[kMessageSentresultMessageByKey].string
    reciverId = json[kMessageSentresultReciverIdKey].string
    userLastName = json[kMessageSentresultUserLastNameKey].string
    message = json[kMessageSentresultMessageKey].string
    campaignId = json[kMessageSentresultCampaignIdKey].string
    readUnread = json[kMessageSentresultReadUnreadKey].string
    time = json[kMessageSentresultTimeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userFirstName { dictionary[kMessageSentresultUserFirstNameKey] = value }
    if let value = senderId { dictionary[kMessageSentresultSenderIdKey] = value }
    if let value = internalIdentifier { dictionary[kMessageSentresultInternalIdentifierKey] = value }
    if let value = messageBy { dictionary[kMessageSentresultMessageByKey] = value }
    if let value = reciverId { dictionary[kMessageSentresultReciverIdKey] = value }
    if let value = userLastName { dictionary[kMessageSentresultUserLastNameKey] = value }
    if let value = message { dictionary[kMessageSentresultMessageKey] = value }
    if let value = campaignId { dictionary[kMessageSentresultCampaignIdKey] = value }
    if let value = readUnread { dictionary[kMessageSentresultReadUnreadKey] = value }
    if let value = time { dictionary[kMessageSentresultTimeKey] = value }
    return dictionary
  }

}
