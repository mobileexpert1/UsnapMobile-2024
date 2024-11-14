/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class SubCategories {
    public var id : String?
    public var subCategoryName : String?
    public var description : String?
    public var credit : String?
    public var quantity : String?
    public var discount : String?
    public var categoryId : String?
    public var created_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let subservices_list = Subservices.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Subservices Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [SubCategories]
    {
        var models:[SubCategories] = []
        for item in array
        {
            models.append(SubCategories(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let subservices = Subservices(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Subservices Instance.
*/
    required public init?(dictionary: NSDictionary) {

        id = dictionary["id"] as? String
        subCategoryName = dictionary["subCategoryName"] as? String
        description = dictionary["description"] as? String
        credit = dictionary["credit"] as? String
        quantity = dictionary["quantity"] as? String
        discount = dictionary["discount"] as? String
        categoryId = dictionary["categoryId"] as? String
        created_at = dictionary["created_at"] as? String
    }

        
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.subCategoryName, forKey: "subCategoryName")
        dictionary.setValue(self.description, forKey: "description")
        dictionary.setValue(self.credit, forKey: "credit")
        dictionary.setValue(self.quantity, forKey: "quantity")
        dictionary.setValue(self.discount, forKey: "discount")
        dictionary.setValue(self.categoryId, forKey: "categoryId")
        dictionary.setValue(self.created_at, forKey: "created_at")

        return dictionary
    }

}
