//
//  StaffMemberDetailresult.swift
//
//  Created by CSPC141 on 15/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct StaffMemberDetailresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kStaffMemberDetailresultUserEmailKey: String = "user_email"
  private let kStaffMemberDetailresultUserStateKey: String = "user_state"
  private let kStaffMemberDetailresultInvoiceByKey: String = "invoice_by"
  private let kStaffMemberDetailresultCurrentInvoicesKey: String = "current_invoices"
  private let kStaffMemberDetailresultUserRefCodeKey: String = "user_ref_code"
  private let kStaffMemberDetailresultUserPostalCodeKey: String = "user_postal_code"
  private let kStaffMemberDetailresultCategoryKey: String = "category"
  private let kStaffMemberDetailresultUserIsActiveKey: String = "user_is_active"
  private let kStaffMemberDetailresultUserAdd1Key: String = "user_add1"
  private let kStaffMemberDetailresultUserCountryKey: String = "user_country"
  private let kStaffMemberDetailresultInternalIdentifierKey: String = "id"
  private let kStaffMemberDetailresultCountryCodeKey: String = "country_code"
  private let kStaffMemberDetailresultDeviceTokenKey: String = "device_token"
  private let kStaffMemberDetailresultUserAdd2Key: String = "user_add2"
  private let kStaffMemberDetailresultUserPassKey: String = "user_pass"
  private let kStaffMemberDetailresultIsMemberKey: String = "is_member"
  private let kStaffMemberDetailresultUserFirstNameKey: String = "user_first_name"
  private let kStaffMemberDetailresultAllMediaKey: String = "all_media"
  private let kStaffMemberDetailresultCurrentCampaignsKey: String = "current_campaigns"
  private let kStaffMemberDetailresultAddDateKey: String = "add_date"
  private let kStaffMemberDetailresultCampaignUploadedKey: String = "campaign_uploaded"
  private let kStaffMemberDetailresultUserMobileKey: String = "user_mobile"
  private let kStaffMemberDetailresultUserLastNameKey: String = "user_last_name"
  private let kStaffMemberDetailresultUserRoleKey: String = "user_role"
  private let kStaffMemberDetailresultEditDateKey: String = "edit_date"
  private let kStaffMemberDetailresultUserMyrefCodeKey: String = "user_myref_code"
  private let kStaffMemberDetailresultDeviceTypeKey: String = "device_type"
  private let kStaffMemberDetailresultAllInvoiceKey: String = "all_invoice"
  private let kStaffMemberDetailresultUserCompanyNameKey: String = "user_company_name"
  private let kStaffMemberDetailresultUserProfilePicKey: String = "user_profile_pic"
  private let kStaffMemberDetailresultCampaignCreatedKey: String = "campaign_created"
  private let kStaffMemberDetailresultUserAllMediaToKey: String = "user_all_media_to"
  private let kStaffMemberDetailresultUserCityKey: String = "user_city"
  private let kStaffMemberDetailresultUserAllInvoiceToKey: String = "user_all_invoice_to"
  private let kStaffMemberDetailresultRoleSwitchKey: String = "role_switch"

  // MARK: Properties
  public var userEmail: String?
  public var userState: String?
  public var invoiceBy: String?
  public var currentInvoices: String?
  public var userRefCode: String?
  public var userPostalCode: String?
  public var category: String?
  public var userIsActive: String?
  public var userAdd1: String?
  public var userCountry: String?
  public var internalIdentifier: String?
  public var countryCode: String?
  public var deviceToken: String?
  public var userAdd2: String?
  public var userPass: String?
  public var isMember: String?
  public var userFirstName: String?
  public var allMedia: String?
  public var currentCampaigns: String?
  public var addDate: String?
  public var campaignUploaded: String?
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
  public var userCity: String?
  public var userAllInvoiceTo: String?
  public var roleSwitch: String?

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
    userEmail = json[kStaffMemberDetailresultUserEmailKey].string
    userState = json[kStaffMemberDetailresultUserStateKey].string
    invoiceBy = json[kStaffMemberDetailresultInvoiceByKey].string
    currentInvoices = json[kStaffMemberDetailresultCurrentInvoicesKey].string
    userRefCode = json[kStaffMemberDetailresultUserRefCodeKey].string
    userPostalCode = json[kStaffMemberDetailresultUserPostalCodeKey].string
    category = json[kStaffMemberDetailresultCategoryKey].string
    userIsActive = json[kStaffMemberDetailresultUserIsActiveKey].string
    userAdd1 = json[kStaffMemberDetailresultUserAdd1Key].string
    userCountry = json[kStaffMemberDetailresultUserCountryKey].string
    internalIdentifier = json[kStaffMemberDetailresultInternalIdentifierKey].string
    countryCode = json[kStaffMemberDetailresultCountryCodeKey].string
    deviceToken = json[kStaffMemberDetailresultDeviceTokenKey].string
    userAdd2 = json[kStaffMemberDetailresultUserAdd2Key].string
    userPass = json[kStaffMemberDetailresultUserPassKey].string
    isMember = json[kStaffMemberDetailresultIsMemberKey].string
    userFirstName = json[kStaffMemberDetailresultUserFirstNameKey].string
    allMedia = json[kStaffMemberDetailresultAllMediaKey].string
    currentCampaigns = json[kStaffMemberDetailresultCurrentCampaignsKey].string
    addDate = json[kStaffMemberDetailresultAddDateKey].string
    campaignUploaded = json[kStaffMemberDetailresultCampaignUploadedKey].string
    userMobile = json[kStaffMemberDetailresultUserMobileKey].string
    userLastName = json[kStaffMemberDetailresultUserLastNameKey].string
    userRole = json[kStaffMemberDetailresultUserRoleKey].string
    editDate = json[kStaffMemberDetailresultEditDateKey].string
    userMyrefCode = json[kStaffMemberDetailresultUserMyrefCodeKey].string
    deviceType = json[kStaffMemberDetailresultDeviceTypeKey].string
    allInvoice = json[kStaffMemberDetailresultAllInvoiceKey].string
    userCompanyName = json[kStaffMemberDetailresultUserCompanyNameKey].string
    userProfilePic = json[kStaffMemberDetailresultUserProfilePicKey].string
    campaignCreated = json[kStaffMemberDetailresultCampaignCreatedKey].string
    userAllMediaTo = json[kStaffMemberDetailresultUserAllMediaToKey].string
    userCity = json[kStaffMemberDetailresultUserCityKey].string
    userAllInvoiceTo = json[kStaffMemberDetailresultUserAllInvoiceToKey].string
    roleSwitch = json[kStaffMemberDetailresultRoleSwitchKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userEmail { dictionary[kStaffMemberDetailresultUserEmailKey] = value }
    if let value = userState { dictionary[kStaffMemberDetailresultUserStateKey] = value }
    if let value = invoiceBy { dictionary[kStaffMemberDetailresultInvoiceByKey] = value }
    if let value = currentInvoices { dictionary[kStaffMemberDetailresultCurrentInvoicesKey] = value }
    if let value = userRefCode { dictionary[kStaffMemberDetailresultUserRefCodeKey] = value }
    if let value = userPostalCode { dictionary[kStaffMemberDetailresultUserPostalCodeKey] = value }
    if let value = category { dictionary[kStaffMemberDetailresultCategoryKey] = value }
    if let value = userIsActive { dictionary[kStaffMemberDetailresultUserIsActiveKey] = value }
    if let value = userAdd1 { dictionary[kStaffMemberDetailresultUserAdd1Key] = value }
    if let value = userCountry { dictionary[kStaffMemberDetailresultUserCountryKey] = value }
    if let value = internalIdentifier { dictionary[kStaffMemberDetailresultInternalIdentifierKey] = value }
    if let value = countryCode { dictionary[kStaffMemberDetailresultCountryCodeKey] = value }
    if let value = deviceToken { dictionary[kStaffMemberDetailresultDeviceTokenKey] = value }
    if let value = userAdd2 { dictionary[kStaffMemberDetailresultUserAdd2Key] = value }
    if let value = userPass { dictionary[kStaffMemberDetailresultUserPassKey] = value }
    if let value = isMember { dictionary[kStaffMemberDetailresultIsMemberKey] = value }
    if let value = userFirstName { dictionary[kStaffMemberDetailresultUserFirstNameKey] = value }
    if let value = allMedia { dictionary[kStaffMemberDetailresultAllMediaKey] = value }
    if let value = currentCampaigns { dictionary[kStaffMemberDetailresultCurrentCampaignsKey] = value }
    if let value = addDate { dictionary[kStaffMemberDetailresultAddDateKey] = value }
    if let value = campaignUploaded { dictionary[kStaffMemberDetailresultCampaignUploadedKey] = value }
    if let value = userMobile { dictionary[kStaffMemberDetailresultUserMobileKey] = value }
    if let value = userLastName { dictionary[kStaffMemberDetailresultUserLastNameKey] = value }
    if let value = userRole { dictionary[kStaffMemberDetailresultUserRoleKey] = value }
    if let value = editDate { dictionary[kStaffMemberDetailresultEditDateKey] = value }
    if let value = userMyrefCode { dictionary[kStaffMemberDetailresultUserMyrefCodeKey] = value }
    if let value = deviceType { dictionary[kStaffMemberDetailresultDeviceTypeKey] = value }
    if let value = allInvoice { dictionary[kStaffMemberDetailresultAllInvoiceKey] = value }
    if let value = userCompanyName { dictionary[kStaffMemberDetailresultUserCompanyNameKey] = value }
    if let value = userProfilePic { dictionary[kStaffMemberDetailresultUserProfilePicKey] = value }
    if let value = campaignCreated { dictionary[kStaffMemberDetailresultCampaignCreatedKey] = value }
    if let value = userAllMediaTo { dictionary[kStaffMemberDetailresultUserAllMediaToKey] = value }
    if let value = userCity { dictionary[kStaffMemberDetailresultUserCityKey] = value }
    if let value = userAllInvoiceTo { dictionary[kStaffMemberDetailresultUserAllInvoiceToKey] = value }
    if let value = roleSwitch { dictionary[kStaffMemberDetailresultRoleSwitchKey] = value }
    return dictionary
  }

}
