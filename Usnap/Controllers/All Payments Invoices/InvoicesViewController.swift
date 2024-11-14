//
//  InvoicesViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class InvoicesViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, TopBarDelegate, invoiceFilterDelegate {
    func invoiceFilter(_ data : NSDictionary, _ clearButton: String) {
        if  clearButton == "Yes" {
           getInvoices()
        } else {
           getInvoicesFilter(UserStore.sharedInstance.userInfo, data["campaignCategoryId"] as! String, data["campaignName"] as! String, data["status"] as! String,  data["staffMemberName"] as! String, data["startDate"] as! String, data["endDate"] as! String)
        }
    }
    
    @IBOutlet var selectAllLabel: UILabel!
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet weak var paralaxViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var pendingButtonsBar: UIView!
    @IBOutlet weak var paidButtonsBar: UIView!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var invoicePendingButton: UIButton!
    @IBOutlet var invoicePaidButton: UIButton!
    @IBOutlet var invoicesList: UITableView!
    var invoiceType = String()
    var paidInvoices = [AllInvoicespaid]()
    var pendingInvoices = [AllInvoicespending]()
    var rowsWhichAreChecked = [NSIndexPath]()
    var selectedCells_Paid = NSMutableArray()
    var selectedCells_Pending = NSMutableArray()
    var selectedPdfs = NSMutableArray()
    var selectedInvoicesId = NSMutableArray()
    //let delegateMethod = StaffInvoiceFIlterPopUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeButtonImage = UIImage(named: "EditIcon")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(InvoicesViewController.barButtonDidTap(_:)))
        
        invoicesList.register(UINib(nibName: "InvoiceDateTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceDateTableViewCell")
        topBar.delegate = self
        invoiceType = "Paid"
        getInvoices()
        setUI()
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
    
    func setUI()  {
        invoicePaidButton.addBorder(pinkBorderColor)
        invoicePendingButton.addBorder(pinkBorderColor)
        invoicePaidButton.isEnabled = true
        invoicePaidButton.isEnabled = true
        paidButtonsBar.isHidden = false
        pendingButtonsBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func getInvoicesFilter(_ user_id: String, _ catagory_id: String, _ title: String, _ status: String, _ staff_name: String, _ strdate: String, _ enddate: String)  {
        PopUpApiStore.sharedInstance.allInvoiceWithFilters(user_id, catagory_id, title, status, staff_name, strdate, enddate) { (response) in
            if response?.allInvoicesresponse?.status == "1" {
                self.paidInvoices = (response?.allInvoicesresponse?.allInvoicesresult?.allInvoicespaid)!
                if self.paidInvoices.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                self.pendingInvoices = (response?.allInvoicesresponse?.allInvoicesresult?.allInvoicespending)!
                self.invoicesList.reloadData()
            }
        }
    }
    
    func getInvoices() {
        PaymentStore.sharedInstance.allInvoice(UserStore.sharedInstance.userInfo) { (response) in
            if response?.allInvoicesresponse?.status == "1" {
                self.paidInvoices = (response?.allInvoicesresponse?.allInvoicesresult?.allInvoicespaid)!
                if self.paidInvoices.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                self.pendingInvoices = (response?.allInvoicesresponse?.allInvoicesresult?.allInvoicespending)!
                self.invoicesList.reloadData()
            }
        }
    }
    
    @IBAction func editCreditCard(_ sender: Any) {
        navigationController?.pushViewController(CreditCardDetailsViewController.control, animated: true)
    }
    
    
    @IBAction func paidInvoices(_ sender: Any) {
        invoiceType = "Paid"
        paidButtonsBar.isHidden = false
        pendingButtonsBar.isHidden = true
        invoicePendingButton.backgroundColor = UIColor.white
        invoicePaidButton.backgroundColor = solidPinkBorderColor
       // invoicePendingButton.titleLabel?.textColor = UIColor.black
         invoicePaidButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        invoicePendingButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        invoicesList.reloadData()
        if paidInvoices.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
            return
        }
        if selectedCells_Paid.count >= paidInvoices.count {
            for i in 0 ..< paidInvoices.count  {
                selectedCells_Paid.add(i)
            }
            selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            selectAllLabel.text = "Deselect All"
        }
        else {
            selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            selectAllLabel.text = "Select All"
        }
    }
    
    @IBAction func pendingInvoices(_ sender: Any) {
        invoiceType = "Pending"
        paidButtonsBar.isHidden = true
        pendingButtonsBar.isHidden = false
        invoicePaidButton.backgroundColor = UIColor.white
        invoicePendingButton.backgroundColor = solidPinkBorderColor
        invoicePaidButton.titleLabel?.textColor = UIColor.black
        //invoicePendingButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        invoicePaidButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        invoicePendingButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        invoicesList.reloadData()
        if pendingInvoices.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
            return
        }
        
        if selectedCells_Pending.count  == 0 {
            selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            selectAllLabel.text = "Select All"
        }
        else {
            if selectedCells_Pending.count >= pendingInvoices.count {
                for i in 0 ..< pendingInvoices.count {
                    selectedCells_Pending.add(i)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectAllLabel.text = "Deselect All"
            }
            else {
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
        }
    }
   
    // MARK: - Top Bar Delegates
    
    func leftButtonClicked1() {
       
    }
    
    func leftButtonClicked2() {
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
      
        
        let control = StaffInvoiceFIlterPopUpViewController.control as! StaffInvoiceFIlterPopUpViewController
        control.delegate = self
    present(control, animated: false, completion: nil)

    }
    
    func backButtonClicked() {
        
    }
    
    func data(_ data: NSDictionary) {
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if invoiceType == "Paid" {
        return paidInvoices.count
        }
       return pendingInvoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDateTableViewCell", for: indexPath) as! InvoiceDateTableViewCell
        if invoiceType == "Paid" {
            cell.paidBar.isHidden = false
            cell.pendingInvoices.isHidden = true
            cell.invoiceId.text = paidInvoices[indexPath.row].internalIdentifier
            cell.campaignTitle.text = paidInvoices[indexPath.row].title
            cell.amount.text = paidInvoices[indexPath.row].amount
            cell.creationDate.text = paidInvoices[indexPath.row].dateOfCreation?.removeTimeFromString(paidInvoices[indexPath.row].dateOfCreation!)
            cell.paymentDate.text = paidInvoices[indexPath.row].dateOfPayment?.removeTimeFromString(paidInvoices[indexPath.row].dateOfPayment!)
            cell.uploadedBy.text = paidInvoices[indexPath.row].uploadedBy
        }
        if invoiceType == "Pending" {
            cell.paidBar.isHidden = true
            cell.pendingInvoices.isHidden = false
            cell.invoiceId.text = pendingInvoices[indexPath.row].internalIdentifier
            cell.campaignTitle.text = pendingInvoices[indexPath.row].title
            cell.amount.text = pendingInvoices[indexPath.row].amount
            cell.creationDate.text = pendingInvoices[indexPath.row].dateOfCreation?.removeTimeFromString(pendingInvoices[indexPath.row].dateOfCreation!)
            cell.paymentDate.text = pendingInvoices[indexPath.row].dateOfPayment?.removeTimeFromString(pendingInvoices[indexPath.row].dateOfPayment!)
            cell.uploadedBy.text = pendingInvoices[indexPath.row].uploadedBy
        }

        cell.checkBoxButton.addTarget(self, action: #selector(tableViewCheckBoxClick), for: .touchUpInside)
        cell.checkBoxButton.tag = indexPath.row
        
        
        // Paid Buttons
        cell.paidDownloadButton.addTarget(self, action: #selector(tableViewDownloadClickPaid), for: .touchUpInside)
        cell.paidDownloadButton.tag = indexPath.row
        
        cell.paidShareButton.addTarget(self, action: #selector(tableViewShareClickPaid), for: .touchUpInside)
        cell.paidShareButton.tag = indexPath.row
        
        cell.paidResendButton.addTarget(self, action: #selector(tableViewResendClickPaid), for: .touchUpInside)
        cell.paidResendButton.tag = indexPath.row
        
        
        // Pending Buttons
        cell.pendingDownloadButton.addTarget(self, action: #selector(tableViewDownloadClickPaid), for: .touchUpInside)
        cell.pendingDownloadButton.tag = indexPath.row
        
        
        cell.pendingShareButton.addTarget(self, action: #selector(tableViewShareClickPaid), for: .touchUpInside)
        cell.pendingShareButton.tag = indexPath.row
        
        
        cell.pendingResendButton.addTarget(self, action: #selector(tableViewResendClickPaid), for: .touchUpInside)
        cell.pendingResendButton.tag = indexPath.row
        
        cell.pendingPayNowButton.addTarget(self, action: #selector(tableViewPayNowClick), for: .touchUpInside)
        cell.pendingPayNowButton.tag = indexPath.row
        
       
      
        if invoiceType == "Paid" {
            if selectedCells_Paid.contains(indexPath.row) {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            }
            else {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            }
        }
        else {
            if selectedCells_Pending.contains(indexPath.row) {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            }
            else {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            }
 }

        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 224
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func selectAllClick(_ sender: Any) {
        if invoiceType == "Paid" {
            if selectedCells_Paid.count >= paidInvoices.count {
                for i in 0 ..< paidInvoices.count   {
                    selectedCells_Paid.remove(i)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
            else {
                for i in 0 ..< paidInvoices.count  {
                    selectedCells_Paid.add(i)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectAllLabel.text = "Deselect All"
            }
        }
        
        // For pending services
        else {
            if selectedCells_Pending.count >= pendingInvoices.count {
                for i in 0 ..< pendingInvoices.count  {
                    selectedCells_Pending.remove(i)
                    selectedInvoicesId.remove(pendingInvoices[i].internalIdentifier as Any)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
            else {
                for i in 0 ..< pendingInvoices.count   {
                    selectedCells_Pending.add(i)
                    selectedInvoicesId.add(pendingInvoices[i].internalIdentifier as Any)
                }
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectAllLabel.text = "Deselect All"
            }
        }
        invoicesList.reloadData()
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
    
    
    // Paid Table view Buttons Clicks
    @objc func tableViewDownloadClickPaid(sender: UIButton!) {
        selectedPdfs = NSMutableArray()
        let selectedPdfsNames = NSMutableArray()
        
        
        if invoiceType == "Paid" {
            selectedPdfs.add(paidInvoices[sender.tag].generatedPdf as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", paidInvoices[sender.tag].title!, paidInvoices[sender.tag].internalIdentifier!,randomString(length: 15))
            selectedPdfsNames.add(invoiceName)
            
            
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                    if response == "1" {
                        SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                    }
                }
            }

            
            
            
            
            
//            DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//            }
        }
        else {
            selectedPdfs.add(pendingInvoices[sender.tag].generatedPdf as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", pendingInvoices[sender.tag].title!, pendingInvoices[sender.tag].internalIdentifier!,randomString(length: 15))
            selectedPdfsNames.add(invoiceName)
            
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                    if response == "1" {
                        SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                    }
                }
            }
            
            
            
            
//            DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//            }
        }
        
    }
    
    @objc func tableViewShareClickPaid(sender: UIButton!) {
        selectedPdfs = NSMutableArray()
        if invoiceType == "Paid" {
            selectedPdfs.add(paidInvoices[sender.tag].generatedPdf as Any)
            DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            }
        }
        else {
            selectedPdfs.add(pendingInvoices[sender.tag].generatedPdf as Any)
            DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            }
        }
    }
    
    @objc func tableViewResendClickPaid(sender: UIButton!) {
        if invoiceType == "Paid" {
            PaymentStore.sharedInstance.resendCampaignInvoice(UserStore.sharedInstance.userInfo, paidInvoices[sender.tag].internalIdentifier!) { (response) in
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: Constants.RESEND_SUCCESSFULLY)
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
        else {
            PaymentStore.sharedInstance.resendCampaignInvoice(UserStore.sharedInstance.userInfo, pendingInvoices[sender.tag].internalIdentifier!) { (response) in
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: Constants.RESEND_SUCCESSFULLY)
                }
                else {
                    SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    @objc func tableViewPayNowClick(sender: UIButton!) {
        PaymentStore.sharedInstance.payInvoiceNow(UserStore.sharedInstance.userInfo, pendingInvoices[sender.tag].internalIdentifier!) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                self.selectedInvoicesId.remove(self.pendingInvoices[sender.tag].internalIdentifier!)
                SVProgressHUD.showSuccess(withStatus: Constants.INVOICEPAID_SUCCESSFULLY)
                self.getInvoices()
            } else {
                SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    // Table View Radio Buttons
    @objc func tableViewCheckBoxClick(sender: UIButton!) {
        let cell = getCellForView(view: sender) as! InvoiceDateTableViewCell
        let indexPath = invoicesList.indexPath(for: cell)
        
        // FOR PAID SECTION
        if invoiceType == "Paid" {
            if selectedCells_Paid.contains(indexPath?.row as Any) {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                self.selectedCells_Paid.remove(indexPath?.row as Any)
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
            }
            else {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectedCells_Paid.add(indexPath?.row as Any)
                if selectedCells_Paid.count >= paidInvoices.count {
                    selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                    selectAllLabel.text = "Deselect All"
                }
            }
        }
        
        // FOR PENDING SECTION
         if invoiceType == "Pending" {
            if selectedCells_Pending.contains(indexPath?.row as Any) {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                self.selectedCells_Pending.remove(indexPath?.row as Any)
                selectedInvoicesId.remove(pendingInvoices[(indexPath?.row)!].internalIdentifier!)
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                selectAllLabel.text = "Select All"
                
            }
            else {
                cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectedCells_Pending.add(indexPath?.row as Any)
                selectedInvoicesId.add(pendingInvoices[(indexPath?.row)!].internalIdentifier!)
                if selectedCells_Pending.count >= pendingInvoices.count {
                    selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                    selectAllLabel.text = "Deselect All"
                }
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

    
    @IBAction func paidShareButton(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        if selectedCells_Paid.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells_Paid.count {
            selectedPdfs.add(paidInvoices[i].generatedPdf as Any)
        }
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            self.selectedCells_Paid.removeAllObjects()
            self.selectedCells_Pending.removeAllObjects()
            self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            self.selectAllLabel.text = "Select All"
            self.invoicesList.reloadData()
        }
    }
    
    @IBAction func paidDownloadButton(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        let selectedPdfsNames = NSMutableArray()
        
        if selectedCells_Paid.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells_Paid.count {
            selectedPdfs.add(paidInvoices[i].generatedPdf as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", paidInvoices[i].title!, paidInvoices[i].internalIdentifier!,randomString(length: 15))
            selectedPdfsNames.add(invoiceName)
        }
        
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                if response == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                    self.selectedCells_Paid.removeAllObjects()
                     self.selectedCells_Pending.removeAllObjects()
                     self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                     self.selectAllLabel.text = "Select All"
                     self.invoicesList.reloadData()
                }
            }
        }
        
        
        
        
//        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//
//        }
    }
    
    @IBAction func pendingShareButton(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        if selectedCells_Pending.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells_Pending.count {
            selectedPdfs.add(pendingInvoices[i].generatedPdf as Any)
        }
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            self.selectedCells_Paid.removeAllObjects()
            self.selectedCells_Pending.removeAllObjects()
            self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            self.selectAllLabel.text = "Select All"
            self.invoicesList.reloadData()
        }
    }
    @IBAction func pendingDownloadButton(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        let selectedPdfsNames = NSMutableArray()
        
        if selectedCells_Pending.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells_Pending.count {
            selectedPdfs.add(pendingInvoices[i].generatedPdf as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", pendingInvoices[i].title!, pendingInvoices[i].internalIdentifier!,randomString(length: 15))
            selectedPdfsNames.add(invoiceName)
        }
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                if response == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                    self.selectedCells_Paid.removeAllObjects()
                    self.selectedCells_Pending.removeAllObjects()
                    self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                    self.selectAllLabel.text = "Select All"
                    self.invoicesList.reloadData()
                }
            }
        }
        
        
//        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//
//        }
    }

    @IBAction func pendingPayNowButton(_ sender: Any) {
        
        
        UIAlertController.notifyUser("Alert!", message: "Are You Sure", alertButtonTitles: ["Yes", "No"], alertButtonStyles: [.default,.default,.cancel], vc: self, completion: { indexOfTappedButton in
            if indexOfTappedButton  == 0 {
                if self.selectedInvoicesId.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
                    return
                }
                var stringArray = String()
                stringArray = (self.selectedInvoicesId.map{String(describing: $0)}).joined(separator: ",")
                PaymentStore.sharedInstance.payInvoiceNow(UserStore.sharedInstance.userInfo, stringArray) { (response) in
                    
                    self.selectedCells_Paid.removeAllObjects()
                    self.selectedCells_Pending.removeAllObjects()
                    self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
                    self.selectAllLabel.text = "Select All"
                    self.invoicesList.reloadData()
                    
                    let responseData = response?["response"] as! NSDictionary
                    if responseData["status"] as! String == "1" {
                        
                        self.getInvoices()
                        SVProgressHUD.showSuccess(withStatus: Constants.INVOICEPAID_SUCCESSFULLY)
                    }
                    else {
                        SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
                    }
                }
            }
            else {
                
            }
            
        })
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

