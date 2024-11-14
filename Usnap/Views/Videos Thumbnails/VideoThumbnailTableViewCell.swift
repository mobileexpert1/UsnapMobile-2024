//
//  VideoThumbnailTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 03/04/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit

class VideoThumbnailTableViewCell: UITableViewCell {

    @IBOutlet var playButton: UIButton!
    @IBOutlet var thumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
