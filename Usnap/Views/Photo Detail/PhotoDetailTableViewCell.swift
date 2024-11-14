//
//  PhotoDetailTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 15/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class PhotoDetailTableViewCell: UITableViewCell {

    @IBOutlet var thumbNailImageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
