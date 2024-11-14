//  CreditsViewController.swift
//  Usnap

import UIKit
import SafariServices

@available(iOS 13.0, *)
class CreditsViewController: AbstractControl {

    @IBOutlet weak var availableCredits: UILabel!
    @IBOutlet weak var buyCreditBtn: UIView!
    @IBOutlet weak var creditSummaryTableView: UITableView!
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    
    var coinsHistoryResponse : CoinsHistoryBase?
    var coinsHistoryData = [CoinsHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centeredNavBarImageView()
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        setTopBarViewProperties()
        setActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchUserCreditsDetail()
        setTableProperties()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.creditSummaryTableView.reloadData()
            creditSummaryTableView.reloadData()
           // scrollToBottom()
        }
    }
   
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: self.coinsHistoryData.count-1, section: 0)
//          //  self.creditSummaryTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
    
    private func setTopBarViewProperties() {
        topBarView.leftButton1.isUserInteractionEnabled = false
        topBarView.leftButton2.isUserInteractionEnabled = false
    }
    
    private func setTableProperties() {
        creditSummaryTableView.delegate = self
        creditSummaryTableView.dataSource = self
    }

    private func setActions() {
        buyCreditBtn.actionBlock {
            self.navigationController?.pushViewController(BuyCreditViewController.control, animated: true)
//            UIAlertController.showAlert("Alert!", message: Constants.BUY_CREDITS, buttons: ["Cancel", "OK"], completion: { (alert, index) in
//                if index == 0 {
//                    self.navigationController?.pushViewController(BuyCreditViewController.control, animated: true)
//                } else {
//                    self.openUsnap()
//                }
//            })
        }
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
    
    
    
    private func openUsnap() {
        let url = URL(string: "https://usnap.com.au")!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
}

// MARK: - SFSafariViewControllerDelegate
@available(iOS 13.0, *)
extension CreditsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TABLEVIEW DELEGATE AND DATASOURCE
@available(iOS 13.0, *)
extension CreditsViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinsHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditHistoryCell", for: indexPath) as! CreditHistoryCell
        cell.selectionStyle = .none
        let historyCell = self.coinsHistoryResponse?.coinsHistoryResponse?.coinsHistoryData?.coinsHistory?[indexPath.row]
        
        cell.coins.text = historyCell?.coins ?? "0"
        
        if historyCell?.paymentType == "1" {
            cell.creditDebitImage.image = #imageLiteral(resourceName: "credit")
            cell.titleLabel.text = "Credit"
            cell.platform.text = historyCell?.body
        } else if historyCell?.paymentType == "2" {
            cell.creditDebitImage.image = #imageLiteral(resourceName: "debit")
            cell.titleLabel.text = historyCell?.body
            cell.platform.text = ""
        }else {
            cell.creditDebitImage.image = #imageLiteral(resourceName: "debit")
            cell.titleLabel.text = historyCell?.type
            cell.platform.text = historyCell?.body
        }
        
        cell.paymentDate.text = historyCell?.paymentAt?.removeTimeFromString((historyCell?.paymentAt)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - API
@available(iOS 13.0, *)
extension CreditsViewController {
    func fetchUserCreditsDetail() {
        CreditApiStore.sharedInstance.getCreditHistory(UserStore.sharedInstance.userInfo) { response in
            self.coinsHistoryResponse = response
            if response?.coinsHistoryResponse?.coinsHistoryData?.coins == "" {
                self.availableCredits.text = "0"
            } else {
                self.availableCredits.text = response?.coinsHistoryResponse?.coinsHistoryData?.coins ?? "0"
            }
            
            self.coinsHistoryData = response?.coinsHistoryResponse?.coinsHistoryData?.coinsHistory ?? []
            self.creditSummaryTableView.reloadData()
        }
    }
}
