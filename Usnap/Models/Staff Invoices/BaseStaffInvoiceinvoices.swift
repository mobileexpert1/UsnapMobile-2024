//
//  BaseStaffInvoiceinvoices.swift
//
//  Created by CSPC141 on 04/04/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BaseStaffInvoiceinvoices {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBaseStaffInvoiceinvoicesGeneratePdfKey: String = "generate_pdf"
  private let kBaseStaffInvoiceinvoicesAdditionalServiceTimeKey: String = "additional_service_time"
  private let kBaseStaffInvoiceinvoicesInternalIdentifierKey: String = "id"
  private let kBaseStaffInvoiceinvoicesDateOfCreationKey: String = "date_of_creation"
  private let kBaseStaffInvoiceinvoicesDateOfPaymentKey: String = "date_of_payment"
  private let kBaseStaffInvoiceinvoicesAmountKey: String = "amount"
  private let kBaseStaffInvoiceinvoicesPaymentStatusKey: String = "payment_status"
  private let kBaseStaffInvoiceinvoicesUploadedByKey: String = "uploaded_by"
  private let kBaseStaffInvoiceinvoicesCampaignIdKey: String = "campaign_id"
  private let kBaseStaffInvoiceinvoicesTitleKey: String = "title"

  // MARK: Properties
  public var generatePdf: String?
  public var additionalServiceTime: String?
  public var internalIdentifier: String?
  public var dateOfCreation: String?
  public var dateOfPayment: String?
  public var amount: String?
  public var paymentStatus: String?
  public var uploadedBy: String?
  public var campaignId: String?
  public var title: String?

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
    generatePdf = json[kBaseStaffInvoiceinvoicesGeneratePdfKey].string
    additionalServiceTime = json[kBaseStaffInvoiceinvoicesAdditionalServiceTimeKey].string
    internalIdentifier = json[kBaseStaffInvoiceinvoicesInternalIdentifierKey].string
    dateOfCreation = json[kBaseStaffInvoiceinvoicesDateOfCreationKey].string
    dateOfPayment = json[kBaseStaffInvoiceinvoicesDateOfPaymentKey].string
    amount = json[kBaseStaffInvoiceinvoicesAmountKey].string
    paymentStatus = json[kBaseStaffInvoiceinvoicesPaymentStatusKey].string
    uploadedBy = json[kBaseStaffInvoiceinvoicesUploadedByKey].string
    campaignId = json[kBaseStaffInvoiceinvoicesCampaignIdKey].string
    title = json[kBaseStaffInvoiceinvoicesTitleKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = generatePdf { dictionary[kBaseStaffInvoiceinvoicesGeneratePdfKey] = value }
    if let value = additionalServiceTime { dictionary[kBaseStaffInvoiceinvoicesAdditionalServiceTimeKey] = value }
    if let value = internalIdentifier { dictionary[kBaseStaffInvoiceinvoicesInternalIdentifierKey] = value }
    if let value = dateOfCreation { dictionary[kBaseStaffInvoiceinvoicesDateOfCreationKey] = value }
    if let value = dateOfPayment { dictionary[kBaseStaffInvoiceinvoicesDateOfPaymentKey] = value }
    if let value = amount { dictionary[kBaseStaffInvoiceinvoicesAmountKey] = value }
    if let value = paymentStatus { dictionary[kBaseStaffInvoiceinvoicesPaymentStatusKey] = value }
    if let value = uploadedBy { dictionary[kBaseStaffInvoiceinvoicesUploadedByKey] = value }
    if let value = campaignId { dictionary[kBaseStaffInvoiceinvoicesCampaignIdKey] = value }
    if let value = title { dictionary[kBaseStaffInvoiceinvoicesTitleKey] = value }
    return dictionary
  }

}
