//
//  WebsizeCustomCell.swift
//  Usnap
//
//  Created by CSPC141 on 06/03/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class WebsizeCustomCell: UITableViewCell {
    @IBOutlet var webSizeTextField: UITextField!
    @IBOutlet var crossButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
