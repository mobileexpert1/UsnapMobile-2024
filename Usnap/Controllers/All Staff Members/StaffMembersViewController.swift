//
//  StaffMembersViewController.swift
//  Usnap
//
//  Created by CSPC141 on 04/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class StaffMembersViewController: AbstractControl, UITableViewDataSource, UITableViewDelegate, TopBarDelegate, staffFilterDelegate {
   
    
    
    @IBOutlet var requestCountLabel: UILabel!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var membersTableView: UITableView!
    var staffResponse = [Staffresult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
              
              let closeButtonImage = UIImage(named: "BackIcon")
                      navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(StaffMembersViewController.barButtonDidTap(_:)))
        
        let editImage    = UIImage(named: "TopBarFilter")!
              let searchImage  = UIImage(named: "TopBarAddBuddy")!

              let editButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(didTapEditButton(sender:)))
              let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))

              navigationItem.rightBarButtonItems = [editButton, searchButton]
        
//        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
//        share.image = UIImage(named: "TopBarFilter")
//        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        add.image = UIImage(named: "TopBarAddBuddy")
//        navigationItem.rightBarButtonItems = [add, add]
        
        
//        let button = UIButton(type: .custom)
//               button.setImage(UIImage(named: "Tick"), for: .normal)
//               button.addTarget(self, action: #selector(RightbButtonTaps), for: .touchUpInside)
//               button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//               let barButton = UIBarButtonItem(customView: button)
//               self.navigationItem.rightBarButtonItem = barButton
        
//        let button1 = UIButton(type: .custom)
//               button1.setImage(UIImage(named: "Tick"), for: .normal)
//               button1.addTarget(self, action: #selector(RightbButtonTapGesture), for: .touchUpInside)
//               button1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//               let barButton1 = UIBarButtonItem(customView: button1)
//               self.navigationItem.rightBarButtonItem = barButton1
        
        membersTableView.register(UINib(nibName: "StaffMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffMemberTableViewCell")
        topBar.delegate = self
        requestCountLabel.layer.cornerRadius = requestCountLabel.frame.width/2
        requestCountLabel.layer.masksToBounds = true
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:ConstantsKeys.STAFFFILTER_KEY),
                       object:nil, queue:nil,
                       using:catchNotification_Filter)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        staffResponse = [Staffresult]()
        self.membersTableView.reloadData()
        fetchStaffList()
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
    
    
    
    func filterData(_ data : NSDictionary, _ clearButton: String) {
        if clearButton == "Yes" {
          fetchStaffList()
        } else {
        fetchStaffList_Filters(data["MemberName"]! as! String, data["EmailAddress"]! as! String, data["mobileNumber"]! as! String)
        }
    }
    
    
    func catchNotification_Filter(notification:Notification) -> Void {
        NotificationCenter.default.removeObserver(self)
        fetchStaffList_Filters(notification.userInfo!["MemberName"]! as! String, notification.userInfo!["EmailAddress"]! as! String, notification.userInfo!["mobileNumber"]! as! String)
    }
    
    func fetchStaffList_Filters(_ name: String, _ emailid: String, _ mobileNumber: String)  {
        PopUpApiStore.sharedInstance.getStaffListFilters(UserStore.sharedInstance.userInfo, mobileNumber, emailid, name) { (response) in
            if response?.staffresponse?.status == "1" {
                self.requestCountLabel.text = NSString(format:"%d", (response?.staffresponse?.totalRequests!)!) as String
                if response?.staffresponse?.staffresult?.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else {
                    self.staffResponse = (response?.staffresponse?.staffresult!)!
                    self.membersTableView.reloadData()
                }
            }  else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
  
    func fetchStaffList()  {
        StaffStore.sharedInstance.getStaffList(UserStore.sharedInstance.userInfo) { (response) in
            if response?.staffresponse?.status == "1" {
                self.staffResponse = (response?.staffresponse?.staffresult!)!
                self.requestCountLabel.text = NSString(format:"%d", (response?.staffresponse?.totalRequests!)!) as String
                if self.staffResponse.count == 0 {
                SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else {
                    self.membersTableView.reloadData()
                }
               
            }  else {
                SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func staffRequest(_ sender: Any) {
        navigationController?.pushViewController(StaffMemberRequestViewController.control, animated: true)
    }
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
    }

    @objc func didTapSearchButton(sender: AnyObject){
        navigationController?.pushViewController(AddStaffMemberViewController.control, animated: true)
       }

        @objc func didTapEditButton(sender: AnyObject){
           let control = StaffFilterViewController.control as! StaffFilterViewController
           control.delegate = self
         present(control, animated: false, completion: nil)
           
   //         StaffFilterViewController.showControl()
       }
    
    
    
    func leftButtonClicked2() {
    }
//    @objc func addTapped() {
//        let control = StaffFilterViewController.control as! StaffFilterViewController
//        control.delegate = self
//      present(control, animated: false, completion: nil)
//
////         StaffFilterViewController.showControl()
//    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staffResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffMemberTableViewCell", for: indexPath) as! StaffMemberTableViewCell
        cell.staffMemberName.text = String(format: "%@ %@", self.staffResponse[indexPath.row].userFirstName!, self.staffResponse[indexPath.row].userLastName!)
        cell.staffMemberEmail.text = self.staffResponse[indexPath.row].userEmail
        cell.staffMemberPhone.text = self.staffResponse[indexPath.row].userMobile
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         navigationController?.pushViewController(StaffMemberDetailViewController.control(self.staffResponse[indexPath.row]), animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StaffMemberDetailViewController" {
            let destinationVC = segue.destination as! StaffMemberDetailViewController
            destinationVC.selectedStaffDetail = self.staffResponse[0]
        }
        
    }
    

}
