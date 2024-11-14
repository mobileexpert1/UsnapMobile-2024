//
//  BaseStaffInvoiceresult.swift
//
//  Created by CSPC141 on 04/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseStaffInvoiceresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseStaffInvoiceresultUserMobileKey: String = "user_mobile"
  private let kBaseStaffInvoiceresultBaseStaffInvoiceinvoicesKey: String = "invoices"
  private let kBaseStaffInvoiceresultUserEmailKey: String = "user_email"
  private let kBaseStaffInvoiceresultUserFirstNameKey: String = "user_first_name"
  private let kBaseStaffInvoiceresultUserLastNameKey: String = "user_last_name"

  // MARK: Properties
  public var userMobile: String?
  public var baseStaffInvoiceinvoices: [BaseStaffInvoiceinvoices]?
  public var userEmail: String?
  public var userFirstName: String?
  public var userLastName: String?
    

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
    userMobile = json[kBaseStaffInvoiceresultUserMobileKey].string
    if let items = json[kBaseStaffInvoiceresultBaseStaffInvoiceinvoicesKey].array { baseStaffInvoiceinvoices = items.map { BaseStaffInvoiceinvoices(json: $0) } }
    userEmail = json[kBaseStaffInvoiceresultUserEmailKey].string
    userFirstName = json[kBaseStaffInvoiceresultUserFirstNameKey].string
    userLastName = json[kBaseStaffInvoiceresultUserLastNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userMobile { dictionary[kBaseStaffInvoiceresultUserMobileKey] = value }
    if let value = baseStaffInvoiceinvoices { dictionary[kBaseStaffInvoiceresultBaseStaffInvoiceinvoicesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = userEmail { dictionary[kBaseStaffInvoiceresultUserEmailKey] = value }
    if let value = userFirstName { dictionary[kBaseStaffInvoiceresultUserFirstNameKey] = value }
    if let value = userLastName { dictionary[kBaseStaffInvoiceresultUserLastNameKey] = value }
    return dictionary
  }

}
