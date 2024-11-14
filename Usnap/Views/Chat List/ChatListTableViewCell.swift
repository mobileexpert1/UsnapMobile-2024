//
//  ChatListTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet var nextIconImg: UIImageView!
    @IBOutlet var membershipSwitch: UISwitch!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
