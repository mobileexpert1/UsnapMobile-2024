//
//  LoginResult.swift
//
//  Created by CSPC141 on 19/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct LoginResult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLoginResultUserStateKey: String = "user_state"
  private let kLoginResultUserEmailKey: String = "user_email"
  private let kLoginResultInvoiceByKey: String = "invoice_by"
  private let kLoginResultUserRefCodeKey: String = "user_ref_code"
  private let kLoginResultUserPostalCodeKey: String = "user_postal_code"
  private let kLoginResultUserAdd1Key: String = "user_add1"
  private let kLoginResultUserIsActiveKey: String = "user_is_active"
  private let kLoginResultUserCountryKey: String = "user_country"
  private let kLoginResultDeviceTokenKey: String = "device_token"
  private let kLoginResultUserAdd2Key: String = "user_add2"
  private let kLoginResultUserPassKey: String = "user_pass"
  private let kLoginResultUserFirstNameKey: String = "user_first_name"
  private let kLoginResultAddDateKey: String = "add_date"
  private let kLoginResultUserMobileKey: String = "user_mobile"
  private let kLoginResultUserLastNameKey: String = "user_last_name"
  private let kLoginResultUserRoleKey: String = "user_role"
  private let kLoginResultEditDateKey: String = "edit_date"
  private let kLoginResultUserMyrefCodeKey: String = "user_myref_code"
  private let kLoginResultDeviceTypeKey: String = "device_type"
  private let kLoginResultUserProfilePicKey: String = "user_profile_pic"
  private let kLoginResultRolesKey: String = "roles"
  private let kLoginResultUserCompanyNameKey: String = "user_company_name"
  private let kLoginResultUserCityKey: String = "user_city"
  private let kLoginResultUserIdKey: String = "user_id"
  private let kLoginResultUserAllMediaToKey: String = "user_all_media_to"
  private let kLoginResultUserAllInvoiceToKey: String = "user_all_invoice_to"
  private let kLoginResultUserUserRoleId: String = "user_role_id"
  private let kLoginResultUserLoginPermission: String = "login_permission"
    

  // MARK: Properties
  public var userState: String?
  public var userEmail: String?
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
  public var roles: String?
  public var userCompanyName: String?
  public var userCity: String?
  public var userId: String?
  public var userAllMediaTo: String?
  public var userAllInvoiceTo: String?
  public var userRoleId: String?
  public var loginPermission: String?
    
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
    userState = json[kLoginResultUserStateKey].string
    userEmail = json[kLoginResultUserEmailKey].string
    invoiceBy = json[kLoginResultInvoiceByKey].string
    userRefCode = json[kLoginResultUserRefCodeKey].string
    userPostalCode = json[kLoginResultUserPostalCodeKey].string
    userAdd1 = json[kLoginResultUserAdd1Key].string
    userIsActive = json[kLoginResultUserIsActiveKey].string
    userCountry = json[kLoginResultUserCountryKey].string
    deviceToken = json[kLoginResultDeviceTokenKey].string
    userAdd2 = json[kLoginResultUserAdd2Key].string
    userPass = json[kLoginResultUserPassKey].string
    userFirstName = json[kLoginResultUserFirstNameKey].string
    addDate = json[kLoginResultAddDateKey].string
    userMobile = json[kLoginResultUserMobileKey].string
    userLastName = json[kLoginResultUserLastNameKey].string
    userRole = json[kLoginResultUserRoleKey].string
    editDate = json[kLoginResultEditDateKey].string
    userMyrefCode = json[kLoginResultUserMyrefCodeKey].string
    deviceType = json[kLoginResultDeviceTypeKey].string
    userProfilePic = json[kLoginResultUserProfilePicKey].string
    roles = json[kLoginResultRolesKey].string
    userCompanyName = json[kLoginResultUserCompanyNameKey].string
    userCity = json[kLoginResultUserCityKey].string
    userId = json[kLoginResultUserIdKey].string
    userAllMediaTo = json[kLoginResultUserAllMediaToKey].string
    userAllInvoiceTo = json[kLoginResultUserAllInvoiceToKey].string
    userRoleId = json[kLoginResultUserUserRoleId].string
    loginPermission = json[kLoginResultUserLoginPermission].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = userState { dictionary[kLoginResultUserStateKey] = value }
    if let value = userEmail { dictionary[kLoginResultUserEmailKey] = value }
    if let value = invoiceBy { dictionary[kLoginResultInvoiceByKey] = value }
    if let value = userRefCode { dictionary[kLoginResultUserRefCodeKey] = value }
    if let value = userPostalCode { dictionary[kLoginResultUserPostalCodeKey] = value }
    if let value = userAdd1 { dictionary[kLoginResultUserAdd1Key] = value }
    if let value = userIsActive { dictionary[kLoginResultUserIsActiveKey] = value }
    if let value = userCountry { dictionary[kLoginResultUserCountryKey] = value }
    if let value = deviceToken { dictionary[kLoginResultDeviceTokenKey] = value }
    if let value = userAdd2 { dictionary[kLoginResultUserAdd2Key] = value }
    if let value = userPass { dictionary[kLoginResultUserPassKey] = value }
    if let value = userFirstName { dictionary[kLoginResultUserFirstNameKey] = value }
    if let value = addDate { dictionary[kLoginResultAddDateKey] = value }
    if let value = userMobile { dictionary[kLoginResultUserMobileKey] = value }
    if let value = userLastName { dictionary[kLoginResultUserLastNameKey] = value }
    if let value = userRole { dictionary[kLoginResultUserRoleKey] = value }
    if let value = editDate { dictionary[kLoginResultEditDateKey] = value }
    if let value = userMyrefCode { dictionary[kLoginResultUserMyrefCodeKey] = value }
    if let value = deviceType { dictionary[kLoginResultDeviceTypeKey] = value }
    if let value = userProfilePic { dictionary[kLoginResultUserProfilePicKey] = value }
    if let value = roles { dictionary[kLoginResultRolesKey] = value }
    if let value = userCompanyName { dictionary[kLoginResultUserCompanyNameKey] = value }
    if let value = userCity { dictionary[kLoginResultUserCityKey] = value }
    if let value = userId { dictionary[kLoginResultUserIdKey] = value }
    if let value = userAllMediaTo { dictionary[kLoginResultUserAllMediaToKey] = value }
    if let value = userAllInvoiceTo { dictionary[kLoginResultUserAllInvoiceToKey] = value }
    if let value = userRoleId { dictionary[kLoginResultUserUserRoleId] = value }
     if let value = loginPermission { dictionary[kLoginResultUserLoginPermission] = value }
    return dictionary
  }

}
