//
//  MessageSentresponse.swift
//
//  Created by CSPC141 on 10/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MessageSentresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMessageSentresponseStatusKey: String = "status"
  private let kMessageSentresponseMessageSentresultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var messageSentresult: [MessageSentresult]?

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
    status = json[kMessageSentresponseStatusKey].string
    if let items = json[kMessageSentresponseMessageSentresultKey].array { messageSentresult = items.map { MessageSentresult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kMessageSentresponseStatusKey] = value }
    if let value = messageSentresult { dictionary[kMessageSentresponseMessageSentresultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
