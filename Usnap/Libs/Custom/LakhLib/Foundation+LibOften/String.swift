//
//  String.swift
//  Dropneed
//
//  Created by Bikramjit Singh on 19/04/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension String {
    
    func widthOfString() -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: UIFont(name: "CenturyGothic", size: 12.0)]
        let size = self.size(withAttributes: fontAttributes as [NSAttributedStringKey : Any])
        return size.width + 50.0
    }
    
    var local: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isEmpty: Bool {
        return characters.count == 0 && trimmingCharacters(in: .whitespaces).characters.count == 0
    }
    
    var float: Float {
        return Float(self)!
    }
    
    var int: Int {
        return Int(self)!
    }
    
    var length: Int {
        return characters.count
    }
    
    var htmlToString: String {
        let string = replacingOccurrences(of: "</div>", with: "\n")
        let linesString = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        var linesArray: [String] = []
        linesString.enumerateLines { line, _ in linesArray.append(line) }
        return linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
    }

    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    func isEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
        return NSPredicate(format:"SELF MATCHES %@",
                           emailRegEx).evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func isNumber() -> Bool {
        let emailRegEx = "^[0-9+]"
        return NSPredicate(format:"SELF MATCHES %@",
                           emailRegEx).evaluate(with: self)
    }
    
    func makeOppositeString(_ currentValue : String) -> String {
        if currentValue == "0" {
            return "1"
        }
        return "0"
    }

    func removeTimeFromString(_ currentValue : String) -> String {
        let delimiter = " "
        let newstr = currentValue
        var token = newstr.components(separatedBy: delimiter)
        return token[0]
    }
    
    func seprateRoleStrings(_ currentValue : String) -> NSArray {
        print(currentValue)
        let delimiter = ","
        let newstr = currentValue
        let token = newstr.components(separatedBy: delimiter)
         print(token)
        return token as NSArray
    }
  
    func seprateStringWithCharacter(_ currentValue : String, _ specialChar : String) -> NSArray {
        let delimiter = specialChar
        let newstr = currentValue
        let token = newstr.components(separatedBy: delimiter)
        return token as NSArray
    }
    
    func replaceString(_ currentValue : String, _ currentCharacter : String, _ newCharacter : String) -> String {
        return currentValue.replacingOccurrences(of: currentCharacter, with: newCharacter, options: .literal, range: nil)
    }
    
    func makeThumbnailString(_ currentValue : String) -> String {
        let delimiter = "."
        let newstr = currentValue
        var token = newstr.components(separatedBy: delimiter)
      
        let imageString = String(format: "%@%@%@", APIs.KVIDEOBASETHUMBNAILURL, token[0],".jpg")
        return imageString
    }
   
    func addPercentValue(_ currentValue : String) -> String {
        let finalString = currentValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return finalString!
    }
    
}

