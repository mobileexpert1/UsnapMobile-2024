//
//  CampaignInvoiceViewController.swift
//  Usnap
//
//  Created by CSPC141 on 17/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class CampaignInvoiceViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topBars: TopBarView!
    @IBOutlet var campaignTitle: UILabel!
    @IBOutlet var selectAllLabel: UILabel!
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var listView: UITableView!
    var invoiceList = [CompletedCampaignInvoiceresult]()
    var rowsWhichAreChecked = [NSIndexPath]()
    var selectedCells = NSMutableArray()
    
    var selectedPdfs = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBars.leftButton1.isUserInteractionEnabled = false
        topBars.leftButton2.isUserInteractionEnabled = false
        listView.register(UINib(nibName: "InvoiceDateTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoiceDateTableViewCell")
        campaignTitle.text = CompletedCampaignStore.sharedInstance.CompletedCampaignName
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
        getInvoiceList()
    }
    
    @IBAction func selectAllClick(_ sender: Any) {
        if selectedCells.count >= invoiceList.count {
            for i in 0..<invoiceList.count   {
                selectedCells.remove(i)
            }
             selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            selectAllLabel.text = "Select All"
        }
        else {
            for i in 0 ..< invoiceList.count   {
                selectedCells.add(i)
            }
             selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            selectAllLabel.text = "Deselect All"
        }
        
       
        listView.reloadData()
        
    }
    
    func getInvoiceList()  {
        PaymentStore.sharedInstance.getCompletedCampaignInvoice(CompletedCampaignStore.sharedInstance.CompletedCampaignId) { (response) in
            if response?.completedCampaignInvoiceresponse?.status == "1" {
                self.invoiceList = (response?.completedCampaignInvoiceresponse?.completedCampaignInvoiceresult)!
                if self.invoiceList.count == 0 {
                     SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else {
                    self.campaignTitle.text = self.invoiceList[0].title!
                }
                self.listView.reloadData()
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
   // DataDownloadStore.sharedInstance.shareImage
    
    @IBAction func shareClick(_ sender: Any) {
        selectedPdfs = NSMutableArray()
        if selectedCells.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0 ..< selectedCells.count  {
            selectedPdfs.add(invoiceList[i].pdfGenerate as Any)
        }
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
            self.selectedCells.removeAllObjects()
            self.selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            self.selectAllLabel.text = "Select All"
            self.listView.reloadData()
        }
    }
    @IBAction func downloadClick(_ sender: Any) {
        selectedPdfs = NSMutableArray()
      let  selectedPdfsNames = NSMutableArray()
        if selectedCells.count == 0 {
            SVProgressHUD.showError(withStatus: Constants.SELECTEDINVOICE_NULL)
            return
        }
        
        for i in 0..<selectedCells.count {
            selectedPdfs.add(invoiceList[i].pdfGenerate as Any)
            let invoiceName = String(format: "%@_%@_%@.pdf", invoiceList[i].title!, invoiceList[i].internalIdentifier!,randomString(length: 15))
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
                    self.listView.reloadData()
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
//        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
//
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDateTableViewCell", for: indexPath) as! InvoiceDateTableViewCell
        cell.paidBar.isHidden = false
        cell.pendingInvoices.isHidden = true
        cell.invoiceId.text = invoiceList[indexPath.row].internalIdentifier!
        cell.campaignTitle.text = invoiceList[indexPath.row].title!
        cell.amount.text = invoiceList[indexPath.row].amount!
        cell.creationDate.text = invoiceList[indexPath.row].dateOfCreation!.removeTimeFromString(invoiceList[indexPath.row].dateOfCreation!)
        cell.paymentDate.text = invoiceList[indexPath.row].dateOfPayment!.removeTimeFromString(invoiceList[indexPath.row].dateOfPayment!)
        cell.uploadedBy.text = invoiceList[indexPath.row].uploadedBy!
        cell.checkBoxButton.addTarget(self, action: #selector(tableViewCheckBoxClick), for: .touchUpInside)
        cell.paidDownloadButton.addTarget(self, action: #selector(tableViewDownloadClick), for: .touchUpInside)
         cell.paidDownloadButton.tag = indexPath.row
        cell.paidShareButton.addTarget(self, action: #selector(tableViewShareClick), for: .touchUpInside)
        cell.paidShareButton.tag = indexPath.row
        cell.paidResendButton.addTarget(self, action: #selector(tableViewResendClick), for: .touchUpInside)
        cell.paidResendButton.tag = indexPath.row

        cell.checkBoxButton.tag = indexPath.row
        if selectedCells.contains(indexPath.row) {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
        }
        else {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
        }
        
        
//        if(rowsWhichAreChecked.contains(indexPath as NSIndexPath) == false){
//            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
//        }else {
//           cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 224
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    


    
    
    
    
    
    
    
    
    
    
    @objc func tableViewDownloadClick(sender: UIButton!) {
        SVProgressHUD.show()
        selectedPdfs = NSMutableArray()
        let selectedPdfsNames = NSMutableArray()
        selectedPdfs.add(invoiceList[sender.tag].pdfGenerate as Any)
        
        let invoiceName = String(format: "%@_%@_%@.pdf", invoiceList[sender.tag].title!, invoiceList[sender.tag].internalIdentifier!,randomString(length: 15))
        selectedPdfsNames.add(invoiceName)
       
            SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DataDownloadStore.sharedInstance.downloadPdf(self.selectedPdfs, selectedPdfsNames , self) { (response) in
                if response == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Saved Successfully")
                }
            }
        }
  
    }
    

    
    @objc func tableViewShareClick(sender: UIButton!) {
       
        
        
        
        
        selectedPdfs = NSMutableArray()
        selectedPdfs.add(invoiceList[sender.tag].pdfGenerate as Any)
        DataDownloadStore.sharedInstance.shareImage(selectedPdfs, "" , self) { (response) in
        }
    }
    
    @objc func tableViewResendClick(sender: UIButton!) {
        PaymentStore.sharedInstance.resendCampaignInvoice(UserStore.sharedInstance.userInfo, invoiceList[sender.tag].internalIdentifier!) { (response) in
            let responseData = response?["response"] as! NSDictionary
            if responseData["status"] as! String == "1" {
                SVProgressHUD.showSuccess(withStatus: Constants.RESEND_SUCCESSFULLY)
            }
            else {
                SVProgressHUD.showSuccess(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    
    @objc func tableViewCheckBoxClick(sender: UIButton!) {
        let cell = getCellForView(view: sender) as! InvoiceDateTableViewCell
        let indexPath = listView.indexPath(for: cell)
     
        if selectedCells.contains(indexPath?.row as Any) {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            self.selectedCells.remove(indexPath?.row as Any)
            selectAllButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
            selectAllLabel.text = "Select All"
           
        }
        
        else {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
            selectedCells.add(indexPath?.row as Any)
            
            if selectedCells.count >= invoiceList.count {
                selectAllButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
                selectAllLabel.text = "Deselect All"
            }
        }
        
        
//        if(rowsWhichAreChecked.contains(indexPath! as NSIndexPath) == false){
//            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOn"), for: .normal)
//            rowsWhichAreChecked.append(indexPath! as NSIndexPath)
//        }else{
//            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "RadioOff"), for: .normal)
//            // remove the indexPath from rowsWhichAreCheckedArray
//            if let checkedItemIndex = rowsWhichAreChecked.index(of: indexPath! as NSIndexPath){
//                rowsWhichAreChecked.remove(at: checkedItemIndex)
//            }
//        }
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
