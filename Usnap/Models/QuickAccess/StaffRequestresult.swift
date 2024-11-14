//
//  StaffRequestresult.swift
//
//  Created by CSPC141 on 05/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct StaffRequestresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kStaffRequestresultUserStateKey: String = "user_state"
  private let kStaffRequestresultUserEmailKey: String = "user_email"
  private let kStaffRequestresultInvoiceByKey: String = "invoice_by"
  private let kStaffRequestresultUserRefCodeKey: String = "user_ref_code"
  private let kStaffRequestresultUserPostalCodeKey: String = "user_postal_code"
  private let kStaffRequestresultUserAdd1Key: String = "user_add1"
  private let kStaffRequestresultUserIsActiveKey: String = "user_is_active"
  private let kStaffRequestresultCategoryKey: String = "category"
  private let kStaffRequestresultUserCountryKey: String = "user_country"
  private let kStaffRequestresultCountryCodeKey: String = "country_code"
  private let kStaffRequestresultDeviceTokenKey: String = "device_token"
  private let kStaffRequestresultUserAdd2Key: String = "user_add2"
  private let kStaffRequestresultUserPassKey: String = "user_pass"
  private let kStaffRequestresultUserFirstNameKey: String = "user_first_name"
  private let kStaffRequestresultAllMediaKey: String = "all_media"
  private let kStaffRequestresultAddDateKey: String = "add_date"
  private let kStaffRequestresultUserMobileKey: String = "user_mobile"
  private let kStaffRequestresultUserLastNameKey: String = "user_last_name"
  private let kStaffRequestresultUserRoleKey: String = "user_role"
  private let kStaffRequestresultEditDateKey: String = "edit_date"
  private let kStaffRequestresultUserMyrefCodeKey: String = "user_myref_code"
  private let kStaffRequestresultDeviceTypeKey: String = "device_type"
  private let kStaffRequestresultUserProfilePicKey: String = "user_profile_pic"
  private let kStaffRequestresultAllInvoiceKey: String = "all_invoice"
  private let kStaffRequestresultUserCompanyNameKey: String = "user_company_name"
  private let kStaffRequestresultUserAllMediaToKey: String = "user_all_media_to"
  private let kStaffRequestresultUserCityKey: String = "user_city"
  private let kStaffRequestresultUserIdKey: String = "user_id"
  private let kStaffRequestresultUserAllInvoiceToKey: String = "user_all_invoice_to"
  private let kStaffRequestresultRoleSwitchKey: String = "role_switch"

  // MARK: Properties
  public var userState: String?
  public var userEmail: String?
  public var invoiceBy: String?
  public var userRefCode: String?
  public var userPostalCode: String?
  public var userAdd1: String?
  public var userIsActive: String?
  public var category: String?
  public var userCountry: String?
  public var countryCode: String?
  public var deviceToken: String?
  public var userAdd2: String?
  public var userPass: String?
  public var userFirstName: String?
  public var allMedia: String?
  public var addDate: String?
  public var userMobile: String?
  public var userLastName: String?
  public var userRole: String?
  public var editDate: String?
  public var userMyrefCode: String?
  public var deviceType: String?
  public var userProfilePic: String?
  public var allInvoice: String?
  public var userCompanyName: String?
  public var userAllMediaTo: String?
  public var userCity: String?
  public var userId: String?
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
    userState = json[kStaffRequestresultUserStateKey].string
    userEmail = json[kStaffRequestresultUserEmailKey].string
    invoiceBy = json[kStaffRequestresultInvoiceByKey].string
    userRefCode = json[kStaffRequestresultUserRefCodeKey].string
    userPostalCode = json[kStaffRequestresultUserPostalCodeKey].string
    userAdd1 = json[kStaffRequestresultUserAdd1Key].string
    userIsActive = json[kStaffRequestresultUserIsActiveKey].string
    category = json[kStaffRequestresultCategoryKey].string
    userCountry = json[kStaffRequestresultUserCountryKey].string
    countryCode = json[kStaffRequestresultCountryCodeKey].string
    deviceToken = json[kStaffRequestresultDeviceTokenKey].string
    userAdd2 = json[kStaffRequestresultUserAdd2Key].string
    userPass = json[kStaffRequestresultUserPassKey].string
    userFirstName = json[kStaffRequestresultUserFirstNameKey].string
    allMedia = json[kStaffRequestresultAllMediaKey].string
    addDate = json[kStaffRequestresultAddDateKey].string
    userMobile = json[kStaffRequestresultUserMobileKey].string
    userLastName = json[kStaffRequestresultUserLastNameKey].string
    userRole = json[kStaffRequestresultUserRoleKey].string
    editDate = json[kStaffRequestresultEditDateKey].string
    userMyrefCode = json[kStaffRequestresultUserMyrefCodeKey].string
    deviceType = json[kStaffRequestresultDeviceTypeKey].string
    userProfilePic = json[kStaffRequestresultUserProfilePicKey].string
    allInvoice = json[kStaffRequestresultAllInvoiceKey].string
    userCompanyName = json[kStaffRequestresultUserCompanyNameKey].string
    userAllMediaTo = json[kStaffRequestresultUserAllMediaToKey].string
    userCity = json[kStaffRequestresultUserCityKey].string
    userId = json[kStaffRequestresultUserIdKey].string
    userAllInvoiceTo = json[kStaffRequestresultUserAllInvoiceToKey].string
    roleSwitch = json[kStaffRequestresultRoleSwitchKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userState { dictionary[kStaffRequestresultUserStateKey] = value }
    if let value = userEmail { dictionary[kStaffRequestresultUserEmailKey] = value }
    if let value = invoiceBy { dictionary[kStaffRequestresultInvoiceByKey] = value }
    if let value = userRefCode { dictionary[kStaffRequestresultUserRefCodeKey] = value }
    if let value = userPostalCode { dictionary[kStaffRequestresultUserPostalCodeKey] = value }
    if let value = userAdd1 { dictionary[kStaffRequestresultUserAdd1Key] = value }
    if let value = userIsActive { dictionary[kStaffRequestresultUserIsActiveKey] = value }
    if let value = category { dictionary[kStaffRequestresultCategoryKey] = value }
    if let value = userCountry { dictionary[kStaffRequestresultUserCountryKey] = value }
    if let value = countryCode { dictionary[kStaffRequestresultCountryCodeKey] = value }
    if let value = deviceToken { dictionary[kStaffRequestresultDeviceTokenKey] = value }
    if let value = userAdd2 { dictionary[kStaffRequestresultUserAdd2Key] = value }
    if let value = userPass { dictionary[kStaffRequestresultUserPassKey] = value }
    if let value = userFirstName { dictionary[kStaffRequestresultUserFirstNameKey] = value }
    if let value = allMedia { dictionary[kStaffRequestresultAllMediaKey] = value }
    if let value = addDate { dictionary[kStaffRequestresultAddDateKey] = value }
    if let value = userMobile { dictionary[kStaffRequestresultUserMobileKey] = value }
    if let value = userLastName { dictionary[kStaffRequestresultUserLastNameKey] = value }
    if let value = userRole { dictionary[kStaffRequestresultUserRoleKey] = value }
    if let value = editDate { dictionary[kStaffRequestresultEditDateKey] = value }
    if let value = userMyrefCode { dictionary[kStaffRequestresultUserMyrefCodeKey] = value }
    if let value = deviceType { dictionary[kStaffRequestresultDeviceTypeKey] = value }
    if let value = userProfilePic { dictionary[kStaffRequestresultUserProfilePicKey] = value }
    if let value = allInvoice { dictionary[kStaffRequestresultAllInvoiceKey] = value }
    if let value = userCompanyName { dictionary[kStaffRequestresultUserCompanyNameKey] = value }
    if let value = userAllMediaTo { dictionary[kStaffRequestresultUserAllMediaToKey] = value }
    if let value = userCity { dictionary[kStaffRequestresultUserCityKey] = value }
    if let value = userId { dictionary[kStaffRequestresultUserIdKey] = value }
    if let value = userAllInvoiceTo { dictionary[kStaffRequestresultUserAllInvoiceToKey] = value }
    if let value = roleSwitch { dictionary[kStaffRequestresultRoleSwitchKey] = value }
    return dictionary
  }

}
