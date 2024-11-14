//  CreditCategoryVC.swift

import UIKit
import SVProgressHUD

class CreditCategoryVC: AbstractControl {

    @IBOutlet weak var topBarView: TopBarView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var campaignCategories = [Categories]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
                let closeButtonImage = UIImage(named: "BackIcon")
                        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(CreditCategoryVC.barButtonDidTap(_:)))
        
        
        SVProgressHUD.show()
        setTableProperties()
        setTopBarViewProperties()
        fetchAvailableCampaignCategories()
    }
    
    private func setTopBarViewProperties() {
        topBarView.leftButton1.isUserInteractionEnabled = false
        topBarView.leftButton2.isUserInteractionEnabled = false
    }
    
    private func setTableProperties() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func centeredNavBarImageView() {
        if let navcontroller = navigationController {
            let image = #imageLiteral(resourceName: "TopBarLogo")
            let imageView = UIImageView(image: image)
            
            let bannerWidth = navcontroller.navigationItem.accessibilityFrame.size.width
            let bannerHeight = navcontroller.navigationBar.frame.size.height
            let bannerX = bannerWidth / 2 - image.size.width / 2
            let bannerY = bannerHeight / 2 - image.size.height / 2
            
            imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
            imageView.contentMode = .scaleAspectFit
            
            self.navigationItem.titleView = imageView
        }
        
    }
    
    
}

// MARK: - API
extension CreditCategoryVC {
    func fetchAvailableCampaignCategories() {
        CreditApiStore.sharedInstance.getCampaignCategories { response in
            self.campaignCategories = response?.categoryResponse?.categoryData?.categories ?? []
            SVProgressHUD.dismiss()
            self.categoryTableView.reloadData()
        }
    }
}

// MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension CreditCategoryVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCategoryCell", for: indexPath) as! CreditCategoryCell
        cell.categoryName.text = self.campaignCategories[indexPath.row].category_name
        cell.categoryPrice.text = self.campaignCategories[indexPath.row].category_price
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var Campaign = SubCategories(dictionary: ["categoryId":self.campaignCategories[indexPath.row].id ?? ""])
        navigationController?.pushViewController(CreditSubCategories.control(Campaign!), animated: true)
        
        
//        campaignCategoryDict["categoryName"] = self.campaignCategories[indexPath.row].category_name
//        campaignCategoryDict["categoryId"] = self.campaignCategories[indexPath.row].id
//
//        if let stringToFloat = Float(self.campaignCategories[indexPath.row].category_price!) {
//            let price = Int(stringToFloat)
//            print(price)
//            campaignCategoryDict["categoryPrice"] = price
//            print(campaignCategoryDict["categoryPrice"])
//        }
//
//        self.popOrDismissViewController(true)
    }
}
