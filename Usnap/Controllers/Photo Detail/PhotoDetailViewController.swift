//
//  PhotoDetailViewController.swift
//  Usnap
//
//  Created by CSPC141 on 15/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoDetailViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var commentTextView: UITextField!
    @IBOutlet var topBar: TopBarView!
    @IBOutlet var listViewController: UITableView!
    var topComment = NSArray()
    var bottomComment = NSArray()
    var imagesData = [CompareImageresult]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let closeButtonImage = UIImage(named: "EditIcon")
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(PhotoDetailViewController.barButtonDidTap(_:)))
        
        listViewController.register(UINib(nibName: "PhotoDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoDetailTableViewCell")
        topComment = ["1 - Original Photo", "1 - Commented Photo", "1 Retouched Photo - 1", "1 Retouched Photo - 2"]
        bottomComment = ["", "This is a dummy text", "This is a dummy text", "This is a dummy text"]
//        topBar.delegate = self
        AppUtility.lockOrientation(.all)
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        AppUtility.lockOrientation(.portrait)
//        // Or to rotate and lock
//        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Don't forget to reset when view is being removed
//        AppUtility.lockOrientation(.all)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        getImageDetail()
    }
    
    func getImageDetail()  {
        CampaignStore.sharedInstance.CompareImage(CompletedCampaignStore.sharedInstance.CompletedcampaignImageId) { (response) in
            if response?.compareImageresponse?.status == "1" {
                self.imagesData = (response?.compareImageresponse?.compareImageresult)!
                self.listViewController.reloadData()
            }
        }
    }
    
    @IBAction func postButtonClick(_ sender: Any) {
        
        if commentTextView.text == "" {
            SVProgressHUD.showError(withStatus: Constants.TEXTREQURIED_ERROR)
        }
        else {
            CampaignStore.sharedInstance.CommentOnMedia((imagesData.last?.internalIdentifier!)!, (imagesData.last?.media!)!, commentTextView.text!, CompletedCampaignStore.sharedInstance.CompletedCampaignId) { (response) in
                print(response as Any)
                let responseData = response?["response"] as! NSDictionary
                if responseData["status"] as! String == "1" {
                    self.self.commentTextView.text = ""
                    SVProgressHUD.showSuccess(withStatus: Constants.COMMENT_SUCCESSFULLY)
                } else {
                    SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TopBar Delegate
    
    func backButtonClicked() {
        
    }
    
    func leftButtonClicked1() {
        
    }
    
    @objc func barButtonDidTap(_ sender: UIBarButtonItem) {
        //if imagesData.count == 2 {
            CompletedCampaignStore.sharedInstance.firstImageUrl = imagesData[0].media!
            CompletedCampaignStore.sharedInstance.lastImageUrl = imagesData[imagesData.count - 1].media!
            CampareViewController.showControl()
      //  }
       // else {
           // SVProgressHUD.showError(withStatus: "You have not enough images to compare")
        //}
        
    }
    
    
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoDetailTableViewCell", for: indexPath) as! PhotoDetailTableViewCell
        if  imagesData[indexPath.row].type == "1" {
            cell.topLabel.text = "Original Image"
        }
        if  imagesData[indexPath.row].type == "2" {
            cell.topLabel.text = "Commented Image"
        }
        if  imagesData[indexPath.row].type == "3" {
            cell.topLabel.text = "Retouched Image"
        }
        cell.bottomLabel.text = imagesData[indexPath.row].comment
        let imageString = String(format: "%@%@", APIs.KIMAGEBASEURL, self.imagesData[indexPath.row].media!)

        let urlString = imageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        cell.thumbNailImageView.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: "DummySmallImage"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
