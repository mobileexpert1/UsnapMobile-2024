//
//  BaseAllCatagoriesresult.swift
//
//  Created by CSPC141 on 05/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseAllCatagoriesresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseAllCatagoriesresultCategoryIdKey: String = "id"
  private let kBaseAllCatagoriesresultCategoryNameKey: String = "category_name"

  // MARK: Properties
  public var categoryId: String?
  public var categoryName: String?

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
    categoryId = json[kBaseAllCatagoriesresultCategoryIdKey].string
    categoryName = json[kBaseAllCatagoriesresultCategoryNameKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = categoryId { dictionary[kBaseAllCatagoriesresultCategoryIdKey] = value }
    if let value = categoryName { dictionary[kBaseAllCatagoriesresultCategoryNameKey] = value }
    return dictionary
  }

}
