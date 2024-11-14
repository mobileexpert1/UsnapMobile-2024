//
//  LearnTableViewCell.swift
//  Usnap
//
//  Created by CSPC141 on 05/06/18.
//  Copyright © 2018 Hakikat Singh. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class LearnTableViewCell: UITableViewCell {

   
    @IBOutlet var videoPlayer: YTPlayerView!
    @IBOutlet var playVideo: UIButton!
    @IBOutlet var videoThumbnail: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
