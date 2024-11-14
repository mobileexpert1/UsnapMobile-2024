//
//  MemberShipResponse.swift
//
//  Created by Lakhwinder Singh on 18/06/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MemberShipResponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMemberShipResponseCardExistKey: String = "card_exist"
  private let kMemberShipResponseStatusKey: String = "status"
  private let kMemberShipResponseMemberShipResultKey: String = "result"

  // MARK: Properties
  public var cardExist: String?
  public var status: String?
  public var memberShipResult: [MemberShipResult]?

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
    cardExist = json[kMemberShipResponseCardExistKey].string
    status = json[kMemberShipResponseStatusKey].string
    if let items = json[kMemberShipResponseMemberShipResultKey].array { memberShipResult = items.map { MemberShipResult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = cardExist { dictionary[kMemberShipResponseCardExistKey] = value }
    if let value = status { dictionary[kMemberShipResponseStatusKey] = value }
    if let value = memberShipResult { dictionary[kMemberShipResponseMemberShipResultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
