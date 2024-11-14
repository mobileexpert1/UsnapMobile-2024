//
//  HomeTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 03/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var campaignDateLabel: UILabel!
    @IBOutlet var campaignTitle: UILabel!
    @IBOutlet var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
