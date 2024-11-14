//
//  NewCampaignDetailresult.swift
//
//  Created by CSPC141 on 16/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NewCampaignDetailresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNewCampaignDetailresultStateKey: String = "state"
  private let kNewCampaignDetailresultCreditAmountKey: String = "credit_amount"
  private let kNewCampaignDetailresultUserRoleIdKey: String = "user_role_id"
  private let kNewCampaignDetailresultCategoriesIdKey: String = "categories_id"
  private let kNewCampaignDetailresultIsUrgentAccKey: String = "is_urgent_acc"
  private let kNewCampaignDetailresultUpdateTimeKey: String = "update_time"
  private let kNewCampaignDetailresultInternalIdentifierKey: String = "id"
  private let kNewCampaignDetailresultTimeRequiredKey: String = "time_required"
  private let kNewCampaignDetailresultTitleKey: String = "title"
  private let kNewCampaignDetailresultContentByKey: String = "content_by"
  private let kNewCampaignDetailresultPostalCodeKey: String = "postal_code"
  private let kNewCampaignDetailresultImagePriceKey: String = "image_price"
  private let kNewCampaignDetailresultNoOfVideosKey: String = "no_of_videos"
  private let kNewCampaignDetailresultCityKey: String = "city"
  private let kNewCampaignDetailresultTotalPriceKey: String = "total_price"
  private let kNewCampaignDetailresultAmountPayableKey: String = "amount_payable"
  private let kNewCampaignDetailresultNoOfPhotosKey: String = "no_of_photos"
  private let kNewCampaignDetailresultAddressKey: String = "address"
  private let kNewCampaignDetailresultAddDateKey: String = "add_date"
  private let kNewCampaignDetailresultAssignedRetoucherKey: String = "assigned_retoucher"
  private let kNewCampaignDetailresultVideoPriceKey: String = "video_price"
  private let kNewCampaignDetailresultStatusKey: String = "status"
  private let kNewCampaignDetailresultPaidForPresetCreationKey: String = "paid_for_preset_creation"
  private let kNewCampaignDetailresultCatagoriesKey: String = "catagories"
  private let kNewCampaignDetailresultAssignedToKey: String = "assigned_to"
  private let kNewCampaignDetailresultIsUrgentKey: String = "is_urgent"
  private let kNewCampaignDetailresultNewCampaignDetailcampaignMediaKey: String = "campaign_media"
  private let kNewCampaignDetailresultCountryKey: String = "country"
  private let kNewCampaignDetailresultPaymentOptionKey: String = "payment_option"
  private let kNewCampaignDetailresultPaymentStatusKey: String = "payment_status"
  private let kNewCampaignDetailresultUrgentPriceKey: String = "urgent_price"
  private let kNewCampaignDetailresultUrgentTimeKey: String = "urgent_time"
  private let kNewCampaignDetailresultUrgentPaybleAmountKey: String = "urgent_price_with_gst"
  private let kNewCampaignDetailresultAudioFileExistKey: String = "audio_file_exist"
  private let kNewCampaignDetailresultVideoFileExistKey: String = "video_exist"
  private let kNewCampaignDetailresultCardExistKey: String = "card_exist"
  private let kNewCampaignDetailresultUrgentPricePerImageKey: String = "urgent_per_image_price"
  private let kNewCampaignDetailresultRemaningDaysKey: String = "remaining_free_periodDays"
  private let kNewCampaignDetailresultCreditsKey: String = "credits"
  private let kNewCampaignDetailresultCategoryPriceKey: String = "campaign_category_price"
  private let kNewCampaignDetailresultCategoryNameKey: String = "campaign_category_name"
 private let kNewCampaignDetailresultCategoryIDKey: String = "campaign_category_id"
 
    private let kNewCampaignDetailresultUrgentCreditUsedKey: String = "urgent_credit_used"
    private let kNewCampaignDetailresultCreditUsedKey: String = "credit_used"
    private let kNewCampaignDetailresultUrgentCreditsKey: String = "urgentCredits"
    private let kNewCampaignDetailresultServiceTypeKey: String = "service_Type"
    private let kNewCampaignDetailresultQuantityKey: String = "quantity"
    private let kNewCampaignDetailresultCampaignIdKey: String = "campaign_id"
    private let kNewCampaignDetailresultIdKey: String = "id"

  // MARK: Properties
  public var state: String?
  public var creditAmount: String?
  public var userRoleId: String?
  public var categoriesId: String?
  public var isUrgentAcc: String?
  public var updateTime: String?
  public var internalIdentifier: String?
  public var timeRequired: String?
  public var title: String?
  public var contentBy: String?
  public var postalCode: String?
  public var imagePrice: String?
  public var noOfVideos: String?
  public var city: String?
  public var totalPrice: String?
  public var amountPayable: String?
  public var noOfPhotos: String?
  public var address: String?
  public var addDate: String?
  public var assignedRetoucher: String?
  public var videoPrice: String?
  public var status: String?
  public var paidForPresetCreation: String?
  public var catagories: String?
  public var assignedTo: String?
  public var isUrgent: String?
  public var newCampaignDetailcampaignMedia: [NewCampaignDetailcampaignMedia]?
  public var country: String?
  public var paymentOption: String?
  public var paymentStatus: String?
  public var UrgentPrice: String?
  public var UrgentTime: String?
  public var urgentPaybleAmount: String?
  public var audioExist: String?
  public var videoExist: String?
  public var cardExist: String?
  public var urgentPricePerImage: String?
  public var RemaningDays: String?
  public var credits: String?
  public var campaign_category_price: String?
  public var campaign_category_name: String?
public var campaign_category_id: String?
    

    public var urgent_credit_used: String?
    public var credit_used: String?
    public var urgentCredits: String?
    public var service_Type: String?
    public var quantity: String?
    public var campaign_id: String?
    public var id: String?

    
    
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
    state = json[kNewCampaignDetailresultStateKey].string
    creditAmount = json[kNewCampaignDetailresultCreditAmountKey].string
    userRoleId = json[kNewCampaignDetailresultUserRoleIdKey].string
    categoriesId = json[kNewCampaignDetailresultCategoriesIdKey].string
    isUrgentAcc = json[kNewCampaignDetailresultIsUrgentAccKey].string
    updateTime = json[kNewCampaignDetailresultUpdateTimeKey].string
    internalIdentifier = json[kNewCampaignDetailresultInternalIdentifierKey].string
    timeRequired = json[kNewCampaignDetailresultTimeRequiredKey].string
    title = json[kNewCampaignDetailresultTitleKey].string
    contentBy = json[kNewCampaignDetailresultContentByKey].string
    postalCode = json[kNewCampaignDetailresultPostalCodeKey].string
    imagePrice = json[kNewCampaignDetailresultImagePriceKey].string
    noOfVideos = json[kNewCampaignDetailresultNoOfVideosKey].string
    city = json[kNewCampaignDetailresultCityKey].string
    totalPrice = json[kNewCampaignDetailresultTotalPriceKey].string
    amountPayable = json[kNewCampaignDetailresultAmountPayableKey].string
    noOfPhotos = json[kNewCampaignDetailresultNoOfPhotosKey].string
    address = json[kNewCampaignDetailresultAddressKey].string
    addDate = json[kNewCampaignDetailresultAddDateKey].string
    assignedRetoucher = json[kNewCampaignDetailresultAssignedRetoucherKey].string
    videoPrice = json[kNewCampaignDetailresultVideoPriceKey].string
    status = json[kNewCampaignDetailresultStatusKey].string
    paidForPresetCreation = json[kNewCampaignDetailresultPaidForPresetCreationKey].string
    catagories = json[kNewCampaignDetailresultCatagoriesKey].string
    assignedTo = json[kNewCampaignDetailresultAssignedToKey].string
    isUrgent = json[kNewCampaignDetailresultIsUrgentKey].string
    if let items = json[kNewCampaignDetailresultNewCampaignDetailcampaignMediaKey].array { newCampaignDetailcampaignMedia = items.map { NewCampaignDetailcampaignMedia(json: $0) } }
    country = json[kNewCampaignDetailresultCountryKey].string
    paymentOption = json[kNewCampaignDetailresultPaymentOptionKey].string
    paymentStatus = json[kNewCampaignDetailresultPaymentStatusKey].string
    UrgentPrice = json[kNewCampaignDetailresultUrgentPriceKey].string
    UrgentTime = json[kNewCampaignDetailresultUrgentTimeKey].string
    urgentPaybleAmount = json[kNewCampaignDetailresultUrgentPaybleAmountKey].string
    audioExist = json[kNewCampaignDetailresultAudioFileExistKey].string
    videoExist = json[kNewCampaignDetailresultVideoFileExistKey].string
    cardExist = json[kNewCampaignDetailresultCardExistKey].string
    urgentPricePerImage = json[kNewCampaignDetailresultUrgentPricePerImageKey].string
    RemaningDays = json[kNewCampaignDetailresultRemaningDaysKey].string
    credits = json[kNewCampaignDetailresultCreditsKey].string
    campaign_category_price = json[kNewCampaignDetailresultCategoryPriceKey].string
    campaign_category_name = json[kNewCampaignDetailresultCategoryNameKey].string
    campaign_category_id = json[kNewCampaignDetailresultCategoryIDKey].string
  urgent_credit_used = json[kNewCampaignDetailresultUrgentCreditUsedKey].string
   credit_used = json[kNewCampaignDetailresultCreditUsedKey].string
   urgentCredits = json[kNewCampaignDetailresultUrgentCreditsKey].string
      service_Type = json[kNewCampaignDetailresultServiceTypeKey].string
      quantity = json[kNewCampaignDetailresultQuantityKey].string
      campaign_id = json[kNewCampaignDetailresultCampaignIdKey].string
      id = json[kNewCampaignDetailresultIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[kNewCampaignDetailresultStateKey] = value }
    if let value = creditAmount { dictionary[kNewCampaignDetailresultCreditAmountKey] = value }
    if let value = userRoleId { dictionary[kNewCampaignDetailresultUserRoleIdKey] = value }
    if let value = categoriesId { dictionary[kNewCampaignDetailresultCategoriesIdKey] = value }
    if let value = isUrgentAcc { dictionary[kNewCampaignDetailresultIsUrgentAccKey] = value }
    if let value = updateTime { dictionary[kNewCampaignDetailresultUpdateTimeKey] = value }
    if let value = internalIdentifier { dictionary[kNewCampaignDetailresultInternalIdentifierKey] = value }
    if let value = timeRequired { dictionary[kNewCampaignDetailresultTimeRequiredKey] = value }
    if let value = title { dictionary[kNewCampaignDetailresultTitleKey] = value }
    if let value = contentBy { dictionary[kNewCampaignDetailresultContentByKey] = value }
    if let value = postalCode { dictionary[kNewCampaignDetailresultPostalCodeKey] = value }
    if let value = imagePrice { dictionary[kNewCampaignDetailresultImagePriceKey] = value }
    if let value = noOfVideos { dictionary[kNewCampaignDetailresultNoOfVideosKey] = value }
    if let value = city { dictionary[kNewCampaignDetailresultCityKey] = value }
    if let value = totalPrice { dictionary[kNewCampaignDetailresultTotalPriceKey] = value }
    if let value = amountPayable { dictionary[kNewCampaignDetailresultAmountPayableKey] = value }
    if let value = noOfPhotos { dictionary[kNewCampaignDetailresultNoOfPhotosKey] = value }
    if let value = address { dictionary[kNewCampaignDetailresultAddressKey] = value }
    if let value = addDate { dictionary[kNewCampaignDetailresultAddDateKey] = value }
    if let value = assignedRetoucher { dictionary[kNewCampaignDetailresultAssignedRetoucherKey] = value }
    if let value = videoPrice { dictionary[kNewCampaignDetailresultVideoPriceKey] = value }
    if let value = status { dictionary[kNewCampaignDetailresultStatusKey] = value }
    if let value = paidForPresetCreation { dictionary[kNewCampaignDetailresultPaidForPresetCreationKey] = value }
    if let value = catagories { dictionary[kNewCampaignDetailresultCatagoriesKey] = value }
    if let value = assignedTo { dictionary[kNewCampaignDetailresultAssignedToKey] = value }
    if let value = isUrgent { dictionary[kNewCampaignDetailresultIsUrgentKey] = value }
    if let value = newCampaignDetailcampaignMedia { dictionary[kNewCampaignDetailresultNewCampaignDetailcampaignMediaKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = country { dictionary[kNewCampaignDetailresultCountryKey] = value }
    if let value = paymentOption { dictionary[kNewCampaignDetailresultPaymentOptionKey] = value }
    if let value = paymentStatus { dictionary[kNewCampaignDetailresultPaymentStatusKey] = value }
    if let value = UrgentPrice { dictionary[kNewCampaignDetailresultUrgentPriceKey] = value }
    if let value = UrgentTime { dictionary[kNewCampaignDetailresultUrgentTimeKey] = value }
    if let value = urgentPaybleAmount { dictionary[kNewCampaignDetailresultUrgentPaybleAmountKey] = value }
    if let value = audioExist { dictionary[kNewCampaignDetailresultAudioFileExistKey] = value }
    if let value = videoExist { dictionary[kNewCampaignDetailresultVideoFileExistKey] = value }
    if let value = cardExist { dictionary[kNewCampaignDetailresultCardExistKey] = value }
    if let value = urgentPricePerImage { dictionary[kNewCampaignDetailresultUrgentPricePerImageKey] = value }
    if let value = RemaningDays { dictionary[kNewCampaignDetailresultRemaningDaysKey] = value }
    if let value = credits { dictionary[kNewCampaignDetailresultCreditsKey] = value }
    if let value = campaign_category_price { dictionary[kNewCampaignDetailresultCategoryPriceKey] = value }
    if let value = campaign_category_name { dictionary[kNewCampaignDetailresultCategoryNameKey] = value }
    if let value = campaign_category_id { dictionary[kNewCampaignDetailresultCategoryIDKey] = value }
    return dictionary
  }
}
