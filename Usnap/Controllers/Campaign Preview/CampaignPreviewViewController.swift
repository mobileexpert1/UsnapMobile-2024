//
//  CampaignPreviewViewController.swift
//  Usnap
//
//  Created by CSPC141 on 06/03/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class CampaignPreviewViewController: AbstractControl, UITableViewDelegate,UITableViewDataSource, TopBarDelegate {

    @IBOutlet var topBar: TopBarView!
    @IBOutlet var listTableview: UITableView!
    var campaignMediaList = [BaseCampaignMediacampaignMedia]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.delegate = self
        listTableview.register(UINib(nibName: "CampaignPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "CampaignPreviewTableViewCell")

        let button = UIButton(type: .custom)
               button.setImage(UIImage(named: "Tick"), for: .normal)
               button.addTarget(self, action: #selector(RightbButtonPressed), for: .touchUpInside)
               button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
               let barButton = UIBarButtonItem(customView: button)
               self.navigationItem.rightBarButtonItem = barButton
        
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
    
    
    
  
    @objc func RightbButtonPressed(){
        if #available(iOS 13.0, *) {
            navigationController?.pushViewController(HomeViewController.control, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }

   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    fetchMediaDetails()
    }
    
    func fetchMediaDetails()  {
        CreateCampaignStore.sharedInstance.campaignMediaImage(String(NewCampaignDetailStore.sharedInstance.createdCampaignId)) { (response) in
            if response?.baseCampaignMediaresponse?.status == "1" {
                self.campaignMediaList = (response?.baseCampaignMediaresponse?.baseCampaignMediaresult?.baseCampaignMediacampaignMedia)!
                self.listTableview.reloadData()
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
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaignMediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignPreviewTableViewCell", for: indexPath) as! CampaignPreviewTableViewCell
       cell.topImageView.sd_setImage(with: URL(string: "\(APIs.KIMAGEBASEURL)\(self.campaignMediaList[indexPath.row].media!)"), placeholderImage: UIImage(named: "DummySmallImage"))
        cell.commentTextView.text = self.campaignMediaList[indexPath.row].comment!
        if self.campaignMediaList[indexPath.row].type == "p" || self.campaignMediaList[indexPath.row].type == "P" {
            cell.playButton.isHidden = true
        }
        else {
            cell.playButton.isHidden = false
        }
        cell.commentSendButton.addTarget(self, action: #selector(CampaignPreviewViewController.sendTapped(_:)), for: .touchUpInside)
        cell.commentSendButton.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 284
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @objc func sendTapped(_ sender: UIButton?) {
        
 
        
        let indexPath = IndexPath(row: (sender?.tag)!, section: 0)
        let cell = listTableview.cellForRow(at: indexPath) as! CampaignPreviewTableViewCell
        
        
        if cell.commentTextView.text == "" {
            SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
        }
        else {
            CampaignStore.sharedInstance.campaignImageComment(UserStore.sharedInstance.userInfo, String(NewCampaignDetailStore.sharedInstance.createdCampaignId), campaignMediaList[(sender?.tag)! as Int].internalIdentifier!, cell.commentTextView.text, "0") { (response) in
                print(response as Any)
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    SVProgressHUD.showSuccess(withStatus: "Thanks For Comment")
                    self.campaignMediaList[(sender?.tag)! as Int].comment = cell.commentTextView.text
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    // MARK: - Top Bar Delegates
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        
    }
  
    func leftButtonClicked2() {
//        if #available(iOS 13.0, *) {
//            navigationController?.pushViewController(HomeViewController.control, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
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
