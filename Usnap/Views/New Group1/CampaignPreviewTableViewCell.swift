//
//  CampaignPreviewTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 06/03/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class CampaignPreviewTableViewCell: UITableViewCell {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var commentSendButton: UIButton!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var topImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.addBorder(UIColor.lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
