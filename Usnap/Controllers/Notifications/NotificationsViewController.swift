//
//  NotificationsViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import Photos

@available(iOS 13.0, *)
class NotificationsViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, TopBarDelegate {
    
    @IBOutlet var notificationsListView: UITableView!
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var popUpSwitch: UISwitch!
    @IBOutlet var popUpLabel: UILabel!
    @IBOutlet var popUpHolderView: UIView!
    @IBOutlet weak var backToHome: UIBarButtonItem!
    
    
    @IBOutlet weak var startSelection: UIBarButtonItem!
    var notificationsData = [NotificationResult]()
    var mediaData = [DownloadCamMediaresult]()
    var clickedIndex = Int()
    var switchValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        backToHome.target = revealViewController()
        backToHome.action = #selector(revealViewController()?.revealSideMenu)
        
        topBar.delegate = self
        notificationsListView.allowsMultipleSelectionDuringEditing = true
        notificationsListView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        selectAllButton.setTitle("Select All",for: .normal)
        selectAllButton.isHidden = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notificationsListView.isEditing  = isEditing
        getNotifications()
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
    
    
    
    
    
    func getNotifications()  {
        UserStore.sharedInstance.getUserNotifications(UserStore.sharedInstance.userInfo) { (response) in
            if response?.notificationResponse?.status == "1" {
                self.notificationsData = (response?.notificationResponse?.notificationResult)!
                self.notificationsListView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAllClick(_ sender: Any) {
        if selectAllButton.titleLabel?.text == "Select All" {
            selectAllButton.setTitle("Unselect All",for: .normal)
            let totalRows = notificationsListView.numberOfRows(inSection: 0)
            for row in 0..<totalRows {
                notificationsListView.selectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
        } else {
            selectAllButton.setTitle("Select All",for: .normal)
            let totalRows = notificationsListView.numberOfRows(inSection: 0)
            for row in 0..<totalRows {
                notificationsListView.deselectRow(at: NSIndexPath(row: row, section: 0) as IndexPath, animated: false)
            }
        }
    }
    
    // MARK: - Topbar Delegates
    
    @IBAction func readButtonClick(_ sender: Any) {
        notificationsUserAction("1")
    }
    
    @IBAction func unreadClick(_ sender: Any) {
        notificationsUserAction("0")
        
    }
    
    func notificationsUserAction(_ status: String) {
        if let selectedRows = notificationsListView.indexPathsForSelectedRows {
            var items = [String]()
            for indexPath in selectedRows  {
                items.append(notificationsData[indexPath.row].internalIdentifier!)
            }
            print(items)
            let joinedString = items.compactMap{ $0 }.joined(separator: ",")
            print(joinedString)
            
            UserStore.sharedInstance.setNotificationReadUnread(UserStore.sharedInstance.userInfo, joinedString, status) { (response) in
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.notificationsListView.isEditing  = self.isEditing
                    self.startSelection.image = UIImage(named: "StartSelection")
//                    self.topBar.leftButton2.setImage(#imageLiteral(resourceName: "StartSelection"), for: .normal)
                    self.notificationsListView.reloadData()
                    self.getNotifications()
                    self.selectAllButton.isHidden = true
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
                
            }
        }
    }
    
    func backButtonClicked() {
    }
    
    func leftButtonClicked1() {
    }
    
    
    @IBAction func btnClicked(_ sender: Any) {
        selectAllButton.setTitle("Select All",for: .normal)
        if notificationsListView.isEditing {
            selectAllButton.isHidden = true
            notificationsListView.isEditing  = isEditing
            startSelection.image = UIImage(named: "StartSelection")
//            setImage(#imageLiteral(resourceName: "StartSelection"), for: .normal)
        }
      
        else {
            selectAllButton.isHidden = false
           startSelection.image = UIImage(named: "StopSelection")
//            setImage(#imageLiteral(resourceName: "StopSelection"), for: .normal)
            notificationsListView.isEditing  = !isEditing
        }
        
    }
    
    
    func leftButtonClicked2() {
//        selectAllButton.setTitle("Select All",for: .normal)
//        if notificationsListView.isEditing {
//            selectAllButton.isHidden = true
//            notificationsListView.isEditing  = isEditing
////            startSelection.setImage(#imageLiteral(resourceName: "StartSelection"), for: .normal)
//        }
//        else {
//            selectAllButton.isHidden = false
//            topBar.leftButton2.setImage(#imageLiteral(resourceName: "StopSelection"), for: .normal)
//            notificationsListView.isEditing  = !isEditing
//        }
        
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.notificationTextLabel.text = notificationsData[indexPath.row].message
        if notificationsData[indexPath.row].status == "1" {
            cell.notificationTextLabel.textColor = UIColor.black
        }
        else {
            cell.notificationTextLabel.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationsListView.isEditing {
        }
        else {
            changeStatus(indexPath)
        }
    }
    
    func changeStatus(_ indexPath : IndexPath)  {
        UserStore.sharedInstance.changeNotificationStatus(UserStore.sharedInstance.userInfo, notificationsData[indexPath.row].internalIdentifier!) { (response) in
            print(response as Any)
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                self.navigateUser(indexPath)
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func navigateUser(_ indexPath: IndexPath) {
        print(self.notificationsData[indexPath.row].notiRelId!)
        // CAMPAIGN OVER
        if self.notificationsData[indexPath.row].tableName == "campaign_over" {
            popUpLabel.text = notificationsData[indexPath.row].message
            if self.notificationsData[indexPath.row].UserSwitch == "0" {
                popUpSwitch.setOn(false, animated:true)
                switchValue = "0"
            } else {
                popUpSwitch.setOn(true, animated:true)
                switchValue = "1"
            }
            clickedIndex = indexPath.row
            popUpHolderView.isHidden = false
            getNotifications()
        }
        // CAMPAIGN INVOICES
        if self.notificationsData[indexPath.row].tableName == "orders" {
            CompletedCampaignStore.sharedInstance.CompletedCampaignId =  self.notificationsData[indexPath.row].notiRelId!
            navigationController?.pushViewController(CampaignInvoiceViewController.control, animated: true)
        }
        // ADDITIONAL SERVICES
        if self.notificationsData[indexPath.row].tableName == "additional_services" {
            navigationController?.pushViewController(AdditionalServicesViewController.Control(LocalCampaignStore.init(self.notificationsData[indexPath.row].notiRelId!)), animated: true)
        }
        // CAMPAIGN
        if self.notificationsData[indexPath.row].tableName == "campaign" {
            var Campaign = CampaignListresult(object: "")
            Campaign.internalIdentifier = self.notificationsData[indexPath.row].notiRelId!
            navigationController?.pushViewController(CompletedCampaignViewController.control(Campaign), animated: true)
        }
        // CAMPAIGN
        if self.notificationsData[indexPath.row].tableName == "newcampaign" {
            print(self.notificationsData[indexPath.row].notiRelId!)
            let myString1:String = self.notificationsData[indexPath.row].notiRelId!
            let myInt1 = (myString1 as NSString).integerValue
            print(myInt1)
            NewCampaignDetailStore.sharedInstance.createdCampaignId = myInt1
            self.navigationController?.pushViewController(CampaignDetailViewController.control, animated: true)
        }
    }
    
    @IBAction func switchClick(_ sender: UISwitch) {
        if sender.isOn {
            switchValue = "1"
        } else {
            switchValue = "0"
        }
    }
    
    @IBAction func keepDataClick(_ sender: Any) {
    UserStore.sharedInstance.notificationsPaymentAction(self.notificationsData[clickedIndex].internalIdentifier!, "0", switchValue) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: responseData["message"] as? String)
                self.popUpHolderView.isHidden = true
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func downloadDataClick(_ sender: Any) {        CampaignStore.sharedInstance.downloadCampaignMedia(self.notificationsData[clickedIndex].internalIdentifier!) { (response) in
            if response?.downloadCamMediaresponse?.status == "1" {
                self.mediaData = (response?.downloadCamMediaresponse?.downloadCamMediaresult)!
                if self.mediaData.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                } else {
                    self.startDownlaoding()
                    self.popUpHolderView.isHidden = true
                }
            }
        }
    }
    
    func startDownlaoding()  {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        for  i in 0 ..< self.mediaData.count {
            if mediaData[i].type == "p" {
                let urlStr = String(format: "%@%@", APIs.KIMAGEBASEURL, mediaData[i].media!)
                let url = URL(string:urlStr)
                if let data = try? Data(contentsOf: url!) {
                    let image: UIImage = UIImage(data: data)!
                    DataDownloadStore.sharedInstance.downlaodImage(image, mediaData[i].title!, completion: { (response) in
                        if response == "1" {
                            if i == self.mediaData.count - 1 {
                                DispatchQueue.main.async {
                                    self.deleMediaAfterDownload()
                                }
                            }
                        }
                    })
                    // DataDownloadStore.sharedInstance.dow
                }
            }
            else {
                let videoImageUrl = String(format: "%@%@", APIs.KVIDEOBASEURL, mediaData[i].media!)
                DataDownloadStore.sharedInstance.downloadVideo(videoImageUrl, "dew", completion: { (response) in
                    print(response)
                    if response == "1" {
                        if i == self.mediaData.count - 1 {
                            DispatchQueue.main.async {
                                self.deleMediaAfterDownload()
                            }
                        }
                    }
                    else {
                        
                    }
                })
            }
        }
    }
    
    
    func deleMediaAfterDownload()  {
        CampaignStore.sharedInstance.deleteAfterDownload(self.notificationsData[clickedIndex].internalIdentifier!) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: "Media files are downloaded to gallery and deleted from the server")
                self.performSegueToReturnBack()
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    @IBAction func popUpCrossClick(_ sender: Any) {
        popUpHolderView.isHidden = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
