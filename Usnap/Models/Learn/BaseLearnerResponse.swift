//
//  BaseLearnerResponse.swift
//
//  Created by CSPC141 on 6/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class BaseLearnerResponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseLearnerResponseLearnresponseKey: String = "response"

  // MARK: Properties
  public var learnresponse: Learnresponse?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    learnresponse = Learnresponse(json: json[kBaseLearnerResponseLearnresponseKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = learnresponse { dictionary[kBaseLearnerResponseLearnresponseKey] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.learnresponse = aDecoder.decodeObject(forKey: kBaseLearnerResponseLearnresponseKey) as? Learnresponse
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(learnresponse, forKey: kBaseLearnerResponseLearnresponseKey)
  }

}
