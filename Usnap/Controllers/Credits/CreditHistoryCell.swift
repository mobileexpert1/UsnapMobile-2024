//  CreditHistoryCell.swift
//  Usnap

import UIKit

class CreditHistoryCell: UITableViewCell {

    @IBOutlet weak var platform: UILabel!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var paymentDate: UILabel!
    @IBOutlet weak var titleLabel: UILabel! // credit text or campaign name
    @IBOutlet weak var creditDebitImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
