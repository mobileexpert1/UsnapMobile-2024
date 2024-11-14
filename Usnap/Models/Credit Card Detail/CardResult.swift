//
//  CardResult.swift
//
//  Created by CSPC141 on 28/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CardResult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCardResultCardHolderNameKey: String = "card_holder_name"
  private let kCardResultIsReadyKey: String = "is_ready"
  private let kCardResultExpYearKey: String = "exp_year"
  private let kCardResultCardNoKey: String = "card_no"
  private let kCardResultCvvNoKey: String = "cvv_no"
  private let kCardResultAddDateKey: String = "add_date"
  private let kCardResultExpMonthKey: String = "exp_month"
  private let kCardResultUserIdKey: String = "user_id"
  private let kCardResultTokenIdKey: String = "token_id"
  private let kCardResultEditDateKey: String = "edit_date"
  private let kCardResultCardIdKey: String = "card_id"

  // MARK: Properties
  public var cardHolderName: String?
  public var isReady: String?
  public var expYear: String?
  public var cardNo: String?
  public var cvvNo: String?
  public var addDate: String?
  public var expMonth: String?
  public var userId: String?
  public var tokenId: String?
  public var editDate: String?
  public var cardId: String?

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
    cardHolderName = json[kCardResultCardHolderNameKey].string
    isReady = json[kCardResultIsReadyKey].string
    expYear = json[kCardResultExpYearKey].string
    cardNo = json[kCardResultCardNoKey].string
    cvvNo = json[kCardResultCvvNoKey].string
    addDate = json[kCardResultAddDateKey].string
    expMonth = json[kCardResultExpMonthKey].string
    userId = json[kCardResultUserIdKey].string
    tokenId = json[kCardResultTokenIdKey].string
    editDate = json[kCardResultEditDateKey].string
    cardId = json[kCardResultCardIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = cardHolderName { dictionary[kCardResultCardHolderNameKey] = value }
    if let value = isReady { dictionary[kCardResultIsReadyKey] = value }
    if let value = expYear { dictionary[kCardResultExpYearKey] = value }
    if let value = cardNo { dictionary[kCardResultCardNoKey] = value }
    if let value = cvvNo { dictionary[kCardResultCvvNoKey] = value }
    if let value = addDate { dictionary[kCardResultAddDateKey] = value }
    if let value = expMonth { dictionary[kCardResultExpMonthKey] = value }
    if let value = userId { dictionary[kCardResultUserIdKey] = value }
    if let value = tokenId { dictionary[kCardResultTokenIdKey] = value }
    if let value = editDate { dictionary[kCardResultEditDateKey] = value }
    if let value = cardId { dictionary[kCardResultCardIdKey] = value }
    return dictionary
  }

}
