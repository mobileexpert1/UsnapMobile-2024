//
//  BaseClassMessageList.swift
//
//  Created by CSPC141 on 09/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseClassMessageList {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseClassMessageListMessageListresponseKey: String = "response"

  // MARK: Properties
  public var messageListresponse: MessageListresponse?

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
    messageListresponse = MessageListresponse(json: json[kBaseClassMessageListMessageListresponseKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = messageListresponse { dictionary[kBaseClassMessageListMessageListresponseKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}
