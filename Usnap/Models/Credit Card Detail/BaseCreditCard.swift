//
//  BaseCreditCard.swift
//
//  Created by CSPC141 on 28/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseCreditCard {
  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseCreditCardCradresponseKey: String = "response"

    
  // MARK: Properties
  public var cradresponse: Cradresponse?

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
    cradresponse = Cradresponse(json: json[kBaseCreditCardCradresponseKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = cradresponse { dictionary[kBaseCreditCardCradresponseKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}