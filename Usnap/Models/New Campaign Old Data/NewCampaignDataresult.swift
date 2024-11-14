//
//  NewCampaignDataresult.swift
//
//  Created by CSPC141 on 22/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NewCampaignDataresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNewCampaignDataresultNewCampaignDatacampaignKey: String = "campaign"
  private let kNewCampaignDataresultNewCampaignDatastaffMembersKey: String = "staff_members"
  private let kNewCampaignDataresultNewCampaignDataimagesKey: String = "images"
  private let kNewCampaignDataresultNewCampaignDatavideosKey: String = "videos"

  // MARK: Properties
  public var newCampaignDatacampaign: [NewCampaignDatacampaign]?
  public var newCampaignDatastaffMembers: [NewCampaignDatastaffMembers]?
  public var newCampaignDataimages: [NewCampaignDataimages]?
  public var newCampaignDatavideos: [NewCampaignDatavideos]?

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
    if let items = json[kNewCampaignDataresultNewCampaignDatacampaignKey].array { newCampaignDatacampaign = items.map { NewCampaignDatacampaign(json: $0) } }
    if let items = json[kNewCampaignDataresultNewCampaignDatastaffMembersKey].array { newCampaignDatastaffMembers = items.map { NewCampaignDatastaffMembers(json: $0) } }
    if let items = json[kNewCampaignDataresultNewCampaignDataimagesKey].array { newCampaignDataimages = items.map { NewCampaignDataimages(json: $0) } }
    if let items = json[kNewCampaignDataresultNewCampaignDatavideosKey].array { newCampaignDatavideos = items.map { NewCampaignDatavideos(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = newCampaignDatacampaign { dictionary[kNewCampaignDataresultNewCampaignDatacampaignKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = newCampaignDatastaffMembers { dictionary[kNewCampaignDataresultNewCampaignDatastaffMembersKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = newCampaignDataimages { dictionary[kNewCampaignDataresultNewCampaignDataimagesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = newCampaignDatavideos { dictionary[kNewCampaignDataresultNewCampaignDatavideosKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
