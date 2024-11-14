//
//  NewCampaignDatastaffMembers.swift
//
//  Created by CSPC141 on 22/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NewCampaignDatastaffMembers {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNewCampaignDatastaffMembersUserFirstNameKey: String = "user_first_name"
  private let kNewCampaignDatastaffMembersUserLastNameKey: String = "user_last_name"
  private let kNewCampaignDatastaffMembersUserIdKey: String = "id"

  // MARK: Properties
  public var userFirstName: String?
  public var userLastName: String?
  public var userId: String?

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
    userFirstName = json[kNewCampaignDatastaffMembersUserFirstNameKey].string
    userLastName = json[kNewCampaignDatastaffMembersUserLastNameKey].string
    userId = json[kNewCampaignDatastaffMembersUserIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userFirstName { dictionary[kNewCampaignDatastaffMembersUserFirstNameKey] = value }
    if let value = userLastName { dictionary[kNewCampaignDatastaffMembersUserLastNameKey] = value }
    if let value = userId { dictionary[kNewCampaignDatastaffMembersUserIdKey] = value }
    return dictionary
  }

}
