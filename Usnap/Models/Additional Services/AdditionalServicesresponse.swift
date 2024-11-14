//
//  AdditionalServicesresponse.swift
//
//  Created by CSPC141 on 09/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AdditionalServicesresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAdditionalServicesresponseStatusKey: String = "status"
  private let kAdditionalServicesresponseAdditionalServicesresultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var additionalServicesresult: [AdditionalServicesresult]?

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
    status = json[kAdditionalServicesresponseStatusKey].string
    if let items = json[kAdditionalServicesresponseAdditionalServicesresultKey].array { additionalServicesresult = items.map { AdditionalServicesresult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kAdditionalServicesresponseStatusKey] = value }
    if let value = additionalServicesresult { dictionary[kAdditionalServicesresponseAdditionalServicesresultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
