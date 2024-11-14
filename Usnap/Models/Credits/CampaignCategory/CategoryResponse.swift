/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class CategoryResponse {
	public var categoryStatus : String?
	public var categoryData : CategoryData?
	public var categoryMessage : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let categoryResponse_list = CategoryResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CategoryResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CategoryResponse]
    {
        var models:[CategoryResponse] = []
        for item in array
        {
            models.append(CategoryResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let categoryResponse = CategoryResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CategoryResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

		categoryStatus = dictionary["status"] as? String
		if (dictionary["data"] != nil) { categoryData = CategoryData(dictionary: dictionary["data"] as! NSDictionary) }
		categoryMessage = dictionary["message"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.categoryStatus, forKey: "status")
		dictionary.setValue(self.categoryData?.dictionaryRepresentation(), forKey: "data")
		dictionary.setValue(self.categoryMessage, forKey: "message")

		return dictionary
	}

}
