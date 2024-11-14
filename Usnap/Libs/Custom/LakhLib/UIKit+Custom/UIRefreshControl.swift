//
//  UIRefreshControl.swift
//
//  Created by Bikramjit Singh on 31/03/17.
//  Copyright © 2017 Bikramjit. All rights reserved.
//

import UIKit

extension UIRefreshControl {

    func endRefreshingIfNeeded() {
        if isRefreshing {
            endRefreshing()
        }
    }
}


