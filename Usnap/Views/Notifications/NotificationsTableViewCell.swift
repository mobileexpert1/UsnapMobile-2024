//
//  NotificationsTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet var cellBg: UIView!
    @IBOutlet var notificationTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
