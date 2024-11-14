//
//  SupportViewController.swift
//  Usnap
//
//  Created by CSPC141 on 08/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SupportViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var supportListView: UITableView!
    @IBOutlet weak var topBarViews: TopBarView!
    
    @IBOutlet weak var backtoHome: UIBarButtonItem!
    
    var supportList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
        backtoHome.target = revealViewController()
        backtoHome.action = #selector(revealViewController()?.revealSideMenu)
        
       topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        
        supportListView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
        supportList = ["Contact Us", "Give Feedback", "Request a Feature", "FAQ", "Learn"]
        supportListView.alwaysBounceVertical = false
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        cell.titleLabel.text = supportList[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(ContactUsViewController.control, animated: true)
            break
        case 1:
            navigationController?.pushViewController(GiveFeedbackViewController.control, animated: true)
            UserStore.sharedInstance.requestStatus = "Give Feedback"
            break
        case 2:
            navigationController?.pushViewController(GiveFeedbackViewController.control, animated: true)
            UserStore.sharedInstance.requestStatus = "Request a Feature"
            break
        case 3:
             navigationController?.pushViewController(FaqViewController.control, animated: true)
            break
        case 4:
            navigationController?.pushViewController(LearnViewController.control, animated: true)
            break
        default:
            print("executed default of switch")
        }
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    

}
