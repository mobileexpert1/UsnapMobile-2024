//
//  BaseCampaignMedia.swift
//
//  Created by CSPC141 on 17/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseCampaignMedia {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseCampaignMediaBaseCampaignMediaresponseKey: String = "response"

  // MARK: Properties
  public var baseCampaignMediaresponse: BaseCampaignMediaresponse?

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
    baseCampaignMediaresponse = BaseCampaignMediaresponse(json: json[kBaseCampaignMediaBaseCampaignMediaresponseKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = baseCampaignMediaresponse { dictionary[kBaseCampaignMediaBaseCampaignMediaresponseKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}