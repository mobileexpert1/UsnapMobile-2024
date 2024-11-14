//
//  AllInvoicesresult.swift
//
//  Created by CSPC141 on 20/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AllInvoicesresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAllInvoicesresultAllInvoicespendingKey: String = "pending"
  private let kAllInvoicesresultAllInvoicespaidKey: String = "paid"

  // MARK: Properties
  public var allInvoicespending: [AllInvoicespending]?
  public var allInvoicespaid: [AllInvoicespaid]?

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
    if let items = json[kAllInvoicesresultAllInvoicespendingKey].array { allInvoicespending = items.map { AllInvoicespending(json: $0) } }
    if let items = json[kAllInvoicesresultAllInvoicespaidKey].array { allInvoicespaid = items.map { AllInvoicespaid(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = allInvoicespending { dictionary[kAllInvoicesresultAllInvoicespendingKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = allInvoicespaid { dictionary[kAllInvoicesresultAllInvoicespaidKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
