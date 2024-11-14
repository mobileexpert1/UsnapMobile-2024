//
//  MessagingViewController.swift
//  Usnap
//
//  Created by CSPC141 on 17/04/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications

@available(iOS 13.0, *)
class MessagingViewController: AbstractControl, TopBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        
    }
    
    func leftButtonClicked2() {
        
    }
    
    @IBOutlet var topBar: TopBarView!
    
    @IBOutlet var sendMessage: UIButton!
    @IBOutlet var textInputBox: UITextView!
    @IBOutlet var messageTableView: UITableView!
    
   
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    
    var fetchedMessages = [MessageHistoryresult]()
    var refresher : UIRefreshControl!
    var pageingCounter = Int()
    var totalPages = Int()
    var backUPModel = [MessageHistoryresult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        
        
        
        NotificationCenter.default.removeObserver(self)
        messageTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverTableViewCell")
        messageTableView.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        topBar.delegate = self
        refresher = UIRefreshControl()
        messageTableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: nil)
        refresher.tintColor = UIColor.black
        refresher.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        pageingCounter = 1
        getMessages()
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
     
        nc.addObserver(self, selector: #selector(catchNotification_Message), name: Notification.Name(rawValue:ConstantsKeys.REFRESHMESSAGE_KEY), object: nil)
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                // Authorization request has not been made yet
                self.showNotificationAlert()
                    break
                case .denied:
                    // User has denied authorization.
                self.showNotificationAlert()
                    break
                // You could tell them to change this in Settings
                case .authorized: break
                    // User has given authorization.
                case .provisional:
                self.showNotificationAlert()
                    break
                case .ephemeral: break
                    
                }
            })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                print("APNS-YES")
            } else {
                print("APNS-NO")
                showNotificationAlert()
            }
        }
//        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
//        if isRegisteredForRemoteNotifications {
//            // User is registered for notification
//        } else {
//            // Show alert user is not registered for notification
//
//
//            UIAlertController.showAlert("Alert", message: "Please allow for notifications in app phone settings for smooth chat", buttons: ["ok"]) { (alert, count) in
//
//            }
//
//        }
        
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
    
    
    
    
    

    func showNotificationAlert()  {
        UIAlertController.showAlert("Alert", message: "Please allow for notifications in app phone settings for smooth chat", buttons: ["ok"]) { (alert, count) in
            
                        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
  
    
    @objc func refreshList()  {
        
        if pageingCounter <= totalPages{
            pageingCounter = pageingCounter + 1
            getMessages()
        }
        refresher.endRefreshing()
    }
    
    
  @objc func catchNotification_Message(notification:Notification) -> Void {
        NotificationCenter.default.removeObserver(self)
        refreshMessageList() 
        //        guard let userInfo = notification.userInfo,
        //            let selectedValue  = userInfo["selectedValue"] as? String else {
        //                return
        //        }
        //        selectCampaignButton.setTitle(selectedValue, for: .normal)
        //        selectedCampaignID = userInfo["SelectedIndex"]! as! String
    }
    
    
    func refreshMessageList()  {
        
        var lastMsgId = String()

        
        if fetchedMessages.count == 0  {
            lastMsgId = "0"
            
        }
        else {
           lastMsgId = fetchedMessages[0].internalIdentifier!
        }
        
        
        MessagesStores.sharedInstance.MessageRefresh(UserStore.sharedInstance.userInfo, LocalMessageStore.sharedInstance.chatCampaignId, lastMsgId) { (response) in
            if response?.messageHistoryresponse?.status == "1" {
                var tempMessageModel = [MessageHistoryresult]()
                tempMessageModel = (response?.messageHistoryresponse?.messageHistoryresult)!
                var oldData = [MessageHistoryresult]()
                oldData = self.fetchedMessages
                self.fetchedMessages = [MessageHistoryresult]()
                self.fetchedMessages.append(contentsOf: tempMessageModel)
                self.fetchedMessages.append(contentsOf:oldData)
                self.backUPModel = [MessageHistoryresult]()
                self.backUPModel = self.fetchedMessages
                // self.fetchedMessages = self.fetchedMessages.reversed()
                // self.fetchedMessages = self.fetchedMessages.reversed()
                self.textInputBox.text = ""
                self.scrollToBottom()
                self.messageTableView.reloadData()
                
            }
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        NotificationCenter.default.removeObserver(self)
//        let nc = NotificationCenter.default
//        nc.removeObserver(self, name: NSNotification.Name(rawValue: ConstantsKeys.REFRESHMESSAGE_KEY), object: nil)
    }
    
    
    
    
    func getMessages()  {
        MessagesStores.sharedInstance.MessageHistory(UserStore.sharedInstance.userInfo, LocalMessageStore.sharedInstance.chatCampaignId, String(pageingCounter)) { (response) in
            if response?.messageHistoryresponse?.status == "1" {
                if self.pageingCounter == 1 {
                  self.fetchedMessages = (response?.messageHistoryresponse?.messageHistoryresult)!
                    self.backUPModel = [MessageHistoryresult]()
                    self.backUPModel = self.fetchedMessages
                }
                else {
                    self.fetchedMessages = [MessageHistoryresult]()
                    self.fetchedMessages.append(contentsOf: self.backUPModel)
                    var newTempArray = [MessageHistoryresult]()
                    newTempArray = (response?.messageHistoryresponse?.messageHistoryresult)!
                    self.fetchedMessages.append(contentsOf: newTempArray)
                    self.backUPModel = [MessageHistoryresult]()
                    self.backUPModel = self.fetchedMessages
                }
              //  self.fetchedMessages = self.fetchedMessages.reversed()
               // self.fetchedMessages = self.fetchedMessages.reversed()
                
               // (myString2 as NSString).integerValue
                
               // self.totalPages = (response?.messageHistoryresponse?.totalpages! as! NSString).integerValue
                //self.totalPages = (response?.messageHistoryresponse?.totalpages)!
                self.totalPages = Int((response?.messageHistoryresponse?.totalpages) ?? "") ?? 0
                self.messageTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendClick(_ sender: Any) {
        
        if textInputBox.text == "" {
            SVProgressHUD.showError(withStatus: "Please enter your message")
            return
        }
        
        MessagesStores.sharedInstance.sendChatMessage(UserStore.sharedInstance.userInfo, LocalMessageStore.sharedInstance.chatCampaignId, UserStore.sharedInstance.userInfo, textInputBox.text!, "") { (response) in
            if response?.messageHistoryresponse?.status == "1" {
                var tempMessageModel = [MessageHistoryresult]()
                tempMessageModel = (response?.messageHistoryresponse?.messageHistoryresult)!
                var oldData = [MessageHistoryresult]()
                oldData = self.fetchedMessages
                self.fetchedMessages = [MessageHistoryresult]()
                self.fetchedMessages.append(contentsOf: tempMessageModel)
                self.fetchedMessages.append(contentsOf:oldData)
                self.backUPModel = [MessageHistoryresult]()
                self.backUPModel = self.fetchedMessages
               // self.fetchedMessages = self.fetchedMessages.reversed()
//                self.fetchedMessages = self.fetchedMessages.reversed()
                self.textInputBox.text = ""
                self.scrollToBottom()
                self.messageTableView.reloadData()
                
            }
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.fetchedMessages.count-1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let receiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as! ReceiverTableViewCell
        if fetchedMessages[(fetchedMessages.count - 1) - indexPath.row ].messageBy == "0" {
            receiverCell.nameLabel.text = String(format: "%@ %@", fetchedMessages[(fetchedMessages.count - 1) - indexPath.row ].userFirstName!, fetchedMessages[(fetchedMessages.count - 1) - indexPath.row ].userLastName!)
            receiverCell.messageLabel.text = fetchedMessages[(fetchedMessages.count - 1) - indexPath.row].message
            return receiverCell
        }
        
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
        senderCell.nameLabel.text = String(format: "%@ %@", UserStore.sharedInstance.userDetails.userFirstName!,UserStore.sharedInstance.userDetails.userLastName!)
        senderCell.messageLabel.text = fetchedMessages[(fetchedMessages.count - 1) - indexPath.row].message
        return senderCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
