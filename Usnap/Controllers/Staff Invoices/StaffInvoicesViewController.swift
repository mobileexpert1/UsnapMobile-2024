//
//  StaffInvoicesViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class StaffInvoicesViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, TopBarDelegate, memberInvoiceDelegate {
   
    func memberInvoiceFilter(_ data : NSDictionary, _ clearButton: String) {
        if clearButton == "Yes" {
           fetchStaffInvoices()
        }
        else {
            fetchDataWithFilters(staffMemberId, data["campaignCategoryId"] as! String, data["campaignName"] as! String, data["status"] as! String, data["startDate"] as! String, data["endDate"] as! String)
        }
    }
    
    class func control(_ staffId : String) -> StaffInvoicesViewController {
        let control = self.control as! StaffInvoicesViewController
        control.staffMemberId = staffId
        return control
    }

    @IBOutlet var selectAllLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var invoiceListView: UITableView!
    var rowsWhichAreChecked = [NSIndexPath]()
    var selectedCells = NSMutableArray()
    
    var staffInvoiceList = [BaseStaffInvoiceinvoices]()
    
    @IBOutlet var selectAllButton: UIButton!
    var selectedPdfs = NSMutableArray()
    var staffMemberId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButtonImage = UIImage(named: "EditIcon")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(StaffInvoicesViewController.barButtonDidTap(_:)))
        
        invoiceListView.register(UINib(nibName: "StaffInvoicesTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffInvoicesTableViewCell")
        topBar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStaffInvoices()
    }
    
    func fetchDataWithFilters(_ user_id: String, _ catagory_id: String, _ title: String, _ status: String, _ strdate: String, _ enddate: String)  {
        PopUpApiStore.sharedInstance.getStaffInvoicesFilters(user_id, catagory_id, title, status, strdate, enddate) { (response) in
            if response?.baseStaffInvoiceresponse?.status == "1" {
                self.staffInvoiceList = (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.baseStaffInvoiceinvoices)!
                self.nameLabel.text = String(format: "%@ %@", (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userFirstName)!, (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userLastName)!)
                self.emailLabel.text = response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userEmail
                self.mobileNumberLabel.text = response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userMobile
                self.invoiceListView.reloadData()
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    
    func fetchStaffInvoices()  {
        PaymentStore.sharedInstance.staffInvoices(staffMemberId) { (response) in
            if response?.baseStaffInvoiceresponse?.status == "1" {
                self.staffInvoiceList = (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.baseStaffInvoiceinvoices)!
                self.nameLabel.text = String(format: "%@ %@", (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userFirstName)!, (response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userLastName)!)
                self.emailLabel.text = response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userEmail
                self.mobileNumberLabel.text = response?.baseStaffInvoiceresponse?.baseStaffInvoiceresult?.userMobile
                self.invoiceListView.reloadData()
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Top Bar Delegates
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        
    }
    
    func leftButtonClicked2() {
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
        let control = MemberInvoicesFilterViewController.control as! MemberInvoicesFilterViewController
        control.delegate = self
        UIApplication.visibleViewController.present(control, animated: false, completion: nil)
        // MemberInvoicesFilterViewController.showControl()
    }
    
    // MARK: - Buttons Actions
    @IBAction func selectAllClick(_ sender: Any) {
       
        
            if selectedCells.count >= staffInvoiceList.count {
                for i in 0..<staffInvoiceList.count  {
                    selectedCells.remove(i)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
            else {
                for i in 0..<staffInvoiceList.count {
                    selectedCells.add(i)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectAllLabel.text = "Deselect All"
            }
        
        

        invoiceListView.reloadData()
    }
    

    
    @ IBAction func shareButton(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        if selectedCells.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells.count  {
            selectedPdfs.add(staffInvoiceList[i].generatePdf as Any)
        }
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            self.selectedCells.removeAllObjects()
            self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            self.selectAllLabel.text = "Select All"
            self.invoiceListView.reloadData()
        }
    }
    
    @IBAction func downloadButton(_ sender: Any) {
        
        selectedPdfs = NSMutableArray()
        
        let selectedPdfsNames = NSMutableArray()
        
        if selectedCells.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        for i in 0 ..< selectedCells.count {
            selectedPdfs.add(staffInvoiceList[i].generatePdf as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", staffInvoiceList[i].title!, staffInvoiceList[i].internalIdentifier!,randomString(length: 15))
            selectedPdfsNames.add(invoiceName)
        }
       
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                if response == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                    self.selectedCells.removeAllObjects()
                    self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                    self.selectAllLabel.text = "Select All"
                    self.invoiceListView.reloadData()
                }
            }
        }
        
        
        
        
        
        
        
//        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//        }
        
        
        
        
        
        
        
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffInvoiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffInvoicesTableViewCell", for: indexPath) as! StaffInvoicesTableViewCell
      cell.invoiceNumber.text = staffInvoiceList[indexPath.row].internalIdentifier
        cell.campaignName.text = staffInvoiceList[indexPath.row].title
        cell.totalAmount.text = staffInvoiceList[indexPath.row].amount
        cell.date.text = staffInvoiceList[indexPath.row].dateOfCreation?.removeTimeFromString(staffInvoiceList[indexPath.row].dateOfCreation!)
        if staffInvoiceList[indexPath.row].paymentStatus == "0" {
            cell.statusLabel.text = "Pending"
        }
        else {
            cell.statusLabel.text = "Paid"
        }
        
        if selectedCells.contains(indexPath.row) {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
        }
        else {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
        }

        cell.checkBoxButton.addTarget(self, action: #selector(tableViewCheckBoxClick), for: .touchUpInside)
        cell.checkBoxButton.tag = indexPath.row
        
        cell.downloadButton.addTarget(self, action: #selector(tableViewDownloadClick), for: .touchUpInside)
        cell.downloadButton.tag = indexPath.row
        
        cell.shareButton.addTarget(self, action: #selector(tableViewShareClick), for: .touchUpInside)
        cell.shareButton.tag = indexPath.row
        
        cell.resendButton.addTarget(self, action: #selector(tableViewResendClick), for: .touchUpInside)
        cell.resendButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // return UITableView.UITableViewAutomaticDimension
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:StaffInvoicesTableViewCell = tableView.cellForRow(at: indexPath) as! StaffInvoicesTableViewCell
        // cross checking for checked rows
       
        if(rowsWhichAreChecked.contains(indexPath as NSIndexPath) == false) {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            rowsWhichAreChecked.append(indexPath as NSIndexPath)
        }else{
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            if let checkedItemIndex = rowsWhichAreChecked.index(of: indexPath as NSIndexPath){
                rowsWhichAreChecked.remove(at: checkedItemIndex)
            }
        }
        
    }
    

    // Table View check  Buttons
    @objc func tableViewCheckBoxClick(sender: UIButton!) {
        let cell = getCellForView(view: sender) as! StaffInvoicesTableViewCell
        let indexPath = invoiceListView.indexPath(for: cell)
        
        // FOR PAID SECTION
        
            if selectedCells.contains(indexPath?.row as Any) {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                self.selectedCells.remove(indexPath?.row as Any)
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
            else {
                 cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectedCells.add(indexPath?.row as Any)
                if selectedCells.count >= staffInvoiceList.count {
                    selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                    selectAllLabel.text = "Deselect All"
                }
            }
    }
    
    // Table View Download  Buttons
     @objc func tableViewDownloadClick(sender: UIButton!) {
        selectedPdfs = NSMutableArray()
        let selectedPdfsNames = NSMutableArray()
        selectedPdfs.add(staffInvoiceList[sender.tag].generatePdf as Any)
        
        
        let invoiceName = String(format: "%@_%@_%@.pdf", staffInvoiceList[sender.tag].title!, staffInvoiceList[sender.tag].internalIdentifier!,randomString(length: 15))
        selectedPdfsNames.add(invoiceName)
        
        
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                if response == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                }
            }
        }
        
        
        
        
        
//        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//        }
    }
    
    // Table View Share  Buttons
    @objc func tableViewShareClick(sender: UIButton!) {
        selectedPdfs = NSMutableArray()
        selectedPdfs.add(staffInvoiceList[sender.tag].generatePdf as Any)
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
        }
    }
    
    // Table View Resend  Buttons
    @objc func tableViewResendClick(sender: UIButton!) {
        PaymentStore.sharedInstance.resendCampaignInvoice(UserStore.sharedInstance.userInfo, staffInvoiceList[sender.tag].internalIdentifier!) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: Constants.RESEND_SUCCESSFULLY)
            }
            else {
                SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func getCellForView(view:UIView) -> UITableViewCell?
    {
        var superView = view.superview
        
        while superView != nil
        {
            if superView is UITableViewCell
            {
                return superView as? UITableViewCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        
        return nil
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
