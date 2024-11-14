//
//  AddAdditionalServicesTableCell.swift
//  Usnap
//
//  Created by Mobile on 03/07/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import UIKit

protocol TableCellDelegate {
    func updateCell(_ model:Any,_ strType:String,_ cell:UITableViewCell,_ item:Int)
}

var modelUdpate = [SubCategorySelectedModel()]

class AddAdditionalServicesTableCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tickUntickSelectCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var minusQtyImg: UIImageView!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var plusQtyImg: UIImageView!
    
    var delegate:TableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateModel(_ model: Any, _ IndexPath: Int,alreadySelectedCategory: [SubCategorySelectedModel]) {
        let modelData = model as! SubCategories
                
        lblCategory.text = "\(modelData.subCategoryName ?? "") (\(modelData.credit ?? ""))"
        
        tickUntickSelectCategory.image = UIImage(named: "UnTickIconAS")
        
        qtyLbl.text = modelData.quantity

       if let modelIndex = alreadySelectedCategory.firstIndex(where: { $0.subcategoryId == modelData.id }) {
            
            self.tickUntickSelectCategory.image = UIImage(named: "TickIconAS")
            self.qtyLbl.text = alreadySelectedCategory[modelIndex].selectedQuantity
            
           let modelUpdatew = SubCategorySelectedModel(subcategoryId:alreadySelectedCategory[modelIndex].subcategoryId, selectedQuantity: alreadySelectedCategory[modelIndex].selectedQuantity,selectedQuantityName: alreadySelectedCategory[modelIndex].selectedQuantityName,selectedDescption:modelData.description)
            
            print(modelUdpate)
            if modelUdpate.firstIndex(where: { $0.subcategoryId == modelUpdatew.subcategoryId }) == nil {
                modelUdpate.append(modelUpdatew)
            }
       }else{
           tickUntickSelectCategory.image = UIImage(named: "UnTickIconAS")
       }
        
        tickUntickSelectCategory.actionBlock {
            print(modelUdpate)
            if self.tickUntickSelectCategory.image == UIImage(named: "UnTickIconAS") {
                if modelUdpate.firstIndex(where: { $0.subcategoryId == modelData.id }) == nil {
                    let modelUpdatew = SubCategorySelectedModel(subcategoryId:modelData.id, selectedQuantity: modelData.quantity,selectedQuantityName: "\((modelData.subCategoryName ?? "",selectedDescption:modelData.description))")
                    modelUdpate.append(modelUpdatew)
                    self.tickUntickSelectCategory.image = UIImage(named: "TickIconAS")
                    self.delegate?.updateCell(modelUdpate,"Add Category", self, IndexPath)
                }
            } else {
                if let selectedRowIndex = modelUdpate.firstIndex(where: { $0.subcategoryId == modelData.id }) {
                    modelUdpate.remove(at: selectedRowIndex)
                    self.tickUntickSelectCategory.image = UIImage(named: "UnTickIconAS")
                    self.delegate?.updateCell(modelUdpate,"Remove Category", self, IndexPath)
                }
            }
        }
        
        infoIcon.actionBlock {
            self.delegate?.updateCell(modelUdpate,"Pressed Info Button", self, IndexPath)
        }
        
        minusQtyImg.actionBlock {
            if let selectedRowIndex = modelUdpate.firstIndex(where: { $0.subcategoryId == modelData.id }) {
                self.qtyLbl.text = self.calculateSelectedQty(currenQtyCell: Int(modelUdpate[selectedRowIndex].selectedQuantity ?? "0") ?? 0, isAddQty: false)
                modelUdpate[selectedRowIndex].selectedQuantity = self.qtyLbl.text
                self.delegate?.updateCell(modelUdpate,"Pressed Minus Button", self, IndexPath)
            }
        }
        
        plusQtyImg.actionBlock {
            if let selectedRowIndex = modelUdpate.firstIndex(where: { $0.subcategoryId == modelData.id }) {
                self.qtyLbl.text = self.calculateSelectedQty(currenQtyCell: Int(modelUdpate[selectedRowIndex].selectedQuantity ?? "0") ?? 0, isAddQty: true)
                modelUdpate[selectedRowIndex].selectedQuantity = self.qtyLbl.text
                self.delegate?.updateCell(modelUdpate,"Pressed Plus Button", self, IndexPath)
            }else if modelUdpate.firstIndex(where: { $0.subcategoryId == modelData.id }) == nil {
                self.qtyLbl.text = "1"
                let modelUpdatew = SubCategorySelectedModel(subcategoryId:modelData.id, selectedQuantity: self.qtyLbl.text!,selectedQuantityName: "\((modelData.subCategoryName ?? "",selectedDescption:modelData.description))")
                modelUdpate.append(modelUpdatew)
                self.delegate?.updateCell(modelUdpate,"Pressed Plus Button", self, IndexPath)
            }
        }
    }
    
    func calculateSelectedQty(currenQtyCell:Int,isAddQty:Bool) -> String {
        var currenQty = currenQtyCell
        if isAddQty {
            currenQty += 1
            if currenQty >= 10 {
                currenQty = 10
            }
        }else{
            currenQty -= 1
            if currenQty < 0 {
                currenQty = 0
            }
        }
        return "\(currenQty)"
    }
}
