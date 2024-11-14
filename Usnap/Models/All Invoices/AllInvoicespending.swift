//
//  AllInvoicespending.swift
//
//  Created by CSPC141 on 20/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AllInvoicespending {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kAllInvoicespendingAdditionalServiceTimeKey: String = "additional_service_time"
  private let kAllInvoicespendingInternalIdentifierKey: String = "id"
  private let kAllInvoicespendingDateOfCreationKey: String = "date_of_creation"
  private let kAllInvoicespendingDateOfPaymentKey: String = "date_of_payment"
  private let kAllInvoicespendingAmountKey: String = "amount"
  private let kAllInvoicespendingCampaignIdKey: String = "campaign_id"
  private let kAllInvoicespendingTitleKey: String = "title"
  private let kAllInvoicespendingPaymentStatusKey: String = "uploaded_by"
  private let kAllInvoicespendingPaymentUploadedByKey: String = "payment_status"
  private let kAllInvoicespendingPaymentGeneratedPdfKey: String = "generate_pdf"
    
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
    additionalServiceTime = json[kAllInvoicespendingAdditionalServiceTimeKey].string
    internalIdentifier = json[kAllInvoicespendingInternalIdentifierKey].string
    dateOfCreation = json[kAllInvoicespendingDateOfCreationKey].string
    dateOfPayment = json[kAllInvoicespendingDateOfPaymentKey].string
    amount = json[kAllInvoicespendingAmountKey].string
    campaignId = json[kAllInvoicespendingCampaignIdKey].string
    title = json[kAllInvoicespendingTitleKey].string
    paymentStatus = json[kAllInvoicespendingPaymentStatusKey].string
    uploadedBy = json[kAllInvoicespendingPaymentUploadedByKey].string
    generatedPdf = json[kAllInvoicespendingPaymentGeneratedPdfKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = additionalServiceTime { dictionary[kAllInvoicespendingAdditionalServiceTimeKey] = value }
    if let value = internalIdentifier { dictionary[kAllInvoicespendingInternalIdentifierKey] = value }
    if let value = dateOfCreation { dictionary[kAllInvoicespendingDateOfCreationKey] = value }
    if let value = dateOfPayment { dictionary[kAllInvoicespendingDateOfPaymentKey] = value }
    if let value = amount { dictionary[kAllInvoicespendingAmountKey] = value }
    if let value = campaignId { dictionary[kAllInvoicespendingCampaignIdKey] = value }
    if let value = title { dictionary[kAllInvoicespendingTitleKey] = value }
    if let value = paymentStatus { dictionary[kAllInvoicespendingPaymentStatusKey] = value }
    if let value = uploadedBy { dictionary[kAllInvoicespendingPaymentUploadedByKey] = value }
    if let value = generatedPdf { dictionary[kAllInvoicespendingPaymentGeneratedPdfKey] = value }
    return dictionary
  }

}
