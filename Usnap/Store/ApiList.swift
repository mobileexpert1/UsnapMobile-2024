//
//  ApiList.swift
//  Usnap
//
//  Created by CSPC141 on 19/02/18.
//  Copyright © 2018 Bikramjit Singh. All rights reserved.
//

import Foundation

struct APIs {
    
// Live
//    static let KBASEURL = "https://usnap.com.au/webservicesM/"
//    static let KCREDITBASEURL = "https://usnap.com.au/Api/"
    
//    static let KBASEURL = "http://dev2.csdevhub.com/usnap/webservicesM/"
//    static let KCREDITBASEURL = "http://dev2.csdevhub.com/usnap/Api/"
    
    static let KBASEURL = "https://usnap.com.au/WebservicesM/"
    static let KCREDITBASEURL = "https://usnap.com.au/Api/"
    
    static let KIMAGEBASEURL = "https://s3-ap-southeast-2.amazonaws.com/lielasticbeanstalk-ap-southeast-li-20190226-2-662978452544/"
    static let KVIDEOBASEURL = "https://s3-ap-southeast-2.amazonaws.com/lielasticbeanstalk-ap-southeast-li-20190226-2-662978452544/"
    static let KIMAGESPRESETURL = "https://s3-ap-southeast-2.amazonaws.com/lielasticbeanstalk-ap-southeast-li-20190226-2-662978452544/"
    static let KVIDEOSPRESETURL = "https://s3-ap-southeast-2.amazonaws.com/lielasticbeanstalk-ap-southeast-li-20190226-2-662978452544/"
    static let KVIDEOBASETHUMBNAILURL = "https://s3-ap-southeast-2.amazonaws.com/lielasticbeanstalk-ap-southeast-li-20190226-2-662978452544/"
    
    
    // Staging
    
    
//    static let KBASEURL = "http://dev2.csdevhub.com/usnap/webservicesM/"
//    static let KIMAGEBASEURL = "https://s3-ap-southeast-2.amazonaws.com/usnap-dummybucket-stage"
//    static let KVIDEOBASEURL = "https://s3-ap-southeast-2.amazonaws.com/usnap-dummybucket-stage"
//    static let KIMAGESPRESETURL = "https://s3-ap-southeast-2.amazonaws.com/usnap-dummybucket-stage"
//    static let KVIDEOSPRESETURL = "https://s3-ap-southeast-2.amazonaws.com/usnap-dummybucket-stage"
//    static let KVIDEOBASETHUMBNAILURL = "https://s3-ap-southeast-2.amazonaws.com/usnap-dummybucket-stage"
    
    // MARK:- USER API'S
    
    // LOGIN USER   DONE
    static let KLOGIN = "\(KBASEURL)login"
    static let KLOGIN_P1_EMAIL = "email"
    static let KLOGIN_P2_PASSWORD = "password"
    static let KLOGIN_P3_DEVICE_TOKEN = "device_token"
    static let KLOGIN_P4_DEVICE_TYPE = "device_type"
    
    // LOGIN SOCAIL USER   DONE
    static let KSOCIALLOGIN = "\(KBASEURL)login"
    static let KSOCIALLOGIN_P1_EMAIL = "email"
    static let KSOCIALLOGIN_P2_SOCIALTYPE = "social_type"
    static let KSOCIALLOGIN_P3_DEVICE_TOKEN = "device_token"
    static let KSOCIALLOGIN_P4_DEVICE_TYPE = "device_type"
    static let KSOCIALLOGIN_P5_SOCIALID = "social_id"
    static let KSOCIALLOGIN_P6_FIRSTNAME = "first_name"
    static let KSOCIALLOGIN_P7_LASTNAME = "last_name"
    static let KSOCIALLOGIN_P8_COUNTRY = "country"
    
    // REGISTER USER
    static let KREGISTER = "\(KBASEURL)register"
    static let KREGISTER_P1_ROLL = "roll"
    static let KREGISTER_P2_FIRSTNAME = "first_name"
    static let KREGISTER_P3_LASTNAME = "last_name"
    static let KREGISTER_P4_EMAIL = "email"
    static let KREGISTER_P5_PASSWORD = "password"
    static let KREGISTER_P6_PHONENUMBER = "number"
    static let KREGISTER_P7_AGENTCODE = "ref_code"
    static let KREGISTER_P8_SIGNUP = "signup"
    static let KREGISTER_P9_DEVICE_TOKEN = "device_token"
    static let KREGISTER_P10_DEVICE_TYPE = "device_type"
    static let KREGISTER_P11_COUNTRY = "country"
    static let KREGISTER_P12_COMPANY_NAME = "company_name"
    static let KREGISTER_P13_ALL_MEDIA = "all_media_to"
    static let KREGISTER_P14_ALL_INVOICE = "all_invoice_to"
    
    // FORGOT PASSWORD  DONE
    static let KFORGOTPASSWORD = "\(KBASEURL)forget_password"
    static let KFORGOT_P1_EMAIL = "email"
    
    
    // GET USER PRICING  DONE
    static let KUSERPRICING = "\(KBASEURL)appliedPrice"
    static let KUSERPRICING_P1_USERID = "user_role_id"
   
    // CHANGE PASSWORD  DONE
    static let KCHANGEPASSWORD = "\(KBASEURL)change_password"
    static let KCHANGEPASSWORD_P1_USERID = "user_role_id"
    static let KCHANGEPASSWORD_P2_CURRENTPASSWORD = "current_password"
    static let KCHANGEPASSWORD_P3_NEWPASSWORD = "new_password"
    
    // GET USER PROFILE   DONE
    static let KGETUSERPROFILE = "\(KBASEURL)profile"
    static let KGETUSERPROFILE_P1_USERID = "user_role_id"
    static let KGETUSERPROFILE_P2_GETDATA = "get_data"
    
    // GET USER PROFILE TYPE  DONE
    static let KGETUSERPROFILETYPE = "\(KBASEURL)profile_type"
    static let KGETUSERPROFILETYPE_P1_USERID = "user_role_id"
    
    // UPDATE USER PROFILE  DONE
    static let KUPDATEPROFILE = "\(KBASEURL)profile"
    static let KUPDATEPROFILE_P1_USERID = "user_role_id"
    static let KUPDATEPROFILE_P2_UPDATEDATA = "update_profile"
    static let KUPDATEPROFILE_P3_FIRSTNAME = "first_name"
    static let KUPDATEPROFILE_P4_LASTNAME = "last_name"
    static let KUPDATEPROFILE_P5_MOBILENUMBER = "number"
    static let KUPDATEPROFILE_P6_ADDRESS1 = "add1"
    static let KUPDATEPROFILE_P7_ADDRESS2 = "add2"
    static let KUPDATEPROFILE_P8_STATE = "state"
    static let KUPDATEPROFILE_P9_COUNTRY = "country"
    static let KUPDATEPROFILE_P10_COMPANYNAME = "company_name"
    static let KUPDATEPROFILE_P11_ALLMEDIATO = "all_media_to"
    static let KUPDATEPROFILE_P12_ALLINVOICETO = "all_invoices_to"
    
    // CHANGE USER ROLE  DONE
    static let KCAMPAIGNINVOICE = "\(KBASEURL)changerole"
    static let KCAMPAIGNINVOICE_P1_USERID = "user_role_id"
    static let KCAMPAIGNINVOICE_P2_VALUE = "value"
    
    // FAQ'S  DONE
    static let KFAQ = "\(KBASEURL)faqs"
    static let KFAQ_P1_USERROLE = "user_role"
    
    // GET MEMBERSHIP PLANS  DONE
    static let KMEMBERSHIP = "\(KBASEURL)subscription"
    static let KMEMBERSHIP_P1_USERROLE = "user_role_id"
    
    
    
    // SUBSCRIBE PLAN DONE
    static let KSUBSCRIBE = "\(KBASEURL)get_subscription"
    static let KSUBSCRIBE_P1_USERROLE = "user_role_id"
    static let KSUBSCRIBE_P2_PLANID = "plan_id"
    static let KSUBSCRIPTIONTYPE_P3_SUBTYPE = "subscription_type"
    
    
    // KEEP DATA DONE
    static let KKEEPDATA = "\(KBASEURL)delete_user_allcampaign"
    static let KKEEPDATA_P1_USERROLE = "user_role_id"
    static let KKEEPDATA_P2_ACTION = "action"
    
    
    // MARK:- STAFF API'S
    
    // FETCH STAFF MEMBER LIST  DONE
    static let KGETSTAFFMEMBERLIST = "\(KBASEURL)staff_list"
    static let KGETSTAFFMEMBERLIST_P1_USERID = "user_role_id"
    
    // FETCH STAFF MEMBER DETAIL  DONE
    static let KGETSTAFFMEMBERDETAIL = "\(KBASEURL)single_staff"
    static let KGETSTAFFMEMBERDETAIL_P1_USERID = "user_id"
    
    // DELETE STAFF MEMBER  DONE
    static let KDELETESTAFFMEMBER = "\(KBASEURL)delete_staff"
    static let KDELETESTAFFMEMBER_P1_USERID = "user_id"
    
    // SET STAFF MEMBER PERMISSIONS  DONE
    static let KSETSTAFFPERMISSIONS = "\(KBASEURL)Staff_list"
    static let KSETSTAFFPERMISSIONS_P1_STAFFID = "staff_user_role_id"
    static let KSETSTAFFPERMISSIONS_P2_STATICVALUE = "invoice_update"
    static let KSETSTAFFPERMISSIONS_P3_PAIDBY = "paid_by_admin"
    static let KSETSTAFFPERMISSIONS_P4_ALLINVOICES = "all_invoice"
    static let KSETSTAFFPERMISSIONS_P5_ALLMEDIA = "all_media"
    
    // ADD NEW STAFF MEMBER  DONE
    static let KADDSTAFFMEMBER = "\(KBASEURL)add_staff_member"
    static let KADDSTAFFMEMBER_P1_USERID = "user_role_id"
    static let KADDSTAFFMEMBER_P2_STATICVALUE = "save"
    static let KADDSTAFFMEMBER_P3_FIRSTNAME = "first_name"
    static let KADDSTAFFMEMBER_P4_LASTNAME = "last_name"
    static let KADDSTAFFMEMBER_P5_NUMBER = "number"
    static let KADDSTAFFMEMBER_P6_EMAIL = "email"
    static let KADDSTAFFMEMBER_P7_INVOICEBY = "invoice_by"
    static let KADDSTAFFMEMBER_P8_ALLMEDIA = "all_media"
    static let KADDSTAFFMEMBER_P9_ALLINVOICES = "all_invoice"
    
    
    // STAFF MEMBERS REQUEST  DONE
    static let KSTAFFMEMBERREQUEST = "\(KBASEURL)staff_member_request"
    static let KSTAFFMEMBERREQUEST_P1_USERID = "user_role_id"
    
    // STAFF MEMBERS REQUEST ACTION  DONE
    static let KSTAFFMEMBERREQUESTACTION = "\(KBASEURL)staff_member_request"
    static let KSTAFFMEMBERREQUESTACTION_P1_USERID = "user_role_id"
    static let KSTAFFMEMBERREQUESTACTION_P2_EMAIL = "email"
    static let KSTAFFMEMBERREQUESTACTION_P3_USER_ACTION = "user_action"
    static let KSTAFFMEMBERREQUESTACTION_P4_SUBMIT = "submit"
    
    // GET NOTIFICATIONS  DONE
    static let KNOTIFICATIONS = "\(KBASEURL)notification"
    static let KNOTIFICATIONS_USERROLEID = "user_role_id"
    
    // CHANGE NOTIFICATION STATUS  DONE
    static let KCHANGENOTIFICATIONSTATUS = "\(KBASEURL)readNotifications"
    static let KCHANGENOTIFICATIONSTATUS_USERROLEID = "user_role_id"
    static let KCHANGENOTIFICATIONSTATUS_NOTIFICATIONID = "noti_id"
    
    // CHANGE NOTIFICATION STATUS READ/ UNREAD  DONE
    static let KCHANGENOTIFICATIONREADUNREAD = "\(KBASEURL)read_unread_notifications"
    static let KCHANGENOTIFICATIONREADUNREAD_USERROLEID = "user_role_id"
    static let KCHANGENOTIFICATIONREADUNREAD_NOTIFICATIONID = "noti_id"
    static let KCHANGENOTIFICATIONREADUNREAD_action = "action"
    
    
    // CAMPAIGN NOTIFICATIONS PAYMENT  DONE
    static let KCAMPNOTIFICATIONSPAYMENT = "\(KBASEURL)user_camp_keep"
    static let KCAMPNOTIFICATIONSPAYMENT_P1_CAMPAIGNID = "campaign_id"
    static let KCAMPNOTIFICATIONSPAYMENT_P2_KEEPCAMP = "keep_camp"
    static let KCAMPNOTIFICATIONSPAYMENT_P3_DEFAULTVALUE = "default_value"
    
     // MARK:- PAYMENT API'S
    
    // GET CREDIT CARD DETAIL  DONE
    static let KGETCREDITCARDDETAIL = "\(KBASEURL)get_credit_card"
    static let KGETCREDITCARDDETAIL_P1_USERID = "user_role_id"
    
    // UPDATE CREDIT CARD DETAIL  DONE
    static let KUPDATECREDITCARDDETAIL = "\(KBASEURL)update_credit_card"
    static let KUPDATECREDITCARDDETAIL_P1_USERID = "user_role_id"
    static let KUPDATECREDITCARDDETAIL_P2_NAME = "name"
    static let KUPDATECREDITCARDDETAIL_P3_CARDNUMBER = "card_number"
    static let KUPDATECREDITCARDDETAIL_P4_CVV = "cvv"
    static let KUPDATECREDITCARDDETAIL_P5_EXPDATE = "exp_date"

    // COMPLETED CAMPAIGN INVOICE LIST  DONE
    static let KCOMPLETEDINVOICECAMPAIGN = "\(KBASEURL)campaign_invoice"
    static let KCOMPLETEDINVOICECAMPAIGN_P1_CAMPAIGNID = "campaign_id"
    
    // COMPLETED CAMPAIGN INVOICE LIST  DONE
    static let KRESENDINVOICE = "\(KBASEURL)campaign_invoice"
    static let KRESENDINVOICE_P1_USERID = "user_role_id"
    static let KRESENDINVOICE_P1_INVOICEID = "invoice_id"
    
    
    // STAFF INVOICES  DONE
    static let KSTAFFINVOICE = "\(KBASEURL)Staff_invoice"
    static let KSTAFFINVOICE_P1_USERID = "user_id"
    
   
    // MARK:- CONTACT TO ADMIN API'S
    
    // CONTACT TO ADMIN   DONE
    static let KCONTACTADMIN = "\(KBASEURL)common_mail"
    static let KCONTACTADMIN_P1_USERID = "user_role_id"
    static let KCONTACTADMIN_P2_SUBJECT = "subject"
    static let KCONTACTADMIN_P3_MESSAGE = "message"
    static let KCONTACTADMIN_P4_CONTACTTYPE = "form_type"
    static let KCONTACTADMIN_P5_email = "email"
    static let KCONTACTADMIN_P6_name = "name"
  
    // SEND STAFF MEMBER INVITATION   DONE
    static let KSENDSTAFFINVITATION = "\(KBASEURL)invite"
    static let KSENDSTAFFINVITATION_P1_USERID = "user_role_id"
    static let KSENDSTAFFINVITATION_P2_EMAILS = "emails"
    
    
    //MARK:- CAMPAIGN API'S
    
    // GET CAMPAIGNS LIST  DONE
    static let KGETCOMPAIGNSLIST = "\(KBASEURL)view_campaign"
    static let KGETCOMPAIGNSLIST_P1_USERID = "user_role_id"
    static let KGETCOMPAIGNSLIST_P2_CAMPAIGNID = "campaign_id"
    static let KGETCOMPAIGNSLIST_P3_USERROLE = "user_role"
    
    // COMMENT ON CAMPAIGN IMAGE  DONE
    static let KCAMPAIGNIMAGECOMMENT = "\(KBASEURL)view_campaign"
    static let KCAMPAIGNIMAGECOMMENT_P1_USERID = "user_role_id"
    static let KCAMPAIGNIMAGECOMMENT_P2_CAMPAIGNID = "campaign_id"
    static let KCAMPAIGNIMAGECOMMENT_P3_IMAGEID = "image_id"
    static let KCAMPAIGNIMAGECOMMENT_P4_COMMENTTEXT = "comment"
    static let KCAMPAIGNIMAGECOMMENT_P5_APPLYALL = "apply_all"
    
    
    // COMMENT ON CAMPAIGN IMAGE WITH IMAGE  DONE
    static let KCAMPAIGNCOMMENRTWITHIMAGE = "\(KBASEURL)campaign_images_revision"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P1_CAMPAIGNID = "campaign_id"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P2_IMAGEID = "image_id"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P3_COMMENTTEXT = "comment"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P4_APPLYALL = "apply_all"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P5_QUANITY = "quantity"
    static let KCAMPAIGNCOMMENRTWITHIMAGE_P6_ADDONSERVICES = "addOnServices"
    
    // GET CAMPAIGN DETAIL  DONE
    static let KGETCOMPAIGNSDETAIL = "\(KBASEURL)view_campaign"
    static let KGETCOMPAIGNSDETAIL_P1_CAMPAIGNID = "campaign_id"
    static let KGETCOMPAIGNSDETAIL_P2_DATATYPE = "action"
    
    // RATE CAMPAIGNS  DONE
    static let KRATECAMPAIGN = "\(KBASEURL)campaign_rating"
    static let KRATECAMPAIGN_P1_USERID = "user_role_id"
    static let KRATECAMPAIGN_P2_CAMPAIGNID = "campaign_id"
    static let KRATECAMPAIGN_P3_RATING = "rating"
    static let KRATECAMPAIGN_P4_COMMENT = "comment"
    
    
    // CAMPAIGNS ADDITIONAL SERVICES   DONE
    static let KADDITIONALSERVICES = "\(KBASEURL)additional_campaign_service"
    static let KADDITIONALSERVICES_P1_USERID = "user_role_id"
    static let KADDITIONALSERVICES_P2_CAMPAIGNID = "campaign_id"
    
    // CAMPAIGNS ADDITIONAL SERVICES ACCEPT DECLINE  DONE
    static let KADDITIONALSERVICESUSERACTION = "\(KBASEURL)additional_campaign_service"
    static let KADDITIONALSERVICESUSERACTION_P1_USERID = "user_role_id"
    static let KADDITIONALSERVICESUSERACTION_P2_SERVICEID = "service_id"
    static let KADDITIONALSERVICESUSERACTION_P3_USERACTION = "user_action"
    static let KADDITIONALSERVICESUSERACTION_P4_STATICVALUE = "submit"
    
    // USER ALL INVOICES  DONE
    static let KUSERINVOICES = "\(KBASEURL)payment"
    static let KUSERINVOICES_P1_USERID = "user_role_id"
    
    // INVOICE PAYNOW BUTTON  DONE
    static let KUSERINVOICESPAYNOW = "\(KBASEURL)paynow"
    static let KUSERINVOICESPAYNOW_P1_USERID = "user_role_id"
    static let KUSERINVOICESPAYNOW_P2_INVOICEID = "invoice_id"
    
    // COMPARE IMAGE     DONE
    static let KCOMPAREIMAGE = "\(KBASEURL)image_revision"
    static let KCOMPAREIMAGE_P1_IMAGEID = "image_id"
    
    // COMPARE VIDEOS    DONE
    static let KCOMPAREVIDEO = "\(KBASEURL)image_revision"
    static let KCOMPAREVIDEOS_P1_VIDEOID = "image_id"
    
    
    // COMPARE VIDEOS    DONE
    static let KMediaSupports = "\(KBASEURL)campaign_audio_video"
    static let KMediaSupports_P1_USERID = "user_role_id"
    static let KMediaSupports_P2_FILES = "files"
    static let KMediaSupports_P3_CAMPAIGNID = "campaign_id"
    static let KMediaSupports_P4_SUBMIT = "submit"
    static let KMediaSupports_P5_WATERMARKLOGO = "watermarklogo"
    static let KMediaSupports_P6_ANIMATEDLOGO = "animatedlogo"
    static let KMediaSupports_P7_CONCLUSIONVIDEO = "conclusionvideo"
    static let KMediaSupports_P8_INTRODUCTIONVIDEO = "introvideo"
    
    
    // DELETE CAMPAIGN    DONE
    static let KDeleteCampaign = "\(KBASEURL)delete_campaign"
    static let KDeleteCampaign_P1_CAMPAIGNID = "campaign_id"
    
    // DELETE CAMPAIGN    DONE
    static let KDownloadCampaign = "\(KBASEURL)user_remained_campaign_media"
    static let KDownloadCampaign_P1_CAMPAIGNID = "campaign_id"
    
    
    // DELETE AFTER DOWNLOAD    DONE
    static let KDeleteAfterDownload = "\(KBASEURL)deleteMediaAft90Days"
    static let KDeleteAfterDownload_P1_CAMPAIGNID = "campaign_id"
    
    
     // MARK:- CREATE NEW CAMPAIGN API'S
    
    // GET DETAIL FOR NEW CAMPAIGN   DONE
    static let KNEWCAMPAIGNDETAIL = "\(KBASEURL)take_campaign_photo"
    static let KNEWCAMPAIGNDETAIL_P1_USERID = "user_role_id"
    static let KNEWCAMPAIGNDETAIL_P2_USERROLE = "user_role"
    
    // CREATE NEW CAMPAIGN  DONE
    static let KCREATECAMPAIGN = "\(KBASEURL)create_campaign"
    static let KCREATECAMPAIGN_P1_USERID = "user_role_id"
    static let KCREATECAMPAIGN_P2_USERROLE = "user_role"
    static let KCREATECAMPAIGN_P3_TITLE = "title"
    static let KCREATECAMPAIGN_P4_ADDRESS = "address"
    static let KCREATECAMPAIGN_P5_CITY = "city"
    static let KCREATECAMPAIGN_P6_STATE = "state"
    static let KCREATECAMPAIGN_P7_COUNTRY = "country"
    static let KCREATECAMPAIGN_P8_POSTALCODE = "postel_code"
    static let KCREATECAMPAIGN_P9_CATAGORIES = "catagories_id"
    static let KCREATECAMPAIGN_P10_ASSIGNEDTO = "assigned_to"
    static let KCREATECAMPAIGN_P11_CAMPAIGNID = "campaign_id"
    static let KCREATECAMPAIGN_P12_STATIC = "submit"
    static let KCREATECAMPAIGN_P13_STATICDEVICETYPE = "app_type"
    static let KCREATECAMPAIGN_P14_SERVICEID = "serviceId"
    
    
    // GET NEW CAMPAIGN DETAILS  DONE
   // static let KNEWCAMPAIGNSAVEDDETAIL = "\(KBASEURL)new_campaign"
    static let KNEWCAMPAIGNSAVEDDETAIL = "\(KBASEURL)new_campaign_sumit"
    static let KNEWCAMPAIGNSAVEDDETAIL_P1_CAMPAIGNID = "campaign_id"
    static let KNEWCAMPAIGNSAVEDDETAIL_P2_USERROLEID = ""

    // DELETE CAMPAIGN IMAGE  DONE
    //static let KDELETEIMAGE = "\(KBASEURL)new_campaign"
    static let KDELETEIMAGE = "\(KBASEURL)new_campaign_sumit"
    static let KDELETEIMAGE_P1_IMAGEID = "image_id"
    
    
    // CAMPAIGN IMAGE MEDIA  DONE
    static let KCAMPAIGNMEDIA = "\(KBASEURL)campaign_media"
    static let KCAMPAIGNMEDIA_P1_CAMPAIGNID = "campaign_id"
    
    // COMMENT ON MEDIA  DONE
    static let KMEDIACOMMENT = "\(KBASEURL)retouched_media_comment"
    static let KMEDIACOMMENT_P1_FILEID = "file_id"
    static let KMEDIACOMMENT_P2_FILENAME = "file_name"
    static let KMEDIACOMMENT_P3_COMMENT = "comment"
    static let KMEDIACAMPAIGNID_P4_COMMENT = "campaign_id"
    
    // SAVE CAMPAIGN  Done
    //static let KSAVECAMPAIGN = "\(KBASEURL)campaign_submit"
    static let KSAVECAMPAIGN = "\(KBASEURL)campaign_submit_sumit"
    
    static let KSAVECAMPAIGN_P1_URGENT = "urgent_type"
    static let KSAVECAMPAIGN_P2_CAMPAIGNID = "campaign_id"
    static let KSAVECAMPAIGN_P3_USERID = "user_role_id"
    static let KSAVECAMPAIGN_P4_SAVETYPE = "save_only"
    
    // SAVE USER EMAIL
    static let KSAVEUSEREMAIL = "\(KBASEURL)addEmailForSocial"
    static let KSAVEUSEREMAIL_P1_EMAIL = "email"
    static let KSAVEUSEREMAIL_P2_USERID = "user_role_id"
    
    
    // SAVE CAMPAIGN PRESET Done
    static let KCAMPAIGNPRESET = "\(KBASEURL)campaign_preset"
    static let KCAMPAIGNPRESET_P1_USERID = "user_role_id"
    static let KCAMPAIGNPRESET_P2_DIMENSIONS = "dimension"
    static let KCAMPAIGNPRESET_P3_LOGO = "logo"
    static let KCAMPAIGNPRESET_P4_ANIMATEDVIDEO = "animated_logo_file"
    static let KCAMPAIGNPRESET_P5_INTROVIDEO = "intro_video_file"
    static let KCAMPAIGNPRESET_P6_CONCLUSIONVIDEO = "conclud_video_file"
    static let KCAMPAIGNPRESET_P7_CUSTOMSIZE = "custom_size"
    static let KCAMPAIGNPRESET_P8_OPACITY = "opacity"
    static let KCAMPAIGNPRESET_P9_SUBMIT = "submit"
    
    
    // SAVE GET PRESET Done
    static let KGETPRESET = "\(KBASEURL)campaign_preset"
    static let KGETPRESET_P1_USERID = "user_role_id"

    
    // MARK:- FILTER API'S  DONE
    
    static let KGETCATAGORIES = "\(KBASEURL)campaign_categories"
    
    // STAFF MEMBER LIST FILTER DONE
    
    static let KGETSTAFFMEMBERLISTFILTERS = "\(KBASEURL)staff_list_filter"
    static let KGETSTAFFMEMBERLISTFILTERS_P1_USERID = "user_role_id"
    static let KGETSTAFFMEMBERLISTFILTERS_P2_MOBILE = "mobile"
    static let KGETSTAFFMEMBERLISTFILTERS_P3_EMAIL = "email"
    static let KGETSTAFFMEMBERLISTFILTERS_P4_STAFFNAME = "staff_name"
    
    //STAFF INVOICE FILTER  DONE
    
    static let KSTAFFINVOICEFILTERS = "\(KBASEURL)staff_invoice_filter"
    static let KSTAFFINVOICEFILTERS_P1_USERID = "user_id"
    static let KSTAFFINVOICEFILTERS_P2_CATAGORYID = "catagory_id"
    static let KSTAFFINVOICEFILTERS_P3_TITLE = "title"
    static let KSTAFFINVOICEFILTERS_P4_STATUS = "status"
    static let KSTAFFINVOICEFILTERS_P5_STARTDATE = "strdate"
    static let KSTAFFINVOICEFILTERS_P6_ENDDATE = "enddate"
    
    // CAMPAIGN FILTER  DONE
    
    static let KCAMPAIGNFILTERS = "\(KBASEURL)campaign_list_filter"
    static let KCAMPAIGNFILTERS_P1_USERID = "user_role_id"
    static let KCAMPAIGNFILTERS_P2_USERROLE = "user_role"
    static let KCAMPAIGNFILTERS_P3_CATEGORY = "category"
    static let KCAMPAIGNFILTERS_P4_STATUS = "status"
    static let KCAMPAIGNFILTERS_P5_TITLE = "title"
    static let KCAMPAIGNFILTERS_P6_STARTDATE = "strdate"
    static let KCAMPAIGNFILTERS_P7_ENDDATE = "enddate"
    static let KCAMPAIGNFILTERS_P8_RETOUCHERNAME = "retoucher_name"
    static let KCAMPAIGNFILTERS_P9_STAFFNAME = "staff_name"
    
    
    // INVOICE FILTER  DONE
    
    static let KINVOICEFILTER = "\(KBASEURL)payment_filter"
    static let KINVOICEFILTER_P1_USERID = "user_role_id"
    static let KINVOICEFILTER_P2_CATAGORID = "catagory_id"
    static let KINVOICEFILTER_P3_TITLE = "title"
    static let KINVOICEFILTER_P4_STATUS = "status"
    static let KINVOICEFILTER_P5_STAFFNAME = "staff_name"
    static let KINVOICEFILTER_P6_STARTDATE = "strdate"
    static let KINVOICEFILTER_P7_ENDDATE = "enddate"
   
    
    // MARK:- MESSAGES API'S
    
    // MESSAGE TITLE LIST DONE
    static let KMESSAGESTITLES = "\(KBASEURL)messages"
    static let KMESSAGESTITLES_P1_USERID = "user_role_id"
    
    
    // MESSAGE HISTORY  DONE
    static let KMESSAGESHISTORY = "\(KBASEURL)messages"
    static let KMESSAGESHISTORY_P1_USERID = "user_role_id"
    static let KMESSAGESHISTORY_P2_CAMPAIGNID = "campaign_id"
    static let KMESSAGESHISTORY_P3_PAGENO = "page_no"
    
    
    // SEND CHAT MESSAGE  DONE
    static let KSENDCHATMESSAGE = "\(KBASEURL)messages"
    static let KSENDCHATMESSAGE_P1_USERID = "user_role_id"
    static let KSENDCHATMESSAGE_P2_CAMPAIGNID = "campaign_id"
    static let KSENDCHATMESSAGE_P3_SENDERID = "sender_id"
    static let KSENDCHATMESSAGE_P4_MESSAGE = "message"
    static let KSENDCHATMESSAGE_P5_MESSAGELOAD = "message_load"
    
    
    // SEND CHAT MESSAGE  DONE
    static let KREFRESHMESSAGE = "\(KBASEURL)get_recieved_messages"
    static let KREFRESHMESSAGE_P1_USERID = "user_role_id"
    static let KREFRESHMESSAGE_P2_CAMPAIGNID = "campaign_id"
    static let KREFRESHMESSAGE_P3_LASTMESSAGEID = "last_message_id"
   
    // Learn  DONE
    static let KLEARN = "\(KBASEURL)learn"
    
    
    
    // SHARE MEDIA VIA SERVER
    static let KSHAREMEDIAVIASERVEER = "\(KBASEURL)shareMediaVersion"
    static let KSHAREMEDIAVIASERVEER_P1_CAMPAIGNID = "campaign_id"
    static let KSHAREMEDIAVIASERVEER_P2_USERROLE = "user_role_id"
    static let KSHAREMEDIAVIASERVEER_P3_MEDIAID = "media_id"
    static let KSHAREMEDIAVIASERVEER_P4_EMAILS = "emails"
    
    // GET MEDIA SHARE LINK
    static let KSHAREMEDIAVIALINK = "\(KBASEURL)shareMedialink"
    static let KSHAREMEDIAVIALINK_P1_CAMPAIGNID = "campaign_id"
    static let KSHAREMEDIAVIALINK_P2_USERROLE = "user_role_id"
    static let KSHAREMEDIAVIALINK_P3_MEDIAID = "media_id"
    
    // MARK:- MISC API'S
    // GET COUNTS
    static let KCOUNTER = "\(KBASEURL)readUnreadMessagesCount"
    static let KCOUNTER_P1_USERID = "user_role_id"
    
    
    // MARK:- DISABLE USER API
    static let DISABLE_USER = "https://usnap.com.au/WebservicesM/disableUser"
    static let DISABLE_USER_EMAIL = "email"
    
    // MARK: - Credits
//    static let KCOINSHISTORY = "\(KCREDITBASEURL)CoinPurchase/usercoinsHistory"
    static let KCOINSHISTORY = "\(KCREDITBASEURL)CoinPurchase/usercoinsHistorySumit"
    static let KUPDATECAMPAIGNQUANTITY = "\(KCREDITBASEURL)CampaignCategories/update_campiagn_quantity"
    static let KCOINSPURCHASE = "\(KCREDITBASEURL)CoinPurchase/purchaseCoin"
    static let KCAMPAIGNCATEGORIES = "\(KCREDITBASEURL)CampaignCategories"
    static let KCAMPAIGNSUBCATEGORIES = "\(KCREDITBASEURL)CampaignCategories/get_sub_services?serviceId="
    static let KCAMPAIGNUPLOADSUBCATEGORIES = "\(KBASEURL)add_subservices_to_media"
  
    // MARK: - Submit Campaign
    static let KSUBMITCAMPAIGN = "\(KBASEURL)campaign_submit_sumit"
   // static let KSUBMITCAMPAIGN = "\(KBASEURL)campaign_submit"
    static let CAMPAIGN_CATEGORY_ID = "campaign_category_id"
}
