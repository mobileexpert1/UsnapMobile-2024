//
//  StaffPermissionsModel.swift
//  Usnap
//
//  Created by CSPC141 on 27/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class StaffPermissionsModel {

    //MARK: Properties
    
   static var invoicePaidByPermission =  String()
   static var viewAllMediaPermission = String()
   static var viewAllInvoicesPermission = String()
   static var staffMemberID = String()
    
    class func saveUserPermissions(invoicePaidBy: String, viewAllMedia: String, viewAllInvoices: String, staffid: String) {
        invoicePaidByPermission = invoicePaidBy
        viewAllMediaPermission = viewAllMedia
        viewAllInvoicesPermission = viewAllInvoices
        staffMemberID = staffid
    }
    
    class func returnUserPermissions() -> Array<String> {
        var tempArray = Array<String>()
        tempArray = [invoicePaidByPermission, viewAllMediaPermission, viewAllInvoicesPermission, staffMemberID]
        return tempArray
    }
    
}

