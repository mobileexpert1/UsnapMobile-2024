//
//  AdditionalServicesTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 03/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class AdditionalServicesTableViewCell: UITableViewCell {

//    @IBOutlet var payableAmount: UILabel!
//    @IBOutlet var totalTime: UILabel!
//    @IBOutlet var minutePrice: UILabel!
//    @IBOutlet var serviceName: UILabel!
    
    
    @IBOutlet var campTitle: UILabel!
    
    @IBOutlet var totalPrice: UILabel!
    
    @IBOutlet var serviceTitle: UILabel!
    
    @IBOutlet var serviceComment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
