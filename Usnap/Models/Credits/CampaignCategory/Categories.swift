/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Categories {
	public var id : String?
	public var category_name : String?
	public var category_price : String?
	public var created_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let categories_list = Categories.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Categories Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Categories]
    {
        var models:[Categories] = []
        for item in array
        {
            models.append(Categories(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let categories = Categories(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Categories Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		category_name = dictionary["category_name"] as? String
		category_price = dictionary["category_price"] as? String
		created_at = dictionary["created_at"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.category_name, forKey: "category_name")
		dictionary.setValue(self.category_price, forKey: "category_price")
		dictionary.setValue(self.created_at, forKey: "created_at")

		return dictionary
	}

}