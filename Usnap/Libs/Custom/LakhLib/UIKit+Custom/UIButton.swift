//
//  UIButton.swift
//
//  Created by Bikramjit Singh on 01/08/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension UIButton {
    
    var image: UIImage {
        get {
            return image(for: .normal)!
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    func addBorder(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 1
    }
    
    func addBottomLabel(_ color: UIColor) {
        let lbl1 = UILabel()
        lbl1.backgroundColor = color
        addSubview(lbl1)
        addVisualConstraints(["H:|[label]|", "V:[label(1)]|"], subviews: ["label": lbl1])
    }
}


