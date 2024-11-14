//
//  PrivacyPolicyViewController.swift
//  Usnap
//
//  Created by CSPC141 on 05/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class PrivacyPolicyViewController: AbstractControl, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var topBarViews: TopBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
              
              let closeButtonImage = UIImage(named: "BackIcon")
                      navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(PrivacyPolicyViewController.barButtonDidTap(_:)))
        
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            setConstaints(item: webView, toItem: self.view.safeAreaLayoutGuide)
        } else {
            setConstaints(item: webView, toItem: self.view)
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
        if let pdfURL = Bundle.main.url(forResource: "Privacy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            do {
                let data = try Data(contentsOf: pdfURL)
                webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfURL.deletingLastPathComponent())
                
                
            }
            catch {
                // catch errors here
            }
            
        }
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
    
    // MARK: - Web view delegates
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
         SVProgressHUD.setDefaultMaskType(.clear)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func setConstaints(item: Any, toItem: Any) {
        NSLayoutConstraint(item: item,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: toItem,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: item,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: toItem,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: item,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: toItem,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: CGFloat(100.0)).isActive = true
        
        NSLayoutConstraint(item: item,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: toItem,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}

