//
//  DropDownHandler.swift
//  Usnap
//
//  Created by Mobile on 07/06/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class DropDownHandler: NSObject {

    // MARK: Shared Instance
    static let shared = DropDownHandler()
    let buttonDropDown = DropDown()

    // MARK: Internal Properties
    var itemPickedBlock: ((Int, String) -> Void)?
    var cancelActionBlock : (() -> Void)?

    func showDropDownWithItems(_ sender: UIView, _ items: [String]) {
        // dropDown
        buttonDropDown.anchorView = sender
        buttonDropDown.dataSource = items
        buttonDropDown.selectionAction = { (index: Int, item: String) in
            self.itemPickedBlock?(index, item)
        }
        buttonDropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttonDropDown.textColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1)
        buttonDropDown.animationduration = 0.5
        buttonDropDown.selectionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonDropDown.selectedTextColor = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1)
        buttonDropDown.bottomOffset = CGPoint(x: 0, y:((buttonDropDown.anchorView?.plainView.bounds.height)! + 5))
        buttonDropDown.show()
        buttonDropDown.cancelAction = { [unowned self] in
            self.cancelActionBlock?()
        }
        buttonDropDown.cornerRadius = 5.0
        
        //buttonDropDown.borderColorTbl = UIColor.gray.cgColor
        //buttonDropDown.borderWidthTbl = 1.0
    }
}
