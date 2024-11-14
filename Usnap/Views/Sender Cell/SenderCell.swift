//
//  SenderCell.swift
//  Usnap
//
//  Created by CSPC141 on 17/04/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    @IBOutlet var senderImage: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        changeImage("chat_bubble_sent")
    }

    func changeImage(_ name: String) {
        guard let image = UIImage(named: name) else { return }
        senderImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        senderImage.tintColor = solidPinkBorderColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
