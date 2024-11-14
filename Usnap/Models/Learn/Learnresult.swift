//
//  Learnresult.swift
//
//  Created by CSPC141 on 6/5/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class Learnresult: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kLearnresultInternalIdentifierKey: String = "id"
  private let kLearnresultLearnLinkKey: String = "learn_link"
  private let kLearnresultLearnTittleKey: String = "learn_tittle"
  private let kLearnresultLearnThumbnailKey: String = "thumbnail"
  private let kLearnresultLearnVideoIdKey: String = "video_id"
    
  // MARK: Properties
  public var internalIdentifier: String?
  public var learnLink: String?
  public var learnTittle: String?
  public var thumbnail: String?
  public var videoId: String?
    
  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    internalIdentifier = json[kLearnresultInternalIdentifierKey].string
    learnLink = json[kLearnresultLearnLinkKey].string
    learnTittle = json[kLearnresultLearnTittleKey].string
    thumbnail = json[kLearnresultLearnThumbnailKey].string
    videoId = json[kLearnresultLearnVideoIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kLearnresultInternalIdentifierKey] = value }
    if let value = learnLink { dictionary[kLearnresultLearnLinkKey] = value }
    if let value = learnTittle { dictionary[kLearnresultLearnTittleKey] = value }
    if let value = thumbnail { dictionary[kLearnresultLearnThumbnailKey] = value }
    if let value = videoId { dictionary[kLearnresultLearnVideoIdKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.internalIdentifier = aDecoder.decodeObject(forKey: kLearnresultInternalIdentifierKey) as? String
    self.learnLink = aDecoder.decodeObject(forKey: kLearnresultLearnLinkKey) as? String
    self.learnTittle = aDecoder.decodeObject(forKey: kLearnresultLearnTittleKey) as? String
    self.thumbnail = aDecoder.decodeObject(forKey: kLearnresultLearnThumbnailKey) as? String
    self.videoId = aDecoder.decodeObject(forKey: kLearnresultLearnVideoIdKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(internalIdentifier, forKey: kLearnresultInternalIdentifierKey)
    aCoder.encode(learnLink, forKey: kLearnresultLearnLinkKey)
    aCoder.encode(learnTittle, forKey: kLearnresultLearnTittleKey)
    aCoder.encode(thumbnail, forKey: kLearnresultLearnThumbnailKey)
    aCoder.encode(videoId, forKey: kLearnresultLearnVideoIdKey)
  }

}
