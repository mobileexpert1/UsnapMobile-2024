
//  AppDelegate.swift
//  Usnap
//
//  Created by Mobile on 20/12/17.
//  Copyright © 2017 Bikramjit Singh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import SVProgressHUD
import Fabric
import Crashlytics
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import UserNotifications
import UserNotificationsUI
import FBSDKCoreKit
import GoogleSignIn

//https://developer.apple.com/documentation/imageio/cgimagepropertyorientation


//apple development store
//usnapgeneral@gmail.com
//Peterdj84


@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    //MARK:- Declare Varibles
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    //MARK:- Supported Interface Orientations For window
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    //MARK:- Did Finish Launching With Options
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
          
        UITextViewWorkaround.unique.executeWorkaround()

        
        IQKeyboardManager.sharedManager().enable = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        
        var viewController = UIViewController()
        if UserStore.sharedInstance.userInfo == "logout" || UserStore.sharedInstance.userInfo == ""  {
            viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        }
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: viewController, withCompletion: nil)
        SlideNavigationController.sharedInstance().navigationBar.isHidden = true
        SlideNavigationController.sharedInstance().navigationBar.frame = CGRect(x: 0, y: 0, width: (self.window?.frame.size.width)!, height: 0.0)
        
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = redViewController
       
        
        UIApplication.shared.statusBarStyle = .default
        
        
        //var viewController = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController")
        
        //if #available(iOS 13.0, *) {let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        //statusBar.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
        //UIApplication.shared.keyWindow?.addSubview(statusBar)
        //} else {
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
        //}
        
        MiscDetailStore.sharedInstance.statusArray = ["Pending", "paid"]
        
        getCatagories()
        
        Fabric.with([Crashlytics.self])
        
        logUser()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCTWyio6YswcpcNgJU1kyRYkvWee0UThes")
        GMSServices.provideAPIKey("AIzaSyCTWyio6YswcpcNgJU1kyRYkvWee0UThes")
        
         //Register for notification
        registerForNotifications(application: application)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        //Google login
        GIDSignIn.sharedInstance().clientID = "292406952129-i96fdl2p61617s85492ti3db2u33l8j4.apps.googleusercontent.com"
        
        //Facebook login
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //f74c6d22bff083b826cc5048849d35a8996fc48a
        
        //GMSPlacesClient.provideAPIKey("AIzaSyCF3z9bSb4_E2TwNaeQQwqjIg492EkP3PQ")
        //GMSServices.provideAPIKey("AIzaSyCF3z9bSb4_E2TwNaeQQwqjIg492EkP3PQ")
        return true
    }
    
    //MARK:- Switch Controllers
    func switchControllers(viewControllerToBeDismissed: UIViewController, controllerToBePresented: UIViewController){
        if (viewControllerToBeDismissed.isViewLoaded && (viewControllerToBeDismissed.view.window != nil)) {
            // viewControllerToBeDismissed is visible
            //First dismiss and then load your new presented controller
            viewControllerToBeDismissed.dismiss(animated: false, completion: {
                self.window?.rootViewController?.present(controllerToBePresented, animated: true, completion: nil)
            })} else { }
    }
    
    //MARK: Register for push notifications
    func registerForNotifications(application: UIApplication) {
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        center.delegate = self
                        UIApplication.shared.registerForRemoteNotifications()
                    }}}
            center.delegate = self
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        application.registerForRemoteNotifications()
    }
    
    //MARK:- Register remote notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Token = ",token)
        UserStore.sharedInstance.deviceToken = token
    }
    
    
    //MARK:- Open url Method
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        // Add any custom logic here.
        return handled
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    }
    
    //MARK:- Did Fail To Register For Remote Notifications With Error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    
    //MARK:- Handel push notification in forground
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        manageNotiData(notification.request.content.userInfo)
    }

   
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification Response = ",response.notification.request.content.userInfo)
        let aps = response.notification.request.content.userInfo[AnyHashable("aps")] as? NSDictionary
        print("Notification Response = ",aps!)
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print("Message Closed")
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("App is Open")
        }
        
        // When clicked on campaign
        if aps!["type"] as! String == "campaign_created" {
            if UIApplication.visibleViewController is CampaignDetailViewController {
            } else {
                NewCampaignDetailStore.sharedInstance.createdCampaignId = Int(aps!["id"] as! String)!
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "CampaignDetailViewController") as! CampaignDetailViewController
                rootViewController.pushViewController(profileViewController, animated: true)
            }
        }
        
        // When clicked on message
        if aps!["type"] as! String == "message" {
            if UIApplication.visibleViewController is MessagingViewController {
            }  else {
                LocalMessageStore.sharedInstance.chatCampaignId = aps!["id"] as! String
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "MessagingViewController") as! MessagingViewController
                rootViewController.pushViewController(profileViewController, animated: true)
            }
        }
        
        // When clicked on additional service
        if aps!["type"] as! String == "additional_service_request" {
            if UIApplication.visibleViewController is AdditionalServicesViewController {
            } else {
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
        rootViewController.pushViewController(AdditionalServicesViewController.Control(LocalCampaignStore.init( aps!["id"] as! String)), animated: true)
            }
        }
        
        // When clicked on campaign submitted
        if aps!["type"] as! String == "campaign_submitted" {
            if UIApplication.visibleViewController is CompletedCampaignViewController {
            }  else {
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
        rootViewController.pushViewController(CompletedCampaignViewController.controlFromNavigation(aps!["id"] as! String), animated: true)
            }
        }
        
        //When clicked on urgency accepted
        if aps!["type"] as! String == "urgency_response" {
            if UIApplication.visibleViewController is CompletedCampaignViewController {
            } else {
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
        rootViewController.pushViewController(CompletedCampaignViewController.controlFromNavigation(aps!["id"] as! String), animated: true)
            }
        }
        
        // When clicked on payment received
        if aps!["type"] as! String == "payment_recieved" {
            if UIApplication.visibleViewController is CampaignInvoiceViewController {
            } else {
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
                rootViewController.pushViewController(CampaignInvoiceViewController.control, animated: true)
            }
        }
        
        // When clicked on invoice generated
        if aps!["type"] as! String == "invoice_generated" {
            if UIApplication.visibleViewController is CampaignInvoiceViewController {
            } else {
                let rootViewController = self.window!.rootViewController as!
                UINavigationController
                rootViewController.pushViewController(CampaignInvoiceViewController.control, animated: true)
            }}
        completionHandler()
    }
    
    //MARK:- Convert To Dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            } }
        return nil
    }
    
    //MARK:- Manage notifications
    func manageNotiData(_ data: [AnyHashable: Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let aps = data["aps"] as! NSDictionary
        let notificationType: String = (aps["type"] as? String)!
        print("Notification Type = ", notificationType)
        if UIApplication.visibleViewController.className == "MessagingViewController" {
            print(aps)
            if notificationType == "message" {
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.DELAYTIME - 1.0 ) {
                    NotificationCenter.default.removeObserver(self)
                    let nc = NotificationCenter.default
                    nc.post(name:Notification.Name(rawValue:ConstantsKeys.REFRESHMESSAGE_KEY),
                            object: nil,
                            userInfo: ["ButtonAction":""])
                } }   else { }  }else { }
    }
    
    //MARK:- Login View Controller
    func loginVC() {
        let initialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    //MARK:- Handel push notification in background
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        manageNotiData(data)
    }
    
    //2AB5E41B84D9736ECFD00D3196B63868B10AC89803486A0EDDD90715CE16149E
    //    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        // Convert token to string
    //        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    //
    //        // Print it to console
    //        print("APNs device token: \(deviceTokenString)")
    //
    //        // Persist it in your backend in case it's new
    //    }
    //
    // Called when APNs failed to register the device for push notifications
    
    //    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //        // Print the error to console (you should alert the user that registration failed)
    //        print("APNs registration failed: \(error)")
    //    }
    //
    
    //    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
    //        // Print notification payload data
    //        print("Push notification received: \(data)")
    //    }
    
    //MARK:- log User Func
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("bikramjit.singh@csgroupchd.com")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
    }
    
    //MARK:- Get Catagories Func
    func getCatagories() {
        PopUpApiStore.sharedInstance.getCatagories { (response) in
            if response?.baseAllCatagoriesresponse?.status == "1" {
                MiscDetailStore.sharedInstance.allCatories = (response?.baseAllCatagoriesresponse?.baseAllCatagoriesresult)!
            } else {
                SVProgressHUD.showError(withStatus: Constants.SERVER_ERROR)
            }
        }
    }
    
    //MARK:- Override Application methods
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Usnap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }})
        return container
    }()
    
    // MARK:- Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//extension UIApplication {
//    var statusBarUIView: UIView? {
//        if #available(iOS 13.0, *) {
//            let tag = 38482
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//
//            if let statusBar = keyWindow?.viewWithTag(tag) {
//                return statusBar
//            } else {
//                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
//                let statusBarView = UIView(frame: statusBarFrame)
//                statusBarView.tag = tag
//                keyWindow?.addSubview(statusBarView)
//                return statusBarView
//            }
//        } else if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        } else {
//            return nil
//        }
//    }
//}

//MARK:- UIText View Wor karound
class UITextViewWorkaround: NSObject {
    // --------------------------------------------------------------------
    // MARK: Singleton
    // --------------------------------------------------------------------
    // make it a singleton
    static let unique = UITextViewWorkaround()
    // --------------------------------------------------------------------
    // MARK: executeWorkaround()
    // --------------------------------------------------------------------
    func executeWorkaround() {
        if #available(iOS 13.2, *) {
            NSLog("UITextViewWorkaround.unique.executeWorkaround(): we are on iOS 13.2+ no need for a workaround")
        } else {
            // name of the missing class stub
            let className = "_UITextLayoutView"
            // try to get the class
            var cls = objc_getClass(className)
            // check if class is available
            if cls == nil {
                // it's not available, so create a replacement and register it
                cls = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(cls as! AnyClass)
                #if DEBUG
                NSLog("UITextViewWorkaround.unique.executeWorkaround(): added \(className) dynamically")
                #endif
            }
        }
    }
}
