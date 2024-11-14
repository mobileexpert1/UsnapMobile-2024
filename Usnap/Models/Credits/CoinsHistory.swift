/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class CoinsHistory {
	public var id : String?
	public var userId : String?
	public var coins : String?
	public var paymentAt : String?
	public var body : String?
	public var type : String?
	public var paymentType : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let coinsHistory_list = CoinsHistory.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CoinsHistory Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CoinsHistory]
    {
        var models:[CoinsHistory] = []
        for item in array
        {
            models.append(CoinsHistory(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let coinsHistory = CoinsHistory(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CoinsHistory Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		userId = dictionary["userId"] as? String
		coins = dictionary["coins"] as? String
		paymentAt = dictionary["paymentAt"] as? String
		body = dictionary["body"] as? String
		type = dictionary["type"] as? String
		paymentType = dictionary["paymentType"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.userId, forKey: "userId")
		dictionary.setValue(self.coins, forKey: "coins")
		dictionary.setValue(self.paymentAt, forKey: "paymentAt")
		dictionary.setValue(self.body, forKey: "body")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.paymentType, forKey: "paymentType")

		return dictionary
	}

}