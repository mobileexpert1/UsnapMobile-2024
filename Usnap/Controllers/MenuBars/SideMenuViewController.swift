//
//  SideMenuViewController.swift
//  Usnap
//
//  Created by APPLE on 27/07/23.
//  Copyright © 2023 Hakikat Singh. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMarketingKit
import FacebookCore
import FacebookLogin
import GoogleSignIn






protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

@available(iOS 13.0, *)
class SideMenuViewController: UIViewController {
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
//    @IBOutlet var footerLabel: UILabel!
    
//    @IBOutlet var okButton: UIButton!
//    @IBOutlet var customAlertView: UIImageView!
    

    var delegate: SideMenuViewControllerDelegate?

    var defaultHighlightedCell: Int = 0

    
        var alertView = UIView()
        var holderHeaderView = UIView()
        var currentVc = UIViewController()
        var selectedheaderArr = NSMutableArray()
        var menuCellsArray = Array<String>()
        var menuCellsImagesArray = Array<UIImage>()
        var messageBadge = String()
        var notificationBadge = String()

//    var menuData = [["title":"Campaigns","img":UIImage(named: "MenuCampaign")],["title":"Messages","img":UIImage(named: "MenuMessage")],["title":"Notifications","img":UIImage(named: "MenuNotifications")],["title":"Credits","img":UIImage(named: "MenuPayments")],["title":"Settings","img":UIImage(named: "MenuSettings")],["title":"Support","img":UIImage(named: "MenuSupport")],["title":"Shop","img":UIImage(named: "MenuShop")],["title":"Logout","img":UIImage(named: "MenuLogout")] ] as [[String:Any]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuCellsArray = ["Campaigns", "Messages", "Notifications", "Credits", "Settings", "Support", "Shop","Logout"]
        
        menuCellsImagesArray = [#imageLiteral(resourceName: "MenuCampaign"),#imageLiteral(resourceName: "MenuMessage"),#imageLiteral(resourceName: "MenuNotifications"),#imageLiteral(resourceName: "MenuPayments"),#imageLiteral(resourceName: "MenuSettings"),#imageLiteral(resourceName: "MenuSupport"),#imageLiteral(resourceName: "MenuShop"),#imageLiteral(resourceName: "MenuLogout")]
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMenuItems) , name: NSNotification.Name(rawValue: "updateMenu"), object:nil )
        
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        headerImageView.image = UIImage(named: "MenuLogo")

        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        // Footer
//        self.footerLabel.textColor = UIColor.white
//        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        self.footerLabel.text = "Developed by John Codeos"

        // Register TableView Cell
        let nibcell = UINib(nibName: "SideMenuCell", bundle: nil)
        sideMenuTableView.register(nibcell, forCellReuseIdentifier: "SideMenuCell")
        

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    
    @objc func updateMenuItems(_ notification : Notification) {
           getCounter()
       }
    
    
    
    func getCounter() {
           UserStore.sharedInstance.getCounter(UserStore.sharedInstance.userInfo, completion: { (resposne) in
               let responseData = resposne?["response"] as! NSDictionary
               if responseData["status"] as! String == "1" {
               self.messageBadge = responseData["unread"] as! String
               self.notificationBadge = responseData["notificationCounter"] as! String
                   self.sideMenuTableView.reloadData()
               } else {
               }
           })
       }
    
    @IBAction func okButtonClick(_ sender: Any) {
            self.alertView .removeFromSuperview()
        }
    
}

// MARK: - UITableViewDelegate

@available(iOS 13.0, *)
extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

@available(iOS 13.0, *)
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuCellsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        
        cell.iconImageView.image = menuCellsImagesArray[indexPath.row]
        
        if indexPath.row == 1 {
         let string_to_color = messageBadge
         let main_string = String(format: "%@ %@", menuCellsArray[indexPath.row], string_to_color)
         let range = (main_string as NSString).range(of: string_to_color)
         let attribute = NSMutableAttributedString.init(string: main_string)
         attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
         cell.titleLabel.attributedText = attribute
         
         
     }
     
    else if indexPath.row == 2 {
         let string_to_color = notificationBadge
         let main_string = String(format: "%@ %@", menuCellsArray[indexPath.row], string_to_color)
         
         let range = (main_string as NSString).range(of: string_to_color)
         
         let attribute = NSMutableAttributedString.init(string: main_string)
         attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
         cell.titleLabel.attributedText = attribute
         
       
     }
         
  
   else  if indexPath.row == 8 {
         var BoldMutableString = NSMutableAttributedString()
         BoldMutableString = NSMutableAttributedString(string: menuCellsArray[indexPath.row], attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic-Bold", size: 17.0)!])
         cell.titleLabel.attributedText = BoldMutableString
     }
     else {
         var normalMutableString = NSMutableAttributedString()
         normalMutableString = NSMutableAttributedString(string: menuCellsArray[indexPath.row], attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic", size: 17.0)!])
         cell.titleLabel.attributedText = normalMutableString
     }
        
        
        
//        cell.titleLabel.tintColor = UIColor.black
//        cell.titleLabel.text = menuData[indexPath.row]["title"] as? String
//        cell.iconImageView.image = menuData[indexPath.row]["img"] as? UIImage
//
//        // Highlighted color
//        let myCustomSelectionColorView = UIView()
//        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.7133850455, green: 0.7133850455, blue: 0.7133849263, alpha: 1)
//        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

