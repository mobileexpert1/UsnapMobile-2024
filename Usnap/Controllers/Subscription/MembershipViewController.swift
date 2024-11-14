//
//  MembershipViewController.swift
//  Usnap
//
//  Created by CSPC141 on 15/06/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class MembershipViewController: AbstractControl, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var plansList: UITableView!
    var packageArray = [MemberShipResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plansList.register(UINib(nibName: "MembershipTableViewCell", bundle: nil), forCellReuseIdentifier: "MembershipTableViewCell")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 0.5 to desired number of seconds
           self.getPlans()
        }
    }
    
    func getPlans()  {
        UserStore.sharedInstance.membership(UserStore.sharedInstance.userInfo) { (response) in
            if response?.memberShipResponse?.status == "1" {
                self.packageArray = (response?.memberShipResponse?.memberShipResult)!
                if self.packageArray.count  == 0 {
                    UIAlertController.showAlert("Alert!", message: Constants.NODATAFOUND_ERROR, buttons: ["OK"], completion: { (alert, index) in
                    })
                }
                else {
                    self.plansList.reloadData()
                }
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
        return packageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipTableViewCell", for: indexPath) as! MembershipTableViewCell
        cell.price.text = packageArray[indexPath.row].name
        cell.desc.text = packageArray[indexPath.row].charges
        if packageArray[indexPath.row].youAreSubscribedTo == "nothing" {
            cell.bgView.addBorderlayer(UIColor.clear)
            cell.price.textColor = UIColor.black
            cell.desc.textColor = UIColor.black
        }
        else {
            cell.bgView.addBorderlayer(pinkBorderColor)
            cell.price.textColor = pinkBorderColor
            cell.desc.textColor = pinkBorderColor
        }
        
        
        //let staticString = String(format: "%@ %d.   ", "Question", indexPath.row + 1)
//        var boldMutableString = NSMutableAttributedString()
//        boldMutableString = NSMutableAttributedString(string: staticString, attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic-Bold", size: 12.0)!])
//        boldMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:staticString.count))
//
//        // EDIT NORMAL TEXT
//        var normalMutableString = NSMutableAttributedString()
//        normalMutableString = NSMutableAttributedString(string: questionsArray[indexPath.row].ques! , attributes: [NSAttributedStringKey.font:UIFont(name: "CenturyGothic", size: 10.0)!])
//        normalMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:((questionsArray[indexPath.row].ques)?.count)!))
//        boldMutableString.append(normalMutableString)
        //cell.titleLabel.text = staticString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  navigationController?.pushViewController(PackageViewController.control, animated: true)
        
   // navigationController?.pushViewController(PackageViewController.control) animated: true)
        
        navigationController?.pushViewController(PackageViewController.control(self.packageArray[indexPath.row]), animated: true)
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
