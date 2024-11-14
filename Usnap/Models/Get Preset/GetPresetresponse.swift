//
//  GetPresetresponse.swift
//
//  Created by CSPC141 on 24/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct GetPresetresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kGetPresetresponseStatusKey: String = "status"
  private let kGetPresetresponsePriceForWatermarkKey: String = "price_for_watermark"
    
  private let kGetPresetresponseGetPresetresultKey: String = "result"
  private let kGetPresetresponseMessageKey: String = "message"

  // MARK: Properties
  public var status: String?
  public var PriceForWatermark: String?
  public var getPresetresult: [GetPresetresult]?
  public var message: String?

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
    status = json[kGetPresetresponseStatusKey].string
    PriceForWatermark = json[kGetPresetresponsePriceForWatermarkKey].string
    if let items = json[kGetPresetresponseGetPresetresultKey].array { getPresetresult = items.map { GetPresetresult(json: $0) } }
    message = json[kGetPresetresponseMessageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kGetPresetresponseStatusKey] = value }
    if let value = PriceForWatermark { dictionary[kGetPresetresponsePriceForWatermarkKey] = value }
    if let value = getPresetresult { dictionary[kGetPresetresponseGetPresetresultKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = message { dictionary[kGetPresetresponseMessageKey] = value }
    return dictionary
  }

}
