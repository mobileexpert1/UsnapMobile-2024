//
//  Staffresponse.swift
//
//  Created by CSPC141 on 15/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Staffresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kStaffresponseTotalRequestsKey: String = "total_requests"
  private let kStaffresponseStatusKey: String = "status"
  private let kStaffresponseStaffresultKey: String = "result"

  // MARK: Properties
  public var totalRequests: Int?
  public var status: String?
  public var staffresult: [Staffresult]?

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
    totalRequests = json[kStaffresponseTotalRequestsKey].int
    status = json[kStaffresponseStatusKey].string
    if let items = json[kStaffresponseStaffresultKey].array { staffresult = items.map { Staffresult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = totalRequests { dictionary[kStaffresponseTotalRequestsKey] = value }
    if let value = status { dictionary[kStaffresponseStatusKey] = value }
    if let value = staffresult { dictionary[kStaffresponseStaffresultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
