//
//  MessageListresult.swift
//
//  Created by CSPC141 on 09/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MessageListresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMessageListresultReadStatusKey: String = "read_status"
  private let kMessageListresultTitleKey: String = "title"
  private let kMessageListresultCampaignIdKey: String = "campaign_id"
  private let kMessageListresultLastMsgIdKey: String = "last_msg_id"
  private let kMessageListresultUnreadKey: String = "unread"

  // MARK: Properties
  public var readStatus: String?
  public var title: String?
  public var campaignId: String?
  public var lastMsgId: String?
  public var Unread: String?
    
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
    readStatus = json[kMessageListresultReadStatusKey].string
    title = json[kMessageListresultTitleKey].string
    campaignId = json[kMessageListresultCampaignIdKey].string
    lastMsgId = json[kMessageListresultLastMsgIdKey].string
    Unread = json[kMessageListresultUnreadKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = readStatus { dictionary[kMessageListresultReadStatusKey] = value }
    if let value = title { dictionary[kMessageListresultTitleKey] = value }
    if let value = campaignId { dictionary[kMessageListresultCampaignIdKey] = value }
    if let value = lastMsgId { dictionary[kMessageListresultLastMsgIdKey] = value }
    if let value = Unread { dictionary[kMessageListresultUnreadKey] = value }
    return dictionary
  }

}
