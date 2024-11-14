//
//  BaseStaffInvoiceresponse.swift
//
//  Created by CSPC141 on 04/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseStaffInvoiceresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseStaffInvoiceresponseBaseStaffInvoiceresultKey: String = "result"
  private let kBaseStaffInvoiceresponseStatusKey: String = "status"

  // MARK: Properties
  public var baseStaffInvoiceresult: BaseStaffInvoiceresult?
  public var status: String?

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
    baseStaffInvoiceresult = BaseStaffInvoiceresult(json: json[kBaseStaffInvoiceresponseBaseStaffInvoiceresultKey])
    status = json[kBaseStaffInvoiceresponseStatusKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = baseStaffInvoiceresult { dictionary[kBaseStaffInvoiceresponseBaseStaffInvoiceresultKey] = value.dictionaryRepresentation() }
    if let value = status { dictionary[kBaseStaffInvoiceresponseStatusKey] = value }
    return dictionary
  }

}
