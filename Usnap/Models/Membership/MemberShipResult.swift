//
//  MemberShipResult.swift
//
//  Created by Lakhwinder Singh on 18/06/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct MemberShipResult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kMemberShipResultYouAreSubscribedToKey: String = "You_are_subscribed_to"
  private let kMemberShipResultNameKey: String = "name"
  private let kMemberShipResultBenefitsKey: String = "benefits"
  private let kMemberShipResultInternalIdentifierKey: String = "id"
  private let kMemberShipResultChargesKey: String = "charges"
  private let kMemberShipResultCycleKey: String = "cycle"
  private let kMemberShipResultAddDateKey: String = "add_date"
  private let kMemberShipResultEditDateKey: String = "edit_date"
  private let kMemberShipResultCardExistKey: String = "card_exist"
    

  // MARK: Properties
  public var youAreSubscribedTo: String?
  public var name: String?
  public var benefits: String?
  public var internalIdentifier: String?
  public var charges: String?
  public var cycle: String?
  public var addDate: String?
  public var editDate: String?
  public var cardExist: String?
    
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
    youAreSubscribedTo = json[kMemberShipResultYouAreSubscribedToKey].string
    name = json[kMemberShipResultNameKey].string
    benefits = json[kMemberShipResultBenefitsKey].string
    internalIdentifier = json[kMemberShipResultInternalIdentifierKey].string
    charges = json[kMemberShipResultChargesKey].string
    cycle = json[kMemberShipResultCycleKey].string
    addDate = json[kMemberShipResultAddDateKey].string
    editDate = json[kMemberShipResultEditDateKey].string
    cardExist = json[kMemberShipResultCardExistKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = youAreSubscribedTo { dictionary[kMemberShipResultYouAreSubscribedToKey] = value }
    if let value = name { dictionary[kMemberShipResultNameKey] = value }
    if let value = benefits { dictionary[kMemberShipResultBenefitsKey] = value }
    if let value = internalIdentifier { dictionary[kMemberShipResultInternalIdentifierKey] = value }
    if let value = charges { dictionary[kMemberShipResultChargesKey] = value }
    if let value = cycle { dictionary[kMemberShipResultCycleKey] = value }
    if let value = addDate { dictionary[kMemberShipResultAddDateKey] = value }
    if let value = editDate { dictionary[kMemberShipResultEditDateKey] = value }
    if let value = cardExist { dictionary[kMemberShipResultCardExistKey] = value }
    return dictionary
  }

}
