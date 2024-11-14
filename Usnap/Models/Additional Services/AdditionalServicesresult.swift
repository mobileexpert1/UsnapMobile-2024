//
//  AdditionalServicesresult.swift
//
//  Created by CSPC141 on 09/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AdditionalServicesresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAdditionalServicesresultTimeTakenKey: String = "eta"
  private let kAdditionalServicesresultAmountPayableKey: String = "amount_payable"
  private let kAdditionalServicesresultTitleKey: String = "title"
  private let kAdditionalServicesresultCampaignPriceKey: String = "price"
  private let kAdditionalServicesresultServiceIdKey: String = "id"
  private let kAdditionalServicesresultCampaignTitleKey: String = "campaignTitle"
  private let kAdditionalServicesresultCommentKey: String = "comment"
    
    
    
    
    
  // MARK: Properties
  public var timeTaken: String?
  public var amountPayable: String?
  public var title: String?
  public var campaignPrice: String?
  public var serviceId: String?
  public var campaignTitle: String?
  public var comment: String?
    
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
    timeTaken = json[kAdditionalServicesresultTimeTakenKey].string
    amountPayable = json[kAdditionalServicesresultAmountPayableKey].string
    title = json[kAdditionalServicesresultTitleKey].string
    campaignPrice = json[kAdditionalServicesresultCampaignPriceKey].string
    serviceId = json[kAdditionalServicesresultServiceIdKey].string
    campaignTitle = json[kAdditionalServicesresultCampaignTitleKey].string
    comment = json[kAdditionalServicesresultCommentKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = timeTaken { dictionary[kAdditionalServicesresultTimeTakenKey] = value }
    if let value = amountPayable { dictionary[kAdditionalServicesresultAmountPayableKey] = value }
    if let value = title { dictionary[kAdditionalServicesresultTitleKey] = value }
    if let value = campaignPrice { dictionary[kAdditionalServicesresultCampaignPriceKey] = value }
    if let value = serviceId { dictionary[kAdditionalServicesresultServiceIdKey] = value }
    if let value = campaignTitle { dictionary[kAdditionalServicesresultCampaignTitleKey] = value }
    if let value = comment { dictionary[kAdditionalServicesresultCommentKey] = value }
    return dictionary
  }

}
