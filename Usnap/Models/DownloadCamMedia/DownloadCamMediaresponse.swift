//
//  DownloadCamMediaresponse.swift
//
//  Created by Lakhwinder Singh on 05/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct DownloadCamMediaresponse {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kDownloadCamMediaresponseDownloadCamMediaresultKey: String = "result"
  private let kDownloadCamMediaresponseStatusKey: String = "status"

  // MARK: Properties
  public var downloadCamMediaresult: [DownloadCamMediaresult]?
  public var status: String?

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
    if let items = json[kDownloadCamMediaresponseDownloadCamMediaresultKey].array { downloadCamMediaresult = items.map { DownloadCamMediaresult(json: $0) } }
    status = json[kDownloadCamMediaresponseStatusKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = downloadCamMediaresult { dictionary[kDownloadCamMediaresponseDownloadCamMediaresultKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = status { dictionary[kDownloadCamMediaresponseStatusKey] = value }
    return dictionary
  }

}
