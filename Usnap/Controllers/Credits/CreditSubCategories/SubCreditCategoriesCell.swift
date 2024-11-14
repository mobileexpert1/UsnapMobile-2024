//
//  SubCreditCategoriesCell.swift
//  Usnap
//
//  Created by Mobile on 07/06/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import UIKit

class SubCreditCategoriesCell: UITableViewCell {

    @IBOutlet weak var lblSubCategoryName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var vWQtyDropDown: UIView!
    @IBOutlet weak var lblDropDownTxt: UILabel!
    @IBOutlet weak var vwSelectionCategory: UIView!
    @IBOutlet weak var imgViewTickUnTIck: UIImageView!
    @IBOutlet weak var lblQtyHeadingPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
