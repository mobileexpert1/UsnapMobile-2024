//
//  Constants.swift
//  Usnap
//
//  Created by Mobile on 20/12/17.
//  Copyright © 2017 Bikramjit Singh. All rights reserved.
//

import UIKit

let declineBgColor = UIColor(red: 243/255, green: 65/255, blue: 65/255, alpha: 1.0)
let acceptBgColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
let pinkBorderColor = UIColor(red: 203/255, green: 43/255, blue: 136/255, alpha: 0.38)
let solidPinkBorderColor = UIColor(red: 203/255, green: 43/255, blue: 136/255, alpha: 1.0)

struct Constants {
    static let DEVICE_TYPE = "iOS"
    static let DEVICE_TOKEN = ""
    static let SERVER_ERROR = "Something went wrong."
    static let PASSWORD_NOT_SAME = "Old and new password is not same."
    static let WRONGIDANDPASSWORD_ERROR = "Email id or password is not correct."
    static let EMAILVALIDATION_ERROR = "Please enter email in correct format."
    static let NODATAFOUND_ERROR = "No Data Found."
    static let ACCOUNT_DELETE = "Are you sure you want to delete your account?"
    static let NOMEDIA_ERROR = "You have no media to comment."
    static let CONTAINSNUMBERONLY_ERROR = "Please use only numbers in phone number."
    static let TEXTREQURIED_ERROR = "Please enter some text."
    static let DELAYTIME = 2.0
    static let INTERNAL_ERROR = "Some internal error."
    static let Images_Saved = "Images saved successfully."
    static let Images_Share = "Images saved successfully."
    static let SELECTEDIMAGES_NULL = "Please select the image from upper list."
    static let SELECTEDINVOICE_NULL = "Please select the invoice from upper list."
    static let RESEND_SUCCESSFULLY = "Invoice sent successfully."
    static let COMMENT_SUCCESSFULLY = "Comment Added Successfully."
    static let INVOICEPAID_SUCCESSFULLY = "Invoice paid successfully."
    static let PHOTOONLY_ERROR = "Select only photos."
    static let NOTALLOWEDFORVIDEOS_ERROR = "Editing is not allowed in videos."
    static let INTERNETNOTAVALIABLE = "Please check your internet connection."
    static let EMAILREQURIED = "Email is required."
    static let STARTDATE = "Start date should be smaller."
    static let ENDDATE = "End date should be greater."
    static let ENTERCARD = "Please enter your card first."
    static let COMPAIGN_NAME = "Please enter campaign name."
    static let BUY_CREDITS = "Please check website to buy credits on 20% less rate"
}


struct ConstantsKeys {
    static let DATEPICKERNOTIFICATION_KEY = "DateNotifier"
    static let ITEMPICKERNOTIFICATION_KEY_CAMPAIGN = "itemPickedCampaign"
    static let ITEMPICKERNOTIFICATION_KEY_STAFF = "itemPickedStaff"
    static let ITEMPICKERNOTIFICATION_KEY_ALLCATAGORIES = "itemPickedCatagories"
    static let ITEMPICKERNOTIFICATION_KEY_CAMPAIGNSTATUS = "itemPickedCampaignStatus"
    static let HOMEPOPNOTIFICATION_KEY = "homeOptions"
    static let REFRESHMESSAGE_KEY = "refreshMessage"
    static let STAFFFILTER_KEY = "staffFilter"
    static let CampaignFilter_KEY_Result = "campaignFilterResult"
    static let HANDLENOTIFICATION_KEY = "handleNotification"
    
}
