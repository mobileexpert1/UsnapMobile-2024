//
//  LoginResponse.swift
//
//  Created by CSPC141 on 19/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoginResponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLoginResponseStatusKey: String = "status"
  private let kLoginResponseLoginResultKey: String = "result"
  private let kLoginResponseLoginMessageKey: String = "message"

  // MARK: Properties
  public var status: String?
  public var message: String?
  public var loginResult: [LoginResult]?

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
    status = json[kLoginResponseStatusKey].string
    message = json[kLoginResponseLoginMessageKey].string
    if let items = json[kLoginResponseLoginResultKey].array { loginResult = items.map { LoginResult(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kLoginResponseStatusKey] = value }
    if let value = message { dictionary[kLoginResponseLoginMessageKey] = value }
    if let value = loginResult { dictionary[kLoginResponseLoginResultKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
