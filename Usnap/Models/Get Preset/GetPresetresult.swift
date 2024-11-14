//
//  GetPresetresult.swift
//
//  Created by CSPC141 on 24/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct GetPresetresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kGetPresetresultInternalIdentifierKey: String = "id"
  private let kGetPresetresultUserRoleIdKey: String = "user_role_id"
  private let kGetPresetresultOpacityKey: String = "opacity"
  private let kGetPresetresultIntroVideoKey: String = "intro_video"
  private let kGetPresetresultPlaceLogoKey: String = "place_logo"
  private let kGetPresetresultCreatedKey: String = "created"
  private let kGetPresetresultLogoKey: String = "logo"
  private let kGetPresetresultPaidForWatermarkKey: String = "paid_for_watermark"
  private let kGetPresetresultAnimatedLogoFileKey: String = "animated_logo_file"
  private let kGetPresetresultCustomSizeKey: String = "custom_size"
  private let kGetPresetresultConcludVideoKey: String = "conclud_video"

  // MARK: Properties
  public var internalIdentifier: String?
  public var userRoleId: String?
  public var opacity: String?
  public var introVideo: String?
  public var placeLogo: String?
  public var created: String?
  public var logo: String?
  public var paidForWatermark: String?
  public var animatedLogoFile: String?
  public var customSize: String?
  public var concludVideo: String?

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
    internalIdentifier = json[kGetPresetresultInternalIdentifierKey].string
    userRoleId = json[kGetPresetresultUserRoleIdKey].string
    opacity = json[kGetPresetresultOpacityKey].string
    introVideo = json[kGetPresetresultIntroVideoKey].string
    placeLogo = json[kGetPresetresultPlaceLogoKey].string
    created = json[kGetPresetresultCreatedKey].string
    logo = json[kGetPresetresultLogoKey].string
    paidForWatermark = json[kGetPresetresultPaidForWatermarkKey].string
    animatedLogoFile = json[kGetPresetresultAnimatedLogoFileKey].string
    customSize = json[kGetPresetresultCustomSizeKey].string
    concludVideo = json[kGetPresetresultConcludVideoKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kGetPresetresultInternalIdentifierKey] = value }
    if let value = userRoleId { dictionary[kGetPresetresultUserRoleIdKey] = value }
    if let value = opacity { dictionary[kGetPresetresultOpacityKey] = value }
    if let value = introVideo { dictionary[kGetPresetresultIntroVideoKey] = value }
    if let value = placeLogo { dictionary[kGetPresetresultPlaceLogoKey] = value }
    if let value = created { dictionary[kGetPresetresultCreatedKey] = value }
    if let value = logo { dictionary[kGetPresetresultLogoKey] = value }
    if let value = paidForWatermark { dictionary[kGetPresetresultPaidForWatermarkKey] = value }
    if let value = animatedLogoFile { dictionary[kGetPresetresultAnimatedLogoFileKey] = value }
    if let value = customSize { dictionary[kGetPresetresultCustomSizeKey] = value }
    if let value = concludVideo { dictionary[kGetPresetresultConcludVideoKey] = value }
    return dictionary
  }

}
