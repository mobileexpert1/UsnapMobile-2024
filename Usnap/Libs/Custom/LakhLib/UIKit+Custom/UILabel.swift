//
//  UILabel.swift
//  SalamAudio
//
//  Created by Mobile on 06/10/17.
//  Copyright © 2017 CSSOFT. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 1
    }

}


