//
//  CreditSubCategories.swift
//  Usnap
//
//  Created by Mobile on 07/06/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

struct SubCategorySelectedModel :Codable {
    var subcategoryId:String?
    var selectedQuantity:String?
    var selectedQuantityName:String? = ""
    var selectedDescption:String? = ""
}

protocol UpdateSelectedCategoryModelDelegate {
    func updateSelectedCategorResponse(inpuData:[SubCategorySelectedModel])
}

class CreditSubCategories: AbstractControl {
    
    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var subCategoryTableView: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    
    var selectedCategory = ""
    var selectedImageId = ""

    var modelUdpate = [SubCategorySelectedModel()]
    var campaignSubCategories = [SubCategories]()
    
    var selectedCategoryQuantity = ""
    var selectedCategoryAddOn = ""
    
    var delegate: UpdateSelectedCategoryModelDelegate?
    
    class func control(_ selectedCampaign : SubCategories) -> CreditSubCategories {
        let control = self.control as! CreditSubCategories
        control.selectedCategory = selectedCampaign.categoryId ?? "0"
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        setTableProperties()
        setTopBarViewProperties()
        fetchAvailableCampaignCategories()
        setupAllAction()
        if modelUdpate.count == 0 {
            modelUdpate.removeAll()
        }
    }
    
    private func setTopBarViewProperties() {
        topBarView.leftButton1.isUserInteractionEnabled = false
        topBarView.leftButton2.isUserInteractionEnabled = false
    }
    
    private func setTableProperties() {
        subCategoryTableView.delegate = self
        subCategoryTableView.dataSource = self
    }
    
    private func setupAllAction() {
        btnDone.layer.cornerRadius = 10
        btnDone.actionBlock {
            self.updateSelectedCategorResponse()
        }
    }
}

// MARK: - API
extension CreditSubCategories {
    func fetchAvailableCampaignCategories() {
        CreditApiStore.sharedInstance.getCampaignSubCategories(selectedCategory: selectedCategory) { response in
            self.campaignSubCategories = response?.subCategoryResponse?.subCategoryData?.subservices ?? []
            SVProgressHUD.dismiss()
            self.subCategoryTableView.reloadData()
        }
    }
}

//// MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension CreditSubCategories:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignSubCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCreditCategoriesCell", for: indexPath) as! SubCreditCategoriesCell
        cell.lblSubCategoryName.text = self.campaignSubCategories[indexPath.row].subCategoryName
        cell.lblAmount.text = self.campaignSubCategories[indexPath.row].credit
        cell.imgViewTickUnTIck.image = UIImage(named: "UnTick")
        cell.lblDropDownTxt.text = self.campaignSubCategories[indexPath.row].quantity
        
        if let modelIndex = self.modelUdpate.firstIndex(where: { $0.subcategoryId == self.campaignSubCategories[indexPath.row].id }) {
            cell.imgViewTickUnTIck.image = UIImage(named: "Tick")
            cell.lblDropDownTxt.text = modelUdpate[modelIndex].selectedQuantity
        }
        
        cell.vwSelectionCategory.actionBlock {
            if cell.imgViewTickUnTIck.image == UIImage(named: "UnTick") {
                if self.modelUdpate.firstIndex(where: { $0.subcategoryId == self.campaignSubCategories[indexPath.row].id }) == nil {
                    let modelUpdatew = SubCategorySelectedModel(subcategoryId:self.campaignSubCategories[indexPath.row].id, selectedQuantity: self.campaignSubCategories[indexPath.row].quantity,selectedQuantityName: "  \(self.campaignSubCategories[indexPath.row].subCategoryName ?? "")  ", selectedDescption:self.campaignSubCategories[indexPath.row].description)
                    self.modelUdpate.append(modelUpdatew)
                    cell.imgViewTickUnTIck.image = UIImage(named: "Tick")
                }
            } else {
                if let selectedRowIndex = self.modelUdpate.firstIndex(where: { $0.subcategoryId == self.campaignSubCategories[indexPath.row].id }) {
                    self.modelUdpate.remove(at: selectedRowIndex)
                    cell.imgViewTickUnTIck.image = UIImage(named: "UnTick")
                }
            }
        }
        
        cell.vWQtyDropDown.actionBlock {
            DropDownHandler.shared.showDropDownWithItems(cell.vWQtyDropDown, ["1","2","3","4","5","6","7","8","9","10"])
            DropDownHandler.shared.itemPickedBlock = { (index, item) in
                if let selectedRowIndex = self.modelUdpate.firstIndex(where: { $0.subcategoryId == self.campaignSubCategories[indexPath.row].id }) {
                    self.modelUdpate[selectedRowIndex].selectedQuantity = item
                    cell.lblDropDownTxt.text = item
                }
            }
        }
        return cell
    }
    
    func updateSelectedCategorResponse() {
        print("inpuData = ",modelUdpate)
        
        var selectedyQuantity = [""]
        var selectedCategoryAddOnServices = [""]
        
        selectedyQuantity.removeAll()
        selectedCategoryAddOnServices.removeAll()
        
//        if modelUdpate.count == 0 {
//            SVProgressHUD.showError(withStatus: "Please Select Services")
//            return;
//        }
        
        for i in 0..<modelUdpate.count {
            selectedyQuantity.append(modelUdpate[i].selectedQuantity ?? "")
            selectedCategoryAddOnServices.append(modelUdpate[i].subcategoryId ?? "")
        }
        
        selectedCategoryQuantity = selectedyQuantity.joined(separator: ",")
        selectedCategoryAddOn = selectedCategoryAddOnServices.joined(separator: ",")

        print(selectedCategoryQuantity,selectedCategoryAddOn)
        
        CreditApiStore.sharedInstance.sendCategoryAndSubCategoryApi(self.selectedImageId, self.selectedCategoryAddOn, self.selectedCategoryQuantity) { responseData in
            let response = responseData?["response"] as! NSDictionary
            if response["status"] as! String == "1" {
                self.delegate?.updateSelectedCategorResponse(inpuData: self.modelUdpate)
                self.popOrDismissViewController(true)
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
}
