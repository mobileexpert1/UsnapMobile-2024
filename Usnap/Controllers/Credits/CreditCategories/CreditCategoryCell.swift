//  CreditCategoryCell.swift

import UIKit

class CreditCategoryCell: UITableViewCell {
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
