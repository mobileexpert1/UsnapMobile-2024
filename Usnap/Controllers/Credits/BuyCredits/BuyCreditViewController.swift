//  BuyCreditViewController.swift

import UIKit
import StoreKit
import SVProgressHUD

class BuyCreditViewController: AbstractControl {
    
    @IBOutlet weak var availablePlansTableView: UITableView!
    @IBOutlet weak var topBarView: TopBarView!
    
    var productsArray = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        let closeButtonImage = UIImage(named: "BackIcon")
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(BuyCreditViewController.barButtonDidTap(_:)))
        SVProgressHUD.show()
        setTopBarViewProperties()
        fetchAvailableCreditPlans()
    }
    
    private func setTopBarViewProperties() {
        topBarView.leftButton1.isUserInteractionEnabled = false
        topBarView.leftButton2.isUserInteractionEnabled = false
    }
    
    private func setTableProperties() {
        availablePlansTableView.delegate = self
        availablePlansTableView.dataSource = self
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

// MARK: - FETCH STORE PRODUCTS
extension BuyCreditViewController {
    func fetchAvailableCreditPlans() {
        PurchaseStore.shared.setProductIds(ids: [
            "com.Usnapapp.credit3", "com.Usnapapp.credit7", "com.Usnapapp.credit10", "com.Usnapapp.credit13", "com.Usnapapp.credit26", "com.Usnapapp.credit32",
            "com.Usnapapp.credit42", "com.Usnapapp.credit54", "com.Usnapapp.credit64", "com.Usnapapp.credit95", "com.Usnapapp.credit128", "com.Usnapapp.credit254",
            "com.Usnapapp.credit318", "com.Usnapapp.credit445", "com.Usnapapp.credit572", "com.Usnapapp.credit795", "com.Usnapapp.credit1018", "com.Usnapapp.credit1274",
        ])
        DispatchQueue.main.async {
            PurchaseStore.shared.fetchAvailableProducts { (products) in
                self.productsArray = products
                
                self.productsArray = self.productsArray.sorted(by: { Int($0.localizedTitle.replacingOccurrences(of: " Credits", with: ""))! < Int($1.localizedTitle.replacingOccurrences(of: " Credits", with: ""))! })
            }
            self.setTableProperties()
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - TABLEVIEW DELEGATE AND DATASOURCE
extension BuyCreditViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyCreditCell", for: indexPath) as! BuyCreditCell
        
        cell.productName.text = productsArray[indexPath.row].localizedTitle
        cell.productDescription.text = productsArray[indexPath.row].localizedDescription
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .currencyCode) as? String {
            cell.productPrice.text = countryCode + " " + "\(productsArray[indexPath.row].price)"
        } else {
            cell.productPrice.text = "\(productsArray[indexPath.row].price)"
        }
        cell.selectionStyle = .none
        
        cell.buyButton.actionBlock {
            SVProgressHUD.show()
            self.handleProductPurchase(indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func handleProductPurchase(_ index : Int) {
        PurchaseStore.shared.purchase(product: self.productsArray[index]) { alertType, purchasedProduct, paymentStatus in
            print("alertType------------->>>>>>>>>> ", alertType)
            if alertType == PurchaseStoreAlertType.purchased {
                self.updatePurchaseToServer(index)
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updatePurchaseToServer(_ index : Int) {
        let creditStr = productsArray[index].localizedTitle.replacingOccurrences(of: " Credits", with: "")
        let credits = CGFloat(integerLiteral: Int(creditStr)!)
        CreditApiStore.sharedInstance.purchaseCoin(UserStore.sharedInstance.userInfo, "1", credits, "Apple") { response in
            SVProgressHUD.dismiss()
            self.popOrDismissViewController(true)
        }
    }
}
