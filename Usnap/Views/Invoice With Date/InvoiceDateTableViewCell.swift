//
//  InvoiceDateTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class InvoiceDateTableViewCell: UITableViewCell {

    @IBOutlet var checkBoxButton: UIButton!
    @IBOutlet var pendingPayNowButton: UIButton!
    @IBOutlet var pendingResendButton: UIButton!
    @IBOutlet var pendingShareButton: UIButton!
    @IBOutlet var pendingDownloadButton: UIButton!
    @IBOutlet var paidResendButton: UIButton!
    @IBOutlet var paidShareButton: UIButton!
    @IBOutlet var paidDownloadButton: UIButton!
    @IBOutlet var uploadedBy: UILabel!
    @IBOutlet var paymentDate: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var campaignTitle: UILabel!
    @IBOutlet var invoiceId: UILabel!
    @IBOutlet var pendingInvoices: UIView!
    @IBOutlet var paidBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
