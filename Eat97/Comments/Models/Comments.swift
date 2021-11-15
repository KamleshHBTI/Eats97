//
//  Posts.swift
//  Posts
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation

// MARK: - Posts
struct Comments: Codable {
  let data: [Comment]
  var total, page, limit: Int
}

// MARK: - Datum
struct Comment: Codable {
  let id:String?
  let message: String!
  let owner: Owner
  let post, publishDate: String?

}

struct PayloadComment: Codable {
  let message: String
  let owner: String
  let post: String
  let picture:String
}

extension String {
  var jsonStringRedecoded: String? {
    let data = ("\""+self+"\"").data(using: .utf8)!
    let result = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! String
    return result
  }
}

extension String {
  var decodeEmoji: String? {
    let data = self.data(using: String.Encoding.utf8,allowLossyConversion: false);
    let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
    if decodedStr != nil{
      return decodedStr as String?
    }
    return self
  }
}
