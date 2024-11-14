//
//  BaseAPI.swift
//  FreshMeatMarket
//
//  Created by Bikramjit Singh on 19/04/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: Common Keys
let kBaseMessageKey: String = "message"
let kBaseStatusKey: String = "status"
let kBaseDataKey: String = "data"

public class BaseAPIModel {
    
    // MARK: Properties
    public var status: Bool = false
    public var data: JSON?
    public var message: String?
    
    // MARK: SwiftyJSON Initalizers
    /**
     Initates the instance based on the object
     - parameter object: The object of either Dictionary or Array kind that was passed.
     - returns: An initalized instance of the class.
     */
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /**
     Initates the instance based on the JSON that was passed.
     - parameter json: JSON object from SwiftyJSON.
     - returns: An initalized instance of the class.
     */
    public init(json: JSON) {
        status = json[kBaseStatusKey].boolValue
        data = json[kBaseDataKey]
        message = json[kBaseMessageKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kBaseStatusKey] = status
        if let value = message { dictionary[kBaseMessageKey] = value }
        return dictionary
    }
    
}


