//
//  CompletedCampaignInvoiceresult.swift
//
//  Created by CSPC141 on 15/03/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CompletedCampaignInvoiceresult {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCompletedCampaignInvoiceresultAdditionalServiceTimeKey: String = "additional_service_time"
  private let kCompletedCampaignInvoiceresultInternalIdentifierKey: String = "id"
  private let kCompletedCampaignInvoiceresultInvoiceByKey: String = "invoice_by"
  private let kCompletedCampaignInvoiceresultDateOfCreationKey: String = "date_of_creation"
  private let kCompletedCampaignInvoiceresultDateOfPaymentKey: String = "date_of_payment"
  private let kCompletedCampaignInvoiceresultAmountKey: String = "amount"
  private let kCompletedCampaignInvoiceresultCampaignIdKey: String = "campaign_id"
  private let kCompletedCampaignInvoiceresultTitleKey: String = "title"
  private let kCompletedCampaignInvoiceresultUploadedByKey: String = "uploaded_by"
  private let kCompletedCampaignInvoiceresultPdfGenerateKey: String = "pdf_generate"
  private let kCompletedCampaignInvoiceresultPaymentStatusKey: String = "payment_status"
    
  // MARK: Properties
  public var additionalServiceTime: String?
  public var internalIdentifier: String?
  public var invoiceBy: String?
  public var dateOfCreation: String?
  public var dateOfPayment: String?
  public var amount: String?
  public var campaignId: String?
  public var title: String?
  public var uploadedBy: String?
  public var pdfGenerate: String?
  public var paymentStatus: String?
    
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
    additionalServiceTime = json[kCompletedCampaignInvoiceresultAdditionalServiceTimeKey].string
    internalIdentifier = json[kCompletedCampaignInvoiceresultInternalIdentifierKey].string
    invoiceBy = json[kCompletedCampaignInvoiceresultInvoiceByKey].string
    dateOfCreation = json[kCompletedCampaignInvoiceresultDateOfCreationKey].string
    dateOfPayment = json[kCompletedCampaignInvoiceresultDateOfPaymentKey].string
    amount = json[kCompletedCampaignInvoiceresultAmountKey].string
    campaignId = json[kCompletedCampaignInvoiceresultCampaignIdKey].string
    title = json[kCompletedCampaignInvoiceresultTitleKey].string
    uploadedBy = json[kCompletedCampaignInvoiceresultUploadedByKey].string
    pdfGenerate = json[kCompletedCampaignInvoiceresultPdfGenerateKey].string
    paymentStatus = json[kCompletedCampaignInvoiceresultPaymentStatusKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = additionalServiceTime { dictionary[kCompletedCampaignInvoiceresultAdditionalServiceTimeKey] = value }
    if let value = internalIdentifier { dictionary[kCompletedCampaignInvoiceresultInternalIdentifierKey] = value }
    if let value = invoiceBy { dictionary[kCompletedCampaignInvoiceresultInvoiceByKey] = value }
    if let value = dateOfCreation { dictionary[kCompletedCampaignInvoiceresultDateOfCreationKey] = value }
    if let value = dateOfPayment { dictionary[kCompletedCampaignInvoiceresultDateOfPaymentKey] = value }
    if let value = amount { dictionary[kCompletedCampaignInvoiceresultAmountKey] = value }
    if let value = campaignId { dictionary[kCompletedCampaignInvoiceresultCampaignIdKey] = value }
    if let value = title { dictionary[kCompletedCampaignInvoiceresultTitleKey] = value }
    if let value = uploadedBy { dictionary[kCompletedCampaignInvoiceresultUploadedByKey] = value }
    if let value = pdfGenerate { dictionary[kCompletedCampaignInvoiceresultPdfGenerateKey] = value }
    if let value = paymentStatus { dictionary[kCompletedCampaignInvoiceresultPaymentStatusKey] = value }
    return dictionary
  }

}
