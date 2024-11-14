//
//  Staffresult.swift
//
//  Created by CSPC141 on 15/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Staffresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kStaffresultUserStateKey: String = "user_state"
  private let kStaffresultUserEmailKey: String = "user_email"
  private let kStaffresultCurrentInvoicesKey: String = "current_invoices"
  private let kStaffresultInvoiceByKey: String = "invoice_by"
  private let kStaffresultUserRefCodeKey: String = "user_ref_code"
  private let kStaffresultUserPostalCodeKey: String = "user_postal_code"
  private let kStaffresultCategoryKey: String = "category"
  private let kStaffresultUserIsActiveKey: String = "user_is_active"
  private let kStaffresultUserAdd1Key: String = "user_add1"
  private let kStaffresultRoleIsActiveKey: String = "role_is_active"
  private let kStaffresultUserCountryKey: String = "user_country"
  private let kStaffresultInternalIdentifierKey: String = "id"
  private let kStaffresultCountryCodeKey: String = "country_code"
  private let kStaffresultDeviceTokenKey: String = "device_token"
  private let kStaffresultUserAdd2Key: String = "user_add2"
  private let kStaffresultIsBlockKey: String = "is_block"
  private let kStaffresultUserPassKey: String = "user_pass"
  private let kStaffresultUserFirstNameKey: String = "user_first_name"
  private let kStaffresultAllMediaKey: String = "all_media"
  private let kStaffresultCurrentCampaignsKey: String = "current_campaigns"
  private let kStaffresultIsMemberKey: String = "is_member"
  private let kStaffresultAddDateKey: String = "add_date"
  private let kStaffresultCampaignUploadedKey: String = "campaign_uploaded"
  private let kStaffresultUserMobileKey: String = "user_mobile"
  private let kStaffresultUserLastNameKey: String = "user_last_name"
  private let kStaffresultUserRoleKey: String = "user_role"
  private let kStaffresultEditDateKey: String = "edit_date"
  private let kStaffresultUserMyrefCodeKey: String = "user_myref_code"
  private let kStaffresultDeviceTypeKey: String = "device_type"
  private let kStaffresultAllInvoiceKey: String = "all_invoice"
  private let kStaffresultUserCompanyNameKey: String = "user_company_name"
  private let kStaffresultUserProfilePicKey: String = "user_profile_pic"
  private let kStaffresultCampaignCreatedKey: String = "campaign_created"
  private let kStaffresultUserAllMediaToKey: String = "user_all_media_to"
  private let kStaffresultUserIdKey: String = "user_id"
  private let kStaffresultUserCityKey: String = "user_city"
  private let kStaffresultEditDataTimeKey: String = "edit_data_time"
  private let kStaffresultRoleSwitchKey: String = "role_switch"
  private let kStaffresultUserAllInvoiceToKey: String = "user_all_invoice_to"

  // MARK: Properties
  public var userState: String?
  public var userEmail: String?
  public var currentInvoices: String?
  public var invoiceBy: String?
  public var userRefCode: String?
  public var userPostalCode: String?
  public var category: String?
  public var userIsActive: String?
  public var userAdd1: String?
  public var roleIsActive: String?
  public var userCountry: String?
  public var internalIdentifier: String?
  public var countryCode: String?
  public var deviceToken: String?
  public var userAdd2: String?
  public var isBlock: String?
  public var userPass: String?
  public var userFirstName: String?
  public var allMedia: String?
  public var currentCampaigns: String?
  public var isMember: String?
  public var addDate: String?
  public var campaignUploaded: Int?
  public var userMobile: String?
  public var userLastName: String?
  public var userRole: String?
  public var editDate: String?
  public var userMyrefCode: String?
  public var deviceType: String?
  public var allInvoice: String?
  public var userCompanyName: String?
  public var userProfilePic: String?
  public var campaignCreated: String?
  public var userAllMediaTo: String?
  public var userId: String?
  public var userCity: String?
  public var editDataTime: String?
  public var roleSwitch: String?
  public var userAllInvoiceTo: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    userState = json[kStaffresultUserStateKey].string
    userEmail = json[kStaffresultUserEmailKey].string
    currentInvoices = json[kStaffresultCurrentInvoicesKey].string
    invoiceBy = json[kStaffresultInvoiceByKey].string
    userRefCode = json[kStaffresultUserRefCodeKey].string
    userPostalCode = json[kStaffresultUserPostalCodeKey].string
    category = json[kStaffresultCategoryKey].string
    userIsActive = json[kStaffresultUserIsActiveKey].string
    userAdd1 = json[kStaffresultUserAdd1Key].string
    roleIsActive = json[kStaffresultRoleIsActiveKey].string
    userCountry = json[kStaffresultUserCountryKey].string
    internalIdentifier = json[kStaffresultInternalIdentifierKey].string
    countryCode = json[kStaffresultCountryCodeKey].string
    deviceToken = json[kStaffresultDeviceTokenKey].string
    userAdd2 = json[kStaffresultUserAdd2Key].string
    isBlock = json[kStaffresultIsBlockKey].string
    userPass = json[kStaffresultUserPassKey].string
    userFirstName = json[kStaffresultUserFirstNameKey].string
    allMedia = json[kStaffresultAllMediaKey].string
    currentCampaigns = json[kStaffresultCurrentCampaignsKey].string
    isMember = json[kStaffresultIsMemberKey].string
    addDate = json[kStaffresultAddDateKey].string
    campaignUploaded = json[kStaffresultCampaignUploadedKey].int
    userMobile = json[kStaffresultUserMobileKey].string
    userLastName = json[kStaffresultUserLastNameKey].string
    userRole = json[kStaffresultUserRoleKey].string
    editDate = json[kStaffresultEditDateKey].string
    userMyrefCode = json[kStaffresultUserMyrefCodeKey].string
    deviceType = json[kStaffresultDeviceTypeKey].string
    allInvoice = json[kStaffresultAllInvoiceKey].string
    userCompanyName = json[kStaffresultUserCompanyNameKey].string
    userProfilePic = json[kStaffresultUserProfilePicKey].string
    campaignCreated = json[kStaffresultCampaignCreatedKey].string
    userAllMediaTo = json[kStaffresultUserAllMediaToKey].string
    userId = json[kStaffresultUserIdKey].string
    userCity = json[kStaffresultUserCityKey].string
    editDataTime = json[kStaffresultEditDataTimeKey].string
    roleSwitch = json[kStaffresultRoleSwitchKey].string
    userAllInvoiceTo = json[kStaffresultUserAllInvoiceToKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userState { dictionary[kStaffresultUserStateKey] = value }
    if let value = userEmail { dictionary[kStaffresultUserEmailKey] = value }
    if let value = currentInvoices { dictionary[kStaffresultCurrentInvoicesKey] = value }
    if let value = invoiceBy { dictionary[kStaffresultInvoiceByKey] = value }
    if let value = userRefCode { dictionary[kStaffresultUserRefCodeKey] = value }
    if let value = userPostalCode { dictionary[kStaffresultUserPostalCodeKey] = value }
    if let value = category { dictionary[kStaffresultCategoryKey] = value }
    if let value = userIsActive { dictionary[kStaffresultUserIsActiveKey] = value }
    if let value = userAdd1 { dictionary[kStaffresultUserAdd1Key] = value }
    if let value = roleIsActive { dictionary[kStaffresultRoleIsActiveKey] = value }
    if let value = userCountry { dictionary[kStaffresultUserCountryKey] = value }
    if let value = internalIdentifier { dictionary[kStaffresultInternalIdentifierKey] = value }
    if let value = countryCode { dictionary[kStaffresultCountryCodeKey] = value }
    if let value = deviceToken { dictionary[kStaffresultDeviceTokenKey] = value }
    if let value = userAdd2 { dictionary[kStaffresultUserAdd2Key] = value }
    if let value = isBlock { dictionary[kStaffresultIsBlockKey] = value }
    if let value = userPass { dictionary[kStaffresultUserPassKey] = value }
    if let value = userFirstName { dictionary[kStaffresultUserFirstNameKey] = value }
    if let value = allMedia { dictionary[kStaffresultAllMediaKey] = value }
    if let value = currentCampaigns { dictionary[kStaffresultCurrentCampaignsKey] = value }
    if let value = isMember { dictionary[kStaffresultIsMemberKey] = value }
    if let value = addDate { dictionary[kStaffresultAddDateKey] = value }
    if let value = campaignUploaded { dictionary[kStaffresultCampaignUploadedKey] = value }
    if let value = userMobile { dictionary[kStaffresultUserMobileKey] = value }
    if let value = userLastName { dictionary[kStaffresultUserLastNameKey] = value }
    if let value = userRole { dictionary[kStaffresultUserRoleKey] = value }
    if let value = editDate { dictionary[kStaffresultEditDateKey] = value }
    if let value = userMyrefCode { dictionary[kStaffresultUserMyrefCodeKey] = value }
    if let value = deviceType { dictionary[kStaffresultDeviceTypeKey] = value }
    if let value = allInvoice { dictionary[kStaffresultAllInvoiceKey] = value }
    if let value = userCompanyName { dictionary[kStaffresultUserCompanyNameKey] = value }
    if let value = userProfilePic { dictionary[kStaffresultUserProfilePicKey] = value }
    if let value = campaignCreated { dictionary[kStaffresultCampaignCreatedKey] = value }
    if let value = userAllMediaTo { dictionary[kStaffresultUserAllMediaToKey] = value }
    if let value = userId { dictionary[kStaffresultUserIdKey] = value }
    if let value = userCity { dictionary[kStaffresultUserCityKey] = value }
    if let value = editDataTime { dictionary[kStaffresultEditDataTimeKey] = value }
    if let value = roleSwitch { dictionary[kStaffresultRoleSwitchKey] = value }
    if let value = userAllInvoiceTo { dictionary[kStaffresultUserAllInvoiceToKey] = value }
    return dictionary
  }

}
