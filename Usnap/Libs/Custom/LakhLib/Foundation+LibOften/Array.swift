//
//  Array.swift
//
//  Created by Bikramjit Singh on 24/04/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    var isEmpty: Bool {
        return self.count == 0
    }
        func removing(_ obj: Element) -> [Element] {
            return filter { $0 != obj }
        }
    
    
}


