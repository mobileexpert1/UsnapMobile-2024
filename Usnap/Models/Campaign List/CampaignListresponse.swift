//
//  CampaignListresponse.swift
//
//  Created by CSPC141 on 08/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CampaignListresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCampaignListresponseStatusKey: String = "status"
  private let kCampaignListresponseCampaignListresultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var campaignListresult: [CampaignListresult]?

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
    status = json[kCampaignListresponseStatusKey].string
    if let items = json[kCampaignListresponseCampaignListresultKey].array { campaignListresult = items.map { CampaignListresult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kCampaignListresponseStatusKey] = value }
    if let value = campaignListresult { dictionary[kCampaignListresponseCampaignListresultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
