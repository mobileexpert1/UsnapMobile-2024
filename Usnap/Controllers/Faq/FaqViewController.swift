//
//  FaqViewController.swift
//  Usnap
//
//  Created by CSPC141 on 19/01/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class FaqViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var questionTableView: UITableView!
    @IBOutlet weak var topBarViews: TopBarView!
    var questionsArray = [BaseFaqresult]()
    var modelBackUp = [BaseFaqresult]()
    var searchArray = [BaseFaqresult]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredNavBarImageView()
              
              let closeButtonImage = UIImage(named: "BackIcon")
                      navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeButtonImage, style: .plain, target: self, action:  #selector(FaqViewController.barButtonDidTap(_:)))
        
        topBarViews.leftButton1.isUserInteractionEnabled = false
        topBarViews.leftButton2.isUserInteractionEnabled = false
        questionTableView.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
       
        addToolBar(textField: searchBar)
        // Do any additional setup after loading the view.
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
        getQuestions()
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
    
    
    func getQuestions()  {
        MiscStore.sharedInstance.faq(UserStore.sharedInstance.userRole) { (response) in
            if response?.baseFaqresponse?.status == "1" {
                self.questionsArray = (response?.baseFaqresponse?.baseFaqresult)!
                if self.questionsArray.count == 0 {
                    SVProgressHUD.showError(withStatus: Constants.NODATAFOUND_ERROR)
                }
                else {
                    self.modelBackUp = self.questionsArray
                    self.questionTableView.reloadData()
                }
            }
            else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    func addToolBar(textField: UISearchBar) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view Data source and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        let staticString = String(format: "%@ %d.   ", "Question", indexPath.row + 1)
        var boldMutableString = NSMutableAttributedString()
        boldMutableString = NSMutableAttributedString(string: staticString, attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic-Bold", size: 12.0)!])
        boldMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:staticString.count))
        
        // EDIT NORMAL TEXT
        var normalMutableString = NSMutableAttributedString()
        normalMutableString = NSMutableAttributedString(string: questionsArray[indexPath.row].ques! , attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic", size: 10.0)!])
        normalMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:((questionsArray[indexPath.row].ques)?.count)!))
        boldMutableString.append(normalMutableString)
        cell.titleLabel.attributedText = boldMutableString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(FaqAnswersViewController.control(self.questionsArray[indexPath.row]), animated: true)
    }
    
    // MARK: - Search Bar Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        questionsArray = [BaseFaqresult]()
        questionsArray = modelBackUp
        searchArray = [BaseFaqresult]()
        
        if searchText.length != 0 {
            for i in 0..<questionsArray.count {
                if ((questionsArray[i].ques?.lowercased() as! NSString).range(of: searchText.lowercased())).location != NSNotFound {
                    searchArray.append(questionsArray[i])
                }
            }
            questionsArray = [BaseFaqresult]()
            questionsArray = searchArray
        }
        else {
            questionsArray = [BaseFaqresult]()
            questionsArray = modelBackUp
        }
        questionTableView.reloadData()
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
