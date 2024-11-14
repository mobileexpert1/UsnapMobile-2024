//
//  MenuClassViewController.swift
//  Planet
//
//  Created by CSPC141 on 23/11/16.
//  Copyright © 2016 CSPC141. All rights reserved.
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

//protocol MenuDelegate {
//    func menuHandler(index: Int)
//}


//class MenuClassViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {
//   
//    
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.menuTableView.dequeueReusableCell(withIdentifier: "subMenuListCustomCell", for: indexPath) as! subMenuListCustomCell
//        cell.iconImageView.image = menuCellsImagesArray[indexPath.row]
//        
//        
//           if indexPath.row == 1 {
//            let string_to_color = messageBadge
//            let main_string = String(format: "%@ %@", menuCellsArray[indexPath.row], string_to_color)
//            let range = (main_string as NSString).range(of: string_to_color)
//            let attribute = NSMutableAttributedString.init(string: main_string)
//            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
//            cell.menuItemsLabel.attributedText = attribute
//            
//            //cell.menuItemsLabel.text = "bjkdewe2"
//        }
//        
//       else if indexPath.row == 2 {
//            let string_to_color = notificationBadge
//            let main_string = String(format: "%@ %@", menuCellsArray[indexPath.row], string_to_color)
//            
//            let range = (main_string as NSString).range(of: string_to_color)
//            
//            let attribute = NSMutableAttributedString.init(string: main_string)
//            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
//            cell.menuItemsLabel.attributedText = attribute
//            
//            //cell.menuItemsLabel.text = "bjkdewe2"
//        }
//            
//     
//      else  if indexPath.row == 8 {
//            var BoldMutableString = NSMutableAttributedString()
//            BoldMutableString = NSMutableAttributedString(string: menuCellsArray[indexPath.row], attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic-Bold", size: 17.0)!])
//            cell.menuItemsLabel.attributedText = BoldMutableString
//        }
//        else {
//            var normalMutableString = NSMutableAttributedString()
//            normalMutableString = NSMutableAttributedString(string: menuCellsArray[indexPath.row], attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic", size: 17.0)!])
//            cell.menuItemsLabel.attributedText = normalMutableString
//        }
//        return cell
//    }
//    
//    
//    @IBOutlet var okButton: UIButton!
//    @IBOutlet var customAlertView: UIImageView!
//    @IBOutlet var menuTableView: UITableView!
//    
//    var delegate: MenuDelegate?
//    var alertView = UIView()
//    var holderHeaderView = UIView()
//    var currentVc = UIViewController()
//    var selectedheaderArr = NSMutableArray()
//    var menuCellsArray = Array<String>()
//    var menuCellsImagesArray = Array<UIImage>()
//    var messageBadge = String()
//    var notificationBadge = String()
//    
//    static var menus: [String] = ["Campaigns", "Messages", "Notifications", "Credits", "Settings", "Support", "Shop","Logout"]
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabCheck()
//        let nib = UINib(nibName: "subMenuListCustomCell", bundle: nil)
//        self.menuTableView.register(nib, forCellReuseIdentifier:
//            "subMenuListCustomCell")
//        // newEdit-phase2
////        menuCellsArray = ["Campaigns", "Messages", "Notifications", "Payments", "Settings", "Support", "Shop","Logout"]
////        menuCellsImagesArray = [#imageLiteral(resourceName: "MenuCampaign"),#imageLiteral(resourceName: "MenuMessage"),#imageLiteral(resourceName: "MenuNotifications"),#imageLiteral(resourceName: "MenuPayments"),#imageLiteral(resourceName: "MenuSettings"),#imageLiteral(resourceName: "MenuSupport"),#imageLiteral(resourceName: "MenuShop"),#imageLiteral(resourceName: "MenuLogout")]
////
////        menuCellsArray = ["Campaigns", "Messages", "Notifications", "Credits", "Settings", "Support", "Shop","Logout"]
//        menuCellsImagesArray = [#imageLiteral(resourceName: "MenuCampaign"),#imageLiteral(resourceName: "MenuMessage"),#imageLiteral(resourceName: "MenuNotifications"),#imageLiteral(resourceName: "MenuPayments"),#imageLiteral(resourceName: "MenuSettings"),#imageLiteral(resourceName: "MenuSupport"),#imageLiteral(resourceName: "MenuShop"),#imageLiteral(resourceName: "MenuLogout")]
//        NotificationCenter.default.addObserver(self, selector: #selector(updateMenuItems) , name: NSNotification.Name(rawValue: "updateMenu"), object:nil )
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        getCounter()
//    }
//    
//    @objc func updateMenuItems(_ notification : Notification) {
//        getCounter()
//    }
//    
//    func getCounter() {
//        UserStore.sharedInstance.getCounter(UserStore.sharedInstance.userInfo, completion: { (resposne) in
//            let responseData = resposne?["response"] as! NSDictionary
//            if responseData["status"] as! String == "1" {
//            self.messageBadge = responseData["unread"] as! String
//            self.notificationBadge = responseData["notificationCounter"] as! String
//                self.menuTableView.reloadData()
//            } else {
//            }
//        })
//    }
//    
//    func tabCheck() {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.modalPresentationStyle = .fullScreen
//            
//            print("ipad devices")
//        }else {
//            self.modalPresentationStyle = .fullScreen
//            print("iphone devices")
//        }
//        
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func okButtonClick(_ sender: Any) {
//        self.alertView .removeFromSuperview()
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//     return menuCellsArray.count
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        var controller = UIViewController()
////        switch indexPath.row {
////        case 0:
////            controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 1:
////            controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 2:
////            controller = storyboard.instantiateViewController(withIdentifier: "ChatListViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////
////        case 3:
////            controller = storyboard.instantiateViewController(withIdentifier:"NotificationsViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////          break
////          case 4:
////            controller = storyboard.instantiateViewController(withIdentifier:"InvoicesViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 5:
////            controller = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 6:
////            controller = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////
////            break
////        case 7:
////            controller = storyboard.instantiateViewController(withIdentifier: "LensShopViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////
////        case 8:
////            UserStore.sharedInstance.userInfo = ""
////            controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        default:
////            print("executed default of switch")
////        }
////        NSLog("below Viewontroller: %@",  SlideNavigationController.sharedInstance().viewControllers)
////    }
//    
//    
//    
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        var controller = UIViewController()
////        switch indexPath.row {
////        case 0:
////            controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 1:
////            controller = storyboard.instantiateViewController(withIdentifier: "ChatListViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 2:
////            controller = storyboard.instantiateViewController(withIdentifier:"NotificationsViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////
////        case 3:
////
////            // newEdit-phase2
//////            controller = storyboard.instantiateViewController(withIdentifier:"InvoicesViewController")
//////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////
////            controller = storyboard.instantiateViewController(withIdentifier:"CreditsViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////
////            break
////        case 4:
////            controller = storyboard.instantiateViewController(withIdentifier:"SettingViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 5:
////            controller = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////        case 6:
////            controller = storyboard.instantiateViewController(withIdentifier: "LensShopViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////
////            break
////        case 7:
////           UserStore.sharedInstance.userInfo = "logout"
////            GIDSignIn.sharedInstance()?.signOut()
////            FBSDKLoginManager().logOut()
////
////
////            controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
////            SlideNavigationController.sharedInstance().popToRootAndSwitch(to: controller, withCompletion: nil)
////            break
////           default:
////            print("executed default of switch")
////        }
////        NSLog("below Viewontroller: %@",  SlideNavigationController.sharedInstance().viewControllers)
////    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
//}
