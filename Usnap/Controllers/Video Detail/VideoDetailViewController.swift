//
//  VideoDetailViewController.swift
//  Usnap
//
//  Created by CSPC141 on 16/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class VideoDetailViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var commentTextView: UITextField!
    @IBOutlet var listViewController: UITableView!
    var topComment = NSArray()
    var bottomComment = NSArray()
    var imagesData = [CompareImageresult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewController.register(UINib(nibName: "PhotoDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoDetailTableViewCell")
        topComment = ["1 - Original Video", "1 Retouched Video - 1", "1 Retouched Video - 2"]
        bottomComment = ["This is a dummy text", "This is a dummy text", "This is a dummy text"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        getImageDetail()
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
    
    func getImageDetail()  {
        CampaignStore.sharedInstance.CompareVideos(CompletedCampaignStore.sharedInstance.CompletedcampaignImageId) { (response) in
            if response?.compareImageresponse?.status == "1" {
                self.imagesData = (response?.compareImageresponse?.compareImageresult)!
                self.listViewController.reloadData()
            }
        }
    }
    
    @IBAction func postCommentClick(_ sender: Any) {
        CampaignStore.sharedInstance.CommentOnMedia((imagesData.last?.internalIdentifier!)!, (imagesData.last?.media!)!, commentTextView.text!,  CompletedCampaignStore.sharedInstance.CompletedCampaignId) { (response) in
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoDetailTableViewCell", for: indexPath) as! PhotoDetailTableViewCell
        if  imagesData[indexPath.row].type == "1" {
            cell.topLabel.text = "Original Video"
        }
        if  imagesData[indexPath.row].type == "3" {
            cell.topLabel.text = "Retouched Video"
        }
        cell.topLabel.text = imagesData[indexPath.row].title
        cell.bottomLabel.text = imagesData[indexPath.row].comment
    var urlString = self.imagesData[indexPath.row].media!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        urlString = urlString?.makeThumbnailString(urlString!)
        cell.thumbNailImageView.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: "DummySmallImage"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

