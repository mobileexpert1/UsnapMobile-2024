//
//  CampaignDetailresult.swift
//
//  Created by CSPC141 on 16/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CampaignDetailresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCampaignDetailresultStateKey: String = "state"
  private let kCampaignDetailresultCreditAmountKey: String = "credit_amount"
  private let kCampaignDetailresultUserRoleIdKey: String = "user_role_id"
  private let kCampaignDetailresultCategoriesIdKey: String = "categories_id"
  private let kCampaignDetailresultIsUrgentAccKey: String = "is_urgent_acc"
  private let kCampaignDetailresultTotalImagesKey: String = "total_images"
  private let kCampaignDetailresultUpdateTimeKey: String = "update_time"
  private let kCampaignDetailresultInternalIdentifierKey: String = "id"
  private let kCampaignDetailresultTimeRequiredKey: String = "time_required"
  private let kCampaignDetailresultTitleKey: String = "title"
  private let kCampaignDetailresultContentByKey: String = "content_by"
  private let kCampaignDetailresultImagePriceKey: String = "image_price"
  private let kCampaignDetailresultPostalCodeKey: String = "postal_code"
  private let kCampaignDetailresultCityKey: String = "city"
  private let kCampaignDetailresultTotalPriceKey: String = "total_price"
  private let kCampaignDetailresultTotalVideosKey: String = "total_videos"
  private let kCampaignDetailresultAmountPayableKey: String = "amount_payable"
  private let kCampaignDetailresultAddDateKey: String = "add_date"
  private let kCampaignDetailresultAssignedRetoucherKey: String = "assigned_retoucher"
  private let kCampaignDetailresultAddressKey: String = "address"
  private let kCampaignDetailresultVideoPriceKey: String = "video_price"
  private let kCampaignDetailresultCampaignDetailcampaignImagesKey: String = "campaign_images"
  private let kCampaignDetailresultStatusKey: String = "status"
  private let kCampaignDetailresultPaidForPresetCreationKey: String = "paid_for_preset_creation"
  private let kCampaignDetailresultAssignedToKey: String = "assigned_to"
  private let kCampaignDetailresultIsUrgentKey: String = "is_urgent"
  private let kCampaignDetailresultUploadedByKey: String = "uploaded_by"
  private let kCampaignDetailresultCountryKey: String = "country"
  private let kCampaignDetailresultCategoryKey: String = "catagories"
  private let kCampaignDetailresultCampSizeKey: String = "campaign_size"
  private let kCampaignDetailresultStoragePriceKey: String = "Storage_Price_per_month"
  private let kCampaignDetailresultNintyDaysKey: String = "camp_ninty_days"
  private let kCampaignDetailresultPaymentStatusKey: String = "payment_status"
  private let kCampaignDetailresultPrintVersionKey: String = "printversion"
  private let kCampaignDetailresultWebVersionKey: String = "webversion"
  private let kCampaignDetailresultWatermarkKey: String = "watermark"
  private let kCampaignDetailresultWebSizesKey: String = "size"
  private let kCampaignDetailresultCampStatusKey: String = "campaign_status"
  private let kCampaignDetailresultRemaningDaysKey: String = "remaining_free_periodDays"
  private let kCampaignDetailCreditsKey: String = "credits"
  private let kNewCampaignDetailresultCategoryIDKey: String = "campaign_category_id"
    private let kNewCampaignDetailresultCreditUsedKey: String = "credit_used"
    


  // MARK: Properties
  public var state: String?
  public var creditAmount: String?
  public var userRoleId: String?
  public var categoriesId: String?
  public var isUrgentAcc: String?
  public var totalImages: Int?
  public var updateTime: String?
  public var internalIdentifier: String?
  public var timeRequired: String?
  public var title: String?
  public var contentBy: String?
  public var imagePrice: String?
  public var postalCode: String?
  public var city: String?
  public var totalPrice: String?
  public var totalVideos: Int?
  public var amountPayable: String?
  public var addDate: String?
  public var assignedRetoucher: String?
  public var address: String?
  public var videoPrice: String?
  public var campaignDetailcampaignImages: [CampaignDetailcampaignImages]?
  public var status: String?
  public var paidForPresetCreation: String?
  public var assignedTo: String?
  public var isUrgent: String?
  public var uploadedBy: String?
  public var country: String?
  public var category: String?
  public var campaignSize: String?
  public var storagePrice: String?
  public var nintyDays: String?
  public var paymentStaus: String?
  public var printVersion: String?
  public var webVersion: String?
  public var watermark: String?
  public var webSizes: String?
  public var camStatus: String?
  public var remaningDays: String?
  public var credits: String?
    public var campaign_category_id: String?
    
    public var credit_used: String?
    
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
    state = json[kCampaignDetailresultStateKey].string
    creditAmount = json[kCampaignDetailresultCreditAmountKey].string
    userRoleId = json[kCampaignDetailresultUserRoleIdKey].string
    categoriesId = json[kCampaignDetailresultCategoriesIdKey].string
    isUrgentAcc = json[kCampaignDetailresultIsUrgentAccKey].string
    totalImages = json[kCampaignDetailresultTotalImagesKey].int
    updateTime = json[kCampaignDetailresultUpdateTimeKey].string
    internalIdentifier = json[kCampaignDetailresultInternalIdentifierKey].string
    timeRequired = json[kCampaignDetailresultTimeRequiredKey].string
    title = json[kCampaignDetailresultTitleKey].string
    contentBy = json[kCampaignDetailresultContentByKey].string
    imagePrice = json[kCampaignDetailresultImagePriceKey].string
    postalCode = json[kCampaignDetailresultPostalCodeKey].string
    city = json[kCampaignDetailresultCityKey].string
    totalPrice = json[kCampaignDetailresultTotalPriceKey].string
    totalVideos = json[kCampaignDetailresultTotalVideosKey].int
    amountPayable = json[kCampaignDetailresultAmountPayableKey].string
    addDate = json[kCampaignDetailresultAddDateKey].string
    assignedRetoucher = json[kCampaignDetailresultAssignedRetoucherKey].string
    address = json[kCampaignDetailresultAddressKey].string
    videoPrice = json[kCampaignDetailresultVideoPriceKey].string
    if let items = json[kCampaignDetailresultCampaignDetailcampaignImagesKey].array { campaignDetailcampaignImages = items.map { CampaignDetailcampaignImages(json: $0) } }
    status = json[kCampaignDetailresultStatusKey].string
    paidForPresetCreation = json[kCampaignDetailresultPaidForPresetCreationKey].string
    assignedTo = json[kCampaignDetailresultAssignedToKey].string
    isUrgent = json[kCampaignDetailresultIsUrgentKey].string
    uploadedBy = json[kCampaignDetailresultUploadedByKey].string
    country = json[kCampaignDetailresultCountryKey].string
    category = json[kCampaignDetailresultCategoryKey].string
    campaignSize = json[kCampaignDetailresultCampSizeKey].string
    storagePrice = json[kCampaignDetailresultStoragePriceKey].string
    nintyDays = json[kCampaignDetailresultNintyDaysKey].string
    paymentStaus = json[kCampaignDetailresultPaymentStatusKey].string
    printVersion = json[kCampaignDetailresultPrintVersionKey].string
    webVersion = json[kCampaignDetailresultWebVersionKey].string
    watermark = json[kCampaignDetailresultWatermarkKey].string
    webSizes = json[kCampaignDetailresultWebSizesKey].string
    camStatus = json[kCampaignDetailresultCampStatusKey].string
    remaningDays = json[kCampaignDetailresultRemaningDaysKey].string
    credits = json[kCampaignDetailCreditsKey].string
      campaign_category_id = json[kNewCampaignDetailresultCategoryIDKey].string
      credit_used = json[kNewCampaignDetailresultCreditUsedKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[kCampaignDetailresultStateKey] = value }
    if let value = creditAmount { dictionary[kCampaignDetailresultCreditAmountKey] = value }
    if let value = userRoleId { dictionary[kCampaignDetailresultUserRoleIdKey] = value }
    if let value = categoriesId { dictionary[kCampaignDetailresultCategoriesIdKey] = value }
    if let value = isUrgentAcc { dictionary[kCampaignDetailresultIsUrgentAccKey] = value }
    if let value = totalImages { dictionary[kCampaignDetailresultTotalImagesKey] = value }
    if let value = updateTime { dictionary[kCampaignDetailresultUpdateTimeKey] = value }
    if let value = internalIdentifier { dictionary[kCampaignDetailresultInternalIdentifierKey] = value }
    if let value = timeRequired { dictionary[kCampaignDetailresultTimeRequiredKey] = value }
    if let value = title { dictionary[kCampaignDetailresultTitleKey] = value }
    if let value = contentBy { dictionary[kCampaignDetailresultContentByKey] = value }
    if let value = imagePrice { dictionary[kCampaignDetailresultImagePriceKey] = value }
    if let value = postalCode { dictionary[kCampaignDetailresultPostalCodeKey] = value }
    if let value = city { dictionary[kCampaignDetailresultCityKey] = value }
    if let value = totalPrice { dictionary[kCampaignDetailresultTotalPriceKey] = value }
    if let value = totalVideos { dictionary[kCampaignDetailresultTotalVideosKey] = value }
    if let value = amountPayable { dictionary[kCampaignDetailresultAmountPayableKey] = value }
    if let value = addDate { dictionary[kCampaignDetailresultAddDateKey] = value }
    if let value = assignedRetoucher { dictionary[kCampaignDetailresultAssignedRetoucherKey] = value }
    if let value = address { dictionary[kCampaignDetailresultAddressKey] = value }
    if let value = videoPrice { dictionary[kCampaignDetailresultVideoPriceKey] = value }
    if let value = campaignDetailcampaignImages { dictionary[kCampaignDetailresultCampaignDetailcampaignImagesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = status { dictionary[kCampaignDetailresultStatusKey] = value }
    if let value = paidForPresetCreation { dictionary[kCampaignDetailresultPaidForPresetCreationKey] = value }
    if let value = assignedTo { dictionary[kCampaignDetailresultAssignedToKey] = value }
    if let value = isUrgent { dictionary[kCampaignDetailresultIsUrgentKey] = value }
    if let value = uploadedBy { dictionary[kCampaignDetailresultUploadedByKey] = value }
    if let value = country { dictionary[kCampaignDetailresultCountryKey] = value }
    if let value = category { dictionary[kCampaignDetailresultCategoryKey] = value }
    if let value = campaignSize { dictionary[kCampaignDetailresultCampSizeKey] = value }
    if let value = storagePrice { dictionary[kCampaignDetailresultStoragePriceKey] = value }
    if let value = nintyDays { dictionary[kCampaignDetailresultNintyDaysKey] = value }
    if let value = paymentStaus { dictionary[kCampaignDetailresultPaymentStatusKey] = value }
    if let value = printVersion { dictionary[kCampaignDetailresultPrintVersionKey] = value }
    if let value = webVersion { dictionary[kCampaignDetailresultWebVersionKey] = value }
    if let value = watermark { dictionary[kCampaignDetailresultWatermarkKey] = value }
    if let value = webSizes { dictionary[kCampaignDetailresultWebSizesKey] = value }
    if let value = camStatus { dictionary[kCampaignDetailresultCampStatusKey] = value }
    if let value = remaningDays { dictionary[kCampaignDetailresultRemaningDaysKey] = value }
    if let value = credits { dictionary[kCampaignDetailCreditsKey] = value }
      if let value = campaign_category_id { dictionary[kNewCampaignDetailresultCategoryIDKey] = value }

    return dictionary
  }

}
