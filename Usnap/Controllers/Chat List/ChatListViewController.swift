//
//  ChatListViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ChatListViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource,TopBarDelegate, UISearchBarDelegate {
    
    func backButtonClicked() {
    }
    
    func leftButtonClicked1() {
        
    }
    
    func leftButtonClicked2() {
        
    }
    
    
    @IBOutlet var chatListController: UITableView!
    
    @IBOutlet weak var topBarViews: TopBarView!
    @IBOutlet var searchField: UISearchBar!
    
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    var listTitles = [MessageListresult]()
    var searchArray = [MessageListresult]()
    var modelBackUp = [MessageListresult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        
        topBarViews.leftButton2.isUserInteractionEnabled = false
        topBarViews.leftButton1.isUserInteractionEnabled = false
        chatListController.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        searchField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMessageList()
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
    
    
    
    func getMessageList() {
        MessagesStores.sharedInstance.MessageList(UserStore.sharedInstance.userInfo) { (response) in
            if response?.messageListresponse?.status == "1" {
                self.listTitles = (response?.messageListresponse?.messageListresult)!
                self.modelBackUp = self.listTitles
                self.chatListController.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        var string_to_color = listTitles[indexPath.row].Unread!
        if listTitles[indexPath.row].Unread == "0" {
            string_to_color = ""
        }
        let main_string = String(format: "%@       %@", listTitles[indexPath.row].title!, string_to_color)
        let range = (main_string as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
        cell.titleLabel.attributedText = attribute
        // cell.titleLabel.text = listTitles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalMessageStore.sharedInstance.chatCampaignId = listTitles[indexPath.row].campaignId!
        navigationController?.pushViewController(MessagingViewController.control, animated: true)
    }
    
    // MARK: - Search Bar Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listTitles = [MessageListresult]()
        listTitles = modelBackUp
        searchArray = [MessageListresult]()
        
        if searchText.length != 0 {
            for i in 0..<listTitles.count {
                if ((listTitles[i].title?.lowercased() as! NSString).range(of: searchText.lowercased())).location != NSNotFound {
                    searchArray.append(listTitles[i])
                    //  searchArray.append(item)
                }
            }
            listTitles = [MessageListresult]()
            listTitles = searchArray
        }
        else {
            listTitles = [MessageListresult]()
            listTitles = modelBackUp
            // searchArray = items
        }
        chatListController.reloadData()
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
