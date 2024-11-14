//
//  BaseFaqresult.swift
//
//  Created by CSPC141 on 05/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseFaqresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseFaqresultQuesKey: String = "ques"
  private let kBaseFaqresultMstTypeIdKey: String = "mst_type_id"
  private let kBaseFaqresultInternalIdentifierKey: String = "id"
  private let kBaseFaqresultSubtypeKey: String = "subtype"
  private let kBaseFaqresultAnsKey: String = "ans"
  private let kBaseFaqresultFaqIdKey: String = "faq_id"
  private let kBaseFaqresultTypeKey: String = "type"

  // MARK: Properties
  public var ques: String?
  public var mstTypeId: String?
  public var internalIdentifier: String?
  public var subtype: String?
  public var ans: String?
  public var faqId: String?
  public var type: String?

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
    ques = json[kBaseFaqresultQuesKey].string
    mstTypeId = json[kBaseFaqresultMstTypeIdKey].string
    internalIdentifier = json[kBaseFaqresultInternalIdentifierKey].string
    subtype = json[kBaseFaqresultSubtypeKey].string
    ans = json[kBaseFaqresultAnsKey].string
    faqId = json[kBaseFaqresultFaqIdKey].string
    type = json[kBaseFaqresultTypeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = ques { dictionary[kBaseFaqresultQuesKey] = value }
    if let value = mstTypeId { dictionary[kBaseFaqresultMstTypeIdKey] = value }
    if let value = internalIdentifier { dictionary[kBaseFaqresultInternalIdentifierKey] = value }
    if let value = subtype { dictionary[kBaseFaqresultSubtypeKey] = value }
    if let value = ans { dictionary[kBaseFaqresultAnsKey] = value }
    if let value = faqId { dictionary[kBaseFaqresultFaqIdKey] = value }
    if let value = type { dictionary[kBaseFaqresultTypeKey] = value }
    return dictionary
  }

}
