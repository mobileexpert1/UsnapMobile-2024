//
//  SelectedDateStore.swift
//  Usnap
//
//  Created by CSPC141 on 21/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

//MARK:- GETTER SETTER METHOD

// store the selected date from datepicked

var datePicked : String? {
    set{
        UserDefaults.standard.setValue(newValue, forKey: "datePicked")
        UserDefaults.standard.synchronize()
    }get {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: "datePicked") as? String ?? nil
    }
}

func setRequriedFormat(_ currentFormat: String) -> String {
    
    return ""
}
