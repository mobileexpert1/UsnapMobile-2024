//
//  Date.swift
//
//  Created by Bikramjit Singh on 10/05/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension Date {

    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////

/*
 String extension only for date methods
 */
extension String {
    
    func date(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
}


