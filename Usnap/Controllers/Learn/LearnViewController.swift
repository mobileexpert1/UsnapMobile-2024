//
//  LearnViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/06/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import youtube_ios_player_helper
import SVProgressHUD

class LearnViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, YTPlayerViewDelegate {
    @IBOutlet weak var topBarViews: TopBarView!
    @IBOutlet var tableView: UITableView!
    var learnResponse = [Learnresult]()
    var readyVideoCount = Int()
    @IBOutlet var youtubePlayer: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
              
              let closeButtonImage = UIImage(named: "BackIcon")
                      navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(LearnViewController.barButtonDidTap(_:)))
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        tableView.register(UINib(nibName: "LearnTableViewCell", bundle: nil), forCellReuseIdentifier: "LearnTableViewCell")
        fetchData()
        readyVideoCount = 0
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
    
    
    
    func fetchData()  {
        MiscStore.sharedInstance.learn { (response) in
            if response?.learnresponse?.status == "1" {
                self.learnResponse = (response?.learnresponse?.learnresult)!
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Delegates

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.learnResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LearnTableViewCell", for: indexPath) as! LearnTableViewCell
        cell.titleLabel.text = self.learnResponse[indexPath.row].learnTittle
        
        let playerVars:[NSObject:AnyObject] = [
            "playsinline" as NSObject:0 as AnyObject,
            "autoplay" as NSObject : 0 as AnyObject,
            "modestbranding" as NSObject : 1 as AnyObject
        ]
        
        let aString = self.learnResponse[indexPath.row].videoId!
        let newString = aString.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        
        cell.videoPlayer.load(withVideoId: newString, playerVars: playerVars)
        cell.videoPlayer.delegate = self;
        
//        cell.videoThumbnail.sd_setImage(with: URL(string:  self.learnResponse[indexPath.row].thumbnail!), placeholderImage: UIImage(named: "DummySmallImage"))
//        cell.playVideo.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
//        cell.playVideo.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }

    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        readyVideoCount = readyVideoCount + 1
        if readyVideoCount == self.learnResponse.count {
            SVProgressHUD.dismiss()
        }
    }
    
    @objc func playButtonTapped(sender: UIButton!) {
        youtubePlayer.isHidden = false
       // youtubePlayer.load(withVideoId: "M7lc1UVf-VE")
//        let playerVars = ["playsinline": 1]
        
        let playerVars:[NSObject:AnyObject] = [
            "playsinline" as NSObject:0 as AnyObject,
            "autoplay" as NSObject : 0 as AnyObject,
            "modestbranding" as NSObject : 1 as AnyObject
        ]
        
       youtubePlayer.load(withVideoId: "M7lc1UVf-VE", playerVars: playerVars)
       // youtubePlayer.playVideo()
        
//        let url = NSURL(string: String(format: "%@", learnResponse[sender.tag].learnLink!))
//        let player = AVPlayer(url: url! as URL as URL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
    }
}
