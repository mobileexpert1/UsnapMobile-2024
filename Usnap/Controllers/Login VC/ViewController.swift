//
//  ViewController.swift
//  Usnap
//
//  Created by Mobile on 20/12/17.
//  Copyright © 2017 Bikramjit Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKMarketingKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

@available(iOS 13.0, *)
class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var loginData : LoginResponse! = nil
    var dictUserInfo = [String:Any]()
    
    @IBOutlet var forgotButton: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var thoughtLabel: UILabel!
    @IBOutlet var happyDayLabel: UILabel!
    @IBOutlet var loadingGif: UIImageView!
    @IBOutlet weak var facebookHeight: NSLayoutConstraint!
    @IBOutlet weak var googleHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        facebookHeight.constant = 0
        googleHeight.constant = 0
        setUI()
        
        //        if UserStore.sharedInstance.installedFirstTime == "" {
        //            UIAlertController.showAlert("", message: "Dummy text", buttons: ["OK"], completion: { (alert, index) in
        //                if index == 0 {
        //                   UserStore.sharedInstance.installedFirstTime = "Yes"
        //                } else {
        //                }
        //            })
        //        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    func setUI() {
        happyDayLabel.text = String(format: "%@ %@!", "Happy", DateStore.sharedDate.fetchLocalDay())
        userNameTF.addLeftImage(UIImage(named: "UserIcon")!)
        passwordTF.addLeftImage(UIImage(named: "PasswordIcon")!)
        userNameTF.addBottomLabel(UIColor.lightGray)
        passwordTF.addBottomLabel(UIColor.lightGray)
        forgotButton.addBottomLabel(UIColor.lightGray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func contactUs(_ sender: Any) {
        navigationController?.pushViewController(ContactUsViewController.control, animated: true)
        
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance().scopes = ["https://www.google.com/m8/feeds","https://www.googleapis.com/auth/contacts.readonly"]
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let urlString = "https://www.google.com/m8/feeds/contacts/default/full?access_token=\(user.authentication.accessToken!)"
            dictUserInfo = [String:Any]()
            dictUserInfo["email"] = user.profile.email
            dictUserInfo["userId"] = user.userID                  // For client-side use only!
            dictUserInfo["idToken"] = user.authentication.idToken // Safe to send to the server
            dictUserInfo["fullName"] = user.profile.name
            dictUserInfo["givenName"] = user.profile.givenName
            dictUserInfo["familyName"] = user.profile.familyName
            dictUserInfo["accessToken"] = user.authentication.accessToken
            Alamofire.request(urlString, method: .get)
                .responseString { (data) in
                    self.socialMediaLogin(user.profile.email, "google", user.userID , user.profile.givenName, user.profile.familyName, Locale.current.regionCode!)
                }
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    print(result)
                    var dict : [String : AnyObject]!
                    dict = (result as! [String : AnyObject])
                    var getFacebookUniqueid = String()
                    
                    if let _ = dict["email"] {
                        getFacebookUniqueid = dict["email"] as! String
                    }
                    else {
                        getFacebookUniqueid = ""
                    }
                    
                    self.socialMediaLogin(getFacebookUniqueid, "facebook", dict["id"] as! String, dict["first_name"] as! String, dict["last_name"] as! String, Locale.current.regionCode!)
                    
                }
            })
        }
    }
    
    
    func socialMediaLogin(_ email: String, _ socailType: String, _ socailId: String, _ firstName: String, _ lastName: String, _ country: String)  {
        UserStore.sharedInstance.requestSocialLogin(email, socailType, socailId, firstName, lastName, country, completion: { (resposne) in
            if resposne?.loginResponse?.status == "1" {
                // UserStore.sharedInstance.userInfo = (resposne?.loginResponse?.loginResult![0].userRoleId)!
                var userIdArray = NSArray()
                userIdArray = (resposne?.loginResponse?.loginResult![0].userRoleId?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].userRoleId)!))!
                
                var roleArray = NSArray()
                roleArray = (resposne?.loginResponse?.loginResult![0].roles?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].roles)!))!
                UserStore.sharedInstance.userDetails = (resposne?.loginResponse?.loginResult![0])!
                if roleArray.count == 2 {
                    self.chooseRole(roleArray[0] as! String, roleArray[1] as! String, userIdArray)
                }
                else
                {
                    UserStore.sharedInstance.userInfo = (resposne?.loginResponse?.loginResult![0].userRoleId)!
                    UserStore.sharedInstance.userRole = (resposne?.loginResponse?.loginResult![0].roles)!
                    //                    self.navigationController?.pushViewController(HomeViewController .control, animated: true)
                    self.home()
                }
            }
            
            else if resposne?.loginResponse?.status == "2" {
                UIAlertController.showAlert("Alert!", message: "you will be able to login once admin will approve your request", buttons: ["OK"], completion: { (alert, index) in
                })
            }
            
            else if resposne?.loginResponse?.status == "3" {
                UIAlertController.showAlert("Alert!", message: "Please verify your email first", buttons: ["OK"], completion: { (alert, index) in
                })
            }
            
            else if resposne?.loginResponse?.status == "4" {
                UIAlertController.showAlert("Alert!", message: "Your account is blocked by Admin", buttons: ["OK"], completion: { (alert, index) in
                })
            }
            
            else {
                SVProgressHUD.showError(withStatus: Constants.WRONGIDANDPASSWORD_ERROR)
            }
            self.loginData = resposne?.loginResponse
            
        })
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        if (userNameTF.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Email are required")
            return
        }
        
        else  if (passwordTF.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "password are required")
            return
        }
        
        else if userNameTF.isValidEmail {
            UserStore.sharedInstance.requestLogin(userNameTF.text!, passwordTF.text!, completion: { (resposne) in
                print(resposne)
                
                if resposne?.loginResponse?.status == "1" {
                    // UserStore.sharedInstance.userInfo = (resposne?.loginResponse?.loginResult![0].userRoleId)!
                    
                    var userIdArray = NSArray()
                    userIdArray = (resposne?.loginResponse?.loginResult![0].userRoleId?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].userRoleId)!))!
                    
                    var roleArray = NSArray()
                    roleArray = (resposne?.loginResponse?.loginResult![0].roles?.seprateRoleStrings((resposne?.loginResponse?.loginResult![0].roles)!))!
                    UserStore.sharedInstance.userDetails = (resposne?.loginResponse?.loginResult![0])!
                    if roleArray.count == 2 {
                        self.chooseRole(roleArray[0] as! String, roleArray[1] as! String, userIdArray)
                    }
                    else
                    {
                        UserStore.sharedInstance.userInfo = (resposne?.loginResponse?.loginResult![0].userRoleId)!
                        UserStore.sharedInstance.userRole = (resposne?.loginResponse?.loginResult![0].roles)!
                        //                        self.navigationController?.pushViewController(HomeViewController .control, animated: true)
                        self.home()
                    }
                }
                
                else if resposne?.loginResponse?.status == "2" {
                    UIAlertController.showAlert("Alert!", message: "you will be able to login once admin will approve your request", buttons: ["OK"], completion: { (alert, index) in
                    })
                }
                
                else if resposne?.loginResponse?.status == "3" {
                    UIAlertController.showAlert("Alert!", message: "Please verify your email first", buttons: ["OK"], completion: { (alert, index) in
                    })
                }
                
                else if resposne?.loginResponse?.status == "4" {
                    UIAlertController.showAlert("Alert!", message: "This email is not registered", buttons: ["OK"], completion: { (alert, index) in
                    })
                }
                
                else {
                    SVProgressHUD.showError(withStatus: Constants.WRONGIDANDPASSWORD_ERROR)
                }
                self.loginData = resposne?.loginResponse
            })
        }
        else {
            SVProgressHUD.showError(withStatus: Constants.EMAILVALIDATION_ERROR)
        }
    }
    
    func home() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") 
        self.navigationController?.pushViewController(controller, animated: true)
//        SlideNavigationController.sharedInstance().leftMenu = controller
        //  var viewController = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController")
        var viewController = UIViewController()
        if UserStore.sharedInstance.userInfo == "logout" || UserStore.sharedInstance.userInfo == ""  {
            viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        }
        else {
            viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        }
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: viewController, withCompletion: nil)
    }
    
    func chooseRole(_ role1: String, _ role2: String, _ userID: NSArray)   {
        let alertController = UIAlertController(title: "", message: "SELECT YOUR ROLE", preferredStyle: .actionSheet)
        var roleName1 = String()
        if role1 == "1" {
            roleName1 = "Admin"
        }
        if role1 == "2" {
            roleName1 = "Retoucher"
        }
        if role1 == "3" {
            roleName1 = "Corporator"
        }
        if role1 == "4" {
            roleName1 = "Staff"
        }
        if role1 == "5" {
            roleName1 = "General"
        }
        
        var roleName2 = String()
        if role2 == "1" {
            roleName2 = "Admin"
        }
        if role2 == "2" {
            roleName2 = "Retoucher"
        }
        if role2 == "3" {
            roleName2 = "Corporator"
        }
        if role2 == "4" {
            roleName2 = "Staff"
        }
        if role2 == "5" {
            roleName2 = "General"
        }
        
        let action1 = UIAlertAction(title: roleName1, style: .default) { (action) in
            UserStore.sharedInstance.userInfo = userID[0] as! String
            UserStore.sharedInstance.userRole = role1
            self.navigationController?.pushViewController(MediaCollectionViewController.control, animated: true)
        }
        let action2 = UIAlertAction(title: roleName2, style: .default) { (action) in
            UserStore.sharedInstance.userInfo = userID[1] as! String
            UserStore.sharedInstance.userRole = role2
            self.navigationController?.pushViewController(MediaCollectionViewController.control, animated: true)
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = loginBtn
            popoverPresentationController.sourceRect = loginBtn.bounds
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func registerClick(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController.control, animated: true)
    }
    
    @IBAction func forgotClick(_ sender: Any) {
        navigationController?.pushViewController(ForgotPasswordViewController.control, animated: true)
    }
}


