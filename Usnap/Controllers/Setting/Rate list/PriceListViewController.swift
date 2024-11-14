//
//  PriceListViewController.swift
//  Usnap
//
//  Created by CSPC141 on 17/05/19.
//  Copyright © 2019 Hakikat Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class PriceListViewController: AbstractControl {
    
    @IBOutlet weak var pricingTbVw: UITableView!
    @IBOutlet var urgentVideoPrice: UILabel!
    @IBOutlet var videoPrice: UILabel!
    @IBOutlet var additionalServicePrice: UILabel!
    @IBOutlet var photoPrice: UILabel!
    @IBOutlet var urgentPhotoPrice: UILabel!
    @IBOutlet weak var topBarViews: TopBarView!
    
    var priceData = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        
        let closeButtonImage = UIImage(named: "BackIcon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(PriceListViewController.barButtonDidTap(_:)))
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPricingInfo()
        pricingTableViewData()
        getPricingAPi()
        
    }
    
    func getPricingInfo() {
        UserStore.sharedInstance.getUserPricings(UserStore.sharedInstance.userInfo, completion: { (resposne) in
            print(resposne as Any)
            let responseData = resposne?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                let resultData = responseData["result"] as! NSDictionary
                print(resultData)
                self.photoPrice.text = (resultData["price_nonmember_per_photo_retouch"] as! String)
                self.urgentPhotoPrice.text = (resultData["price_nonmember_urgent_per_photo_retouch"] as! String)
                self.additionalServicePrice.text = (resultData["price_nonmember_additional_service_per_min"] as! String)
                self.videoPrice.text = (resultData["price_nonmember_per_video_retouch"] as! String)
                self.urgentVideoPrice.text = (resultData["price_nonmember_urgent_per_video_retouch"] as! String)
            } else {
                SVProgressHUD.showError(withStatus:"Price not found. Please try again.")
            }
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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

extension PriceListViewController : UITableViewDataSource,UITableViewDelegate {
    
    func pricingTableViewData(){
        pricingTbVw.register(UINib(nibName: "PricingCell", bundle: nil), forCellReuseIdentifier: "PricingCell")
        pricingTbVw.dataSource = self
        pricingTbVw.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor =  .lightGray
        
        let lbl = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.width - 15, height: 40))
        let lbl2 = UILabel(frame: CGRect(x: pricingTbVw.frame.maxX - 120, y: 0, width: 100, height: 40))
        lbl.font = UIFont(name: "CenturyGothic-Bold", size: 13)
        lbl2.font = UIFont(name: "CenturyGothic-Bold", size: 13)
        lbl2.textAlignment = .right
        let categoryArray = priceData["category"] as? [[String:Any]]
        let categoryName = categoryArray?[section]["category_name"] as? String
        let categoryPrice = categoryArray?[section]["category_price"] as? String
        lbl.text = categoryName
        lbl2.text = categoryPrice
        view.addSubview(lbl)
        view.addSubview(lbl2)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let categoryArray = priceData["category"] as? NSArray
        print(categoryArray?.count ?? 0)
        return categoryArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let categoryArray = priceData["category"] as? NSArray
        print("categoryArray",categoryArray)
        let subCategorySection = categoryArray?[section] as? NSDictionary
        let subCategory = subCategorySection?["subCategory"] as? NSArray
        return subCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PricingCell") as! PricingCell
        let categoryArray = priceData["category"] as? NSArray
        let subCategorySection = categoryArray?[indexPath.section] as? NSDictionary
        let subCategory = subCategorySection?["subCategory"] as? NSArray
        let singeSubCategory = subCategory?[indexPath.row] as? NSDictionary
        cell.title_Lbl.text = singeSubCategory?["subCategoryName"] as? String
        cell.amount_Lbl.text = singeSubCategory?["credit"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func getPricingAPi(){
        guard let url = URL(string: "https://usnap.com.au/Api/CoinPurchase/pricelist") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a dictionary
                    print(json)
                    if let data = json["data"] as? [String:Any] {
                        print("data -=-=",data)
                        DispatchQueue.main.async {
                            self.priceData = data
                            self.pricingTbVw.reloadData()
                        }
                        
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
    }
}
//
//
//import Foundation
//
//// MARK: - PriceModel
//struct PriceModel: Codable {
//    let status: String
//    let data: DataClass
//    let message: String
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let category: [Category]
//}
//
//// MARK: - Category
//struct Category: Codable {
//    let id, categoryName, categoryPrice: String
//    let subCategory: [SubCategory]
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryName = "category_name"
//        case categoryPrice = "category_price"
//        case subCategory
//    }
//}
//
//// MARK: - SubCategory
//struct SubCategory: Codable {
//    let id, subCategoryName, credit: String
//}
