//
//  BaseLogin.swift
//
//  Created by CSPC141 on 19/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseLogin {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseLoginLoginResponseKey: String = "response"

  // MARK: Properties
  public var loginResponse: LoginResponse?

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
    loginResponse = LoginResponse(json: json[kBaseLoginLoginResponseKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = loginResponse { dictionary[kBaseLoginLoginResponseKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}
