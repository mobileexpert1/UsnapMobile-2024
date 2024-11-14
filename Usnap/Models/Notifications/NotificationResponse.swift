//
//  NotificationResponse.swift
//
//  Created by Lakhwinder Singh on 29/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NotificationResponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNotificationResponseStatusKey: String = "status"
  private let kNotificationResponseNotificationResultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var notificationResult: [NotificationResult]?

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
    status = json[kNotificationResponseStatusKey].string
    if let items = json[kNotificationResponseNotificationResultKey].array { notificationResult = items.map { NotificationResult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kNotificationResponseStatusKey] = value }
    if let value = notificationResult { dictionary[kNotificationResponseNotificationResultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}