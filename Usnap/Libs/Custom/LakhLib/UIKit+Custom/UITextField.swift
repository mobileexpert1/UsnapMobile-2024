//
//  UITextField.swift
//
//  Created by Bikramjit Singh on 02/08/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum CardType: String {
        case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
        
        static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
        
        var regex : String {
            switch self {
            case .Amex:
                return "^3[47][0-9]{5,}$"
            case .Visa:
                return "^4[0-9]{6,}([0-9]{3})?$"
            case .MasterCard:
                return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
            case .Diners:
                return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
            case .Discover:
                return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
            case .JCB:
                return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
            case .UnionPay:
                return "^(62|88)[0-9]{5,}$"
            case .Hipercard:
                return "^(606282|3841)[0-9]{5,}$"
            case .Elo:
                return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
            default:
                return ""
            }
        }
    }
    
    func addLeftImage(_ leftImage: UIImage) {
        leftViewMode = .always
        var size: CGSize = leftImage.size
        size.width += 15
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height) )
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        iconView.image = leftImage
        iconView.contentMode = .scaleAspectFit
        iconView.contentMode = .center
        outerView.addSubview(iconView)
        leftView = outerView
    }

    func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 1
    }
    
    func addBottomLabel(_ color: UIColor) {
        let lbl1 = UILabel()
        lbl1.backgroundColor = color
        addSubview(lbl1)
        addVisualConstraints(["H:|[label]|", "V:[label(1)]|"], subviews: ["label": lbl1])
    }
    
    func changePlaceholderColor(_ color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder!,
                                                   attributes:[NSAttributedStringKey.foregroundColor: color])
    }

    //MARK: Email validation variable
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    //MARK: Email validation variable
    var isOnlyPhone: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(text!).isSubset(of: nums)
    }
    
    
    func validateCreditCardFormat()-> (type: CardType, valid: Bool) {
        // Get only numbers from the input string
        let input = self.text!
        
        let numberOnly = input.replacingOccurrences(of: " ", with: "+", options: .regularExpression)

       // let numberOnly = input.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, valid)
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else { return false }
            let odd  = tuple.offset % 2 == 1
            
            
            
//            let odd = tuple.index % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    
}


