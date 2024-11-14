//
//  Learnresponse.swift
//
//  Created by CSPC141 on 6/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Learnresponse: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLearnresponseStatusKey: String = "status"
  private let kLearnresponseLearnresultKey: String = "result"

  // MARK: Properties
  public var status: String?
  public var learnresult: [Learnresult]?

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
    status = json[kLearnresponseStatusKey].string
    if let items = json[kLearnresponseLearnresultKey].array { learnresult = items.map { Learnresult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kLearnresponseStatusKey] = value }
    if let value = learnresult { dictionary[kLearnresponseLearnresultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.status = aDecoder.decodeObject(forKey: kLearnresponseStatusKey) as? String
    self.learnresult = aDecoder.decodeObject(forKey: kLearnresponseLearnresultKey) as? [Learnresult]
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(status, forKey: kLearnresponseStatusKey)
    aCoder.encode(learnresult, forKey: kLearnresponseLearnresultKey)
  }

}
