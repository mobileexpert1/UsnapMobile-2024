//
//  NotificationResult.swift
//
//  Created by Lakhwinder Singh on 29/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NotificationResult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNotificationResultNotiRelIdKey: String = "noti_rel_id"
  private let kNotificationResultStatusKey: String = "status"
  private let kNotificationResultSenderIDKey: String = "senderID"
  private let kNotificationResultInternalIdentifierKey: String = "id"
  private let kNotificationResultAddDateKey: String = "add_date"
  private let kNotificationResultTableNameKey: String = "table_name"
  private let kNotificationResultMsgTypeKey: String = "msg_type"
  private let kNotificationResultMessageKey: String = "message"
  private let kNotificationResultReceiverIDKey: String = "receiverID"
  private let kNotificationResultMsgKey: String = "msg"
  private let kNotificationResultUserSwitchKey: String = "user_switch"

  // MARK: Properties
  public var notiRelId: String?
  public var status: String?
  public var senderID: String?
  public var internalIdentifier: String?
  public var addDate: String?
  public var tableName: String?
  public var msgType: String?
  public var message: String?
  public var receiverID: String?
  public var msg: String?
  public var UserSwitch: String?

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
    notiRelId = json[kNotificationResultNotiRelIdKey].string
    status = json[kNotificationResultStatusKey].string
    senderID = json[kNotificationResultSenderIDKey].string
    internalIdentifier = json[kNotificationResultInternalIdentifierKey].string
    addDate = json[kNotificationResultAddDateKey].string
    tableName = json[kNotificationResultTableNameKey].string
    msgType = json[kNotificationResultMsgTypeKey].string
    message = json[kNotificationResultMessageKey].string
    receiverID = json[kNotificationResultReceiverIDKey].string
    msg = json[kNotificationResultMsgKey].string
    UserSwitch = json[kNotificationResultUserSwitchKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = notiRelId { dictionary[kNotificationResultNotiRelIdKey] = value }
    if let value = status { dictionary[kNotificationResultStatusKey] = value }
    if let value = senderID { dictionary[kNotificationResultSenderIDKey] = value }
    if let value = internalIdentifier { dictionary[kNotificationResultInternalIdentifierKey] = value }
    if let value = addDate { dictionary[kNotificationResultAddDateKey] = value }
    if let value = tableName { dictionary[kNotificationResultTableNameKey] = value }
    if let value = msgType { dictionary[kNotificationResultMsgTypeKey] = value }
    if let value = message { dictionary[kNotificationResultMessageKey] = value }
    if let value = receiverID { dictionary[kNotificationResultReceiverIDKey] = value }
    if let value = msg { dictionary[kNotificationResultMsgKey] = value }
    if let value = UserSwitch { dictionary[kNotificationResultUserSwitchKey] = value }
    return dictionary
  }

}
