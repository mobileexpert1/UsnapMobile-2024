//
//  Profileresult.swift
//
//  Created by CSPC141 on 20/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Profileresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kProfileresultUserStateKey: String = "user_state"
  private let kProfileresultUserEmailKey: String = "user_email"
  private let kProfileresultCreditAmountKey: String = "credit_amount"
  private let kProfileresultInvoiceByKey: String = "invoice_by"
  private let kProfileresultUserRefCodeKey: String = "user_ref_code"
  private let kProfileresultUserPostalCodeKey: String = "user_postal_code"
  private let kProfileresultUserAdd1Key: String = "user_add1"
  private let kProfileresultUserIsActiveKey: String = "user_is_active"
  private let kProfileresultUserCountryKey: String = "user_country"
  private let kProfileresultDeviceTokenKey: String = "device_token"
  private let kProfileresultUserAdd2Key: String = "user_add2"
  private let kProfileresultUserPassKey: String = "user_pass"
  private let kProfileresultUserFirstNameKey: String = "user_first_name"
  private let kProfileresultAddDateKey: String = "add_date"
  private let kProfileresultUserMobileKey: String = "user_mobile"
  private let kProfileresultUserLastNameKey: String = "user_last_name"
  private let kProfileresultUserRoleKey: String = "user_role"
  private let kProfileresultEditDateKey: String = "edit_date"
  private let kProfileresultUserMyrefCodeKey: String = "user_myref_code"
  private let kProfileresultDeviceTypeKey: String = "device_type"
  private let kProfileresultUserProfilePicKey: String = "user_profile_pic"
  private let kProfileresultUserCompanyNameKey: String = "user_company_name"
  private let kProfileresultUserCityKey: String = "user_city"
  private let kProfileresultUserIdKey: String = "user_id"
  private let kProfileresultUserAllMediaToKey: String = "user_all_media_to"
  private let kProfileresultUserAllInvoiceToKey: String = "user_all_invoice_to"
  private let kProfileresultUserProfileTypeKey: String = "profile_type"

  // MARK: Properties
  public var userState: String?
  public var userEmail: String?
  public var creditAmount: String?
  public var invoiceBy: String?
  public var userRefCode: String?
  public var userPostalCode: String?
  public var userAdd1: String?
  public var userIsActive: String?
  public var userCountry: String?
  public var deviceToken: String?
  public var userAdd2: String?
  public var userPass: String?
  public var userFirstName: String?
  public var addDate: String?
  public var userMobile: String?
  public var userLastName: String?
  public var userRole: String?
  public var editDate: String?
  public var userMyrefCode: String?
  public var deviceType: String?
  public var userProfilePic: String?
  public var userCompanyName: String?
  public var userCity: String?
  public var userId: String?
  public var userAllMediaTo: String?
  public var userAllInvoiceTo: String?
  public var userProfileType: String?

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
    userState = json[kProfileresultUserStateKey].string
    userEmail = json[kProfileresultUserEmailKey].string
    creditAmount = json[kProfileresultCreditAmountKey].string
    invoiceBy = json[kProfileresultInvoiceByKey].string
    userRefCode = json[kProfileresultUserRefCodeKey].string
    userPostalCode = json[kProfileresultUserPostalCodeKey].string
    userAdd1 = json[kProfileresultUserAdd1Key].string
    userIsActive = json[kProfileresultUserIsActiveKey].string
    userCountry = json[kProfileresultUserCountryKey].string
    deviceToken = json[kProfileresultDeviceTokenKey].string
    userAdd2 = json[kProfileresultUserAdd2Key].string
    userPass = json[kProfileresultUserPassKey].string
    userFirstName = json[kProfileresultUserFirstNameKey].string
    addDate = json[kProfileresultAddDateKey].string
    userMobile = json[kProfileresultUserMobileKey].string
    userLastName = json[kProfileresultUserLastNameKey].string
    userRole = json[kProfileresultUserRoleKey].string
    editDate = json[kProfileresultEditDateKey].string
    userMyrefCode = json[kProfileresultUserMyrefCodeKey].string
    deviceType = json[kProfileresultDeviceTypeKey].string
    userProfilePic = json[kProfileresultUserProfilePicKey].string
    userCompanyName = json[kProfileresultUserCompanyNameKey].string
    userCity = json[kProfileresultUserCityKey].string
    userId = json[kProfileresultUserIdKey].string
    userAllMediaTo = json[kProfileresultUserAllMediaToKey].string
    userAllInvoiceTo = json[kProfileresultUserAllInvoiceToKey].string
    userProfileType = json[kProfileresultUserProfileTypeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userState { dictionary[kProfileresultUserStateKey] = value }
    if let value = userEmail { dictionary[kProfileresultUserEmailKey] = value }
    if let value = creditAmount { dictionary[kProfileresultCreditAmountKey] = value }
    if let value = invoiceBy { dictionary[kProfileresultInvoiceByKey] = value }
    if let value = userRefCode { dictionary[kProfileresultUserRefCodeKey] = value }
    if let value = userPostalCode { dictionary[kProfileresultUserPostalCodeKey] = value }
    if let value = userAdd1 { dictionary[kProfileresultUserAdd1Key] = value }
    if let value = userIsActive { dictionary[kProfileresultUserIsActiveKey] = value }
    if let value = userCountry { dictionary[kProfileresultUserCountryKey] = value }
    if let value = deviceToken { dictionary[kProfileresultDeviceTokenKey] = value }
    if let value = userAdd2 { dictionary[kProfileresultUserAdd2Key] = value }
    if let value = userPass { dictionary[kProfileresultUserPassKey] = value }
    if let value = userFirstName { dictionary[kProfileresultUserFirstNameKey] = value }
    if let value = addDate { dictionary[kProfileresultAddDateKey] = value }
    if let value = userMobile { dictionary[kProfileresultUserMobileKey] = value }
    if let value = userLastName { dictionary[kProfileresultUserLastNameKey] = value }
    if let value = userRole { dictionary[kProfileresultUserRoleKey] = value }
    if let value = editDate { dictionary[kProfileresultEditDateKey] = value }
    if let value = userMyrefCode { dictionary[kProfileresultUserMyrefCodeKey] = value }
    if let value = deviceType { dictionary[kProfileresultDeviceTypeKey] = value }
    if let value = userProfilePic { dictionary[kProfileresultUserProfilePicKey] = value }
    if let value = userCompanyName { dictionary[kProfileresultUserCompanyNameKey] = value }
    if let value = userCity { dictionary[kProfileresultUserCityKey] = value }
    if let value = userId { dictionary[kProfileresultUserIdKey] = value }
    if let value = userAllMediaTo { dictionary[kProfileresultUserAllMediaToKey] = value }
    if let value = userAllInvoiceTo { dictionary[kProfileresultUserAllInvoiceToKey] = value }
    if let value = userProfileType { dictionary[kProfileresultUserProfileTypeKey] = value }
    return dictionary
  }

}
