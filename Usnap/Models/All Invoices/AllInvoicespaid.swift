//
//  AllInvoicespaid.swift
//
//  Created by CSPC141 on 20/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AllInvoicespaid {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAllInvoicespaidAdditionalServiceTimeKey: String = "additional_service_time"
  private let kAllInvoicespaidInternalIdentifierKey: String = "id"
  private let kAllInvoicespaidDateOfCreationKey: String = "date_of_creation"
  private let kAllInvoicespaidDateOfPaymentKey: String = "date_of_payment"
  private let kAllInvoicespaidAmountKey: String = "amount"
  private let kAllInvoicespaidCampaignIdKey: String = "campaign_id"
  private let kAllInvoicespaidTitleKey: String = "title"
  private let kAllInvoicespaidPaymentStatusKey: String = "payment_status"
  private let kAllInvoicespaidPaymentUploadedByKey: String = "uploaded_by"
  private let kAllInvoicespaidPaymentGeneratedPdfKey: String = "generate_pdf"
    
  // MARK: Properties
  public var additionalServiceTime: String?
  public var internalIdentifier: String?
  public var dateOfCreation: String?
  public var dateOfPayment: String?
  public var amount: String?
  public var campaignId: String?
  public var title: String?
  public var paymentStatus: String?
  public var uploadedBy: String?
  public var generatedPdf: String?
    
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
    additionalServiceTime = json[kAllInvoicespaidAdditionalServiceTimeKey].string
    internalIdentifier = json[kAllInvoicespaidInternalIdentifierKey].string
    dateOfCreation = json[kAllInvoicespaidDateOfCreationKey].string
    dateOfPayment = json[kAllInvoicespaidDateOfPaymentKey].string
    amount = json[kAllInvoicespaidAmountKey].string
    campaignId = json[kAllInvoicespaidCampaignIdKey].string
    title = json[kAllInvoicespaidTitleKey].string
    paymentStatus = json[kAllInvoicespaidPaymentStatusKey].string
    uploadedBy = json[kAllInvoicespaidPaymentUploadedByKey].string
    generatedPdf = json[kAllInvoicespaidPaymentGeneratedPdfKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = additionalServiceTime { dictionary[kAllInvoicespaidAdditionalServiceTimeKey] = value }
    if let value = internalIdentifier { dictionary[kAllInvoicespaidInternalIdentifierKey] = value }
    if let value = dateOfCreation { dictionary[kAllInvoicespaidDateOfCreationKey] = value }
    if let value = dateOfPayment { dictionary[kAllInvoicespaidDateOfPaymentKey] = value }
    if let value = amount { dictionary[kAllInvoicespaidAmountKey] = value }
    if let value = campaignId { dictionary[kAllInvoicespaidCampaignIdKey] = value }
    if let value = title { dictionary[kAllInvoicespaidTitleKey] = value }
    if let value = paymentStatus { dictionary[kAllInvoicespaidPaymentStatusKey] = value }
    if let value = uploadedBy { dictionary[kAllInvoicespaidPaymentUploadedByKey] = value }
    if let value = generatedPdf { dictionary[kAllInvoicespaidPaymentGeneratedPdfKey] = value }
    return dictionary
  }

}
