//
//  StaffMemberTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 04/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class StaffMemberTableViewCell: UITableViewCell {

    @IBOutlet var staffMemberName: UILabel!
    @IBOutlet var staffMemberEmail: UILabel!
    @IBOutlet var staffMemberPhone: UILabel!
    @IBOutlet var arrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
