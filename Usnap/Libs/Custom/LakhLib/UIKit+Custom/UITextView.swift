//
//  UITextView.swift
//  Usnap
//
//  Created by CSPC141 on 04/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

extension UITextView {
    
     func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 1
    }
}
