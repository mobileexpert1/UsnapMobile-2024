//
//  MembershipTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 15/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class MembershipTableViewCell: UITableViewCell {

    @IBOutlet var bgView: UIView!
    @IBOutlet var price: UILabel!
    @IBOutlet var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
