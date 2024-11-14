//
//  subMenuListCustomCell.swift
//  Planet
//
//  Created by CSPC103 on 8/16/17.
//  Copyright © 2017 CSPC141. All rights reserved.
//

import UIKit

class subMenuListCustomCell: UITableViewCell {

    @IBOutlet var menuItemsLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
