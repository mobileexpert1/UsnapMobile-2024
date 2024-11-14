//
//  BaseCampaignMediaresponse.swift
//
//  Created by CSPC141 on 17/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseCampaignMediaresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseCampaignMediaresponseStatusKey: String = "status"
  private let kBaseCampaignMediaresponseBaseCampaignMediaresultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var baseCampaignMediaresult: BaseCampaignMediaresult?

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
    status = json[kBaseCampaignMediaresponseStatusKey].string
    baseCampaignMediaresult = BaseCampaignMediaresult(json: json[kBaseCampaignMediaresponseBaseCampaignMediaresultKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kBaseCampaignMediaresponseStatusKey] = value }
    if let value = baseCampaignMediaresult { dictionary[kBaseCampaignMediaresponseBaseCampaignMediaresultKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}
