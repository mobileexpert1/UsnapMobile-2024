//
//  ShopLensTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 09/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class ShopLensTableViewCell: UITableViewCell {

    @IBOutlet var postiveButton: UIButton!
    @IBOutlet var qantityLabel: UILabel!
    @IBOutlet var lensPrice: UILabel!
    @IBOutlet var lensName: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var minusButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.qantityLabel.addBorder(pinkBorderColor)
        self.postiveButton.addBorder(pinkBorderColor)
        self.minusButton.addBorder(pinkBorderColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
