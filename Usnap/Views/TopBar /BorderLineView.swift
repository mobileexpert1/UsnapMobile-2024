//
//  BorderLineView.swift
//  FreshMeatMarket
//
//  Created by Bikramjit Singh on 13/04/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

@IBDesignable
class BorderLineView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func initViews() {
        backgroundColor = UIColor.black
    }
    
    // MARK: - Layout methods
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        _ = addConstraintForHeight(0.5)
    }
    
}


