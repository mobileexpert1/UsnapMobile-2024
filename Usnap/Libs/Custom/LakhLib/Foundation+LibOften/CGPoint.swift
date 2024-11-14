//
//  CGPoint.swift
//
//  Created by Bikramjit Singh on 20/07/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(_ b: CGPoint) -> CGFloat {
        let xDist = x - b.x
        let yDist = y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}


