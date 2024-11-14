//
//  CampaignListresult.swift
//
//  Created by CSPC141 on 08/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CampaignListresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCampaignListresultStateKey: String = "state"
  private let kCampaignListresultCityKey: String = "city"
  private let kCampaignListresultAddDateKey: String = "add_date"
  private let kCampaignListresultUserRoleKey: String = "user_role"
  private let kCampaignListresultStatusKey: String = "status"
  private let kCampaignListresultCatagoriesKey: String = "catagories"
  private let kCampaignListresultUpdateTimeKey: String = "update_time"
  private let kCampaignListresultInternalIdentifierKey: String = "id"
  private let kCampaignListresultAssignedToKey: String = "assigned_to"
  private let kCampaignListresultTitleKey: String = "title"
  private let kCampaignListresultUserIdKey: String = "user_id"
  private let kCampaignListresultPostalCodeKey: String = "postal_code"
  private let kCampaignListresultCountryKey: String = "country"
  private let kCampaignListresultAssignedRetoucher: String = "assigned_retoucher"

  // MARK: Properties
  public var state: String?
  public var city: String?
  public var addDate: String?
  public var userRole: String?
  public var status: String?
  public var catagories: String?
  public var updateTime: String?
  public var internalIdentifier: String?
  public var assignedTo: String?
  public var title: String?
  public var userId: String?
  public var postalCode: String?
  public var country: String?
  public var assignedRetoucher: String?
    
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
    state = json[kCampaignListresultStateKey].string
    city = json[kCampaignListresultCityKey].string
    addDate = json[kCampaignListresultAddDateKey].string
    userRole = json[kCampaignListresultUserRoleKey].string
    status = json[kCampaignListresultStatusKey].string
    catagories = json[kCampaignListresultCatagoriesKey].string
    updateTime = json[kCampaignListresultUpdateTimeKey].string
    internalIdentifier = json[kCampaignListresultInternalIdentifierKey].string
    assignedTo = json[kCampaignListresultAssignedToKey].string
    title = json[kCampaignListresultTitleKey].string
    userId = json[kCampaignListresultUserIdKey].string
    postalCode = json[kCampaignListresultPostalCodeKey].string
    country = json[kCampaignListresultCountryKey].string
    assignedRetoucher = json[kCampaignListresultAssignedRetoucher].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[kCampaignListresultStateKey] = value }
    if let value = city { dictionary[kCampaignListresultCityKey] = value }
    if let value = addDate { dictionary[kCampaignListresultAddDateKey] = value }
    if let value = userRole { dictionary[kCampaignListresultUserRoleKey] = value }
    if let value = status { dictionary[kCampaignListresultStatusKey] = value }
    if let value = catagories { dictionary[kCampaignListresultCatagoriesKey] = value }
    if let value = updateTime { dictionary[kCampaignListresultUpdateTimeKey] = value }
    if let value = internalIdentifier { dictionary[kCampaignListresultInternalIdentifierKey] = value }
    if let value = assignedTo { dictionary[kCampaignListresultAssignedToKey] = value }
    if let value = title { dictionary[kCampaignListresultTitleKey] = value }
    if let value = userId { dictionary[kCampaignListresultUserIdKey] = value }
    if let value = postalCode { dictionary[kCampaignListresultPostalCodeKey] = value }
    if let value = country { dictionary[kCampaignListresultCountryKey] = value }
    if let value = assignedRetoucher { dictionary[kCampaignListresultAssignedRetoucher] = value }
    return dictionary
  }

}
