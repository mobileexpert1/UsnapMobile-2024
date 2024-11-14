//
//  StaffInvoicesTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class StaffInvoicesTableViewCell: UITableViewCell {
    @IBOutlet var checkBoxButton: UIButton!
    
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var date: UILabel!
    @IBOutlet var totalAmount: UILabel!
    @IBOutlet var campaignName: UILabel!
    @IBOutlet var invoiceNumber: UILabel!
    @IBOutlet var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
