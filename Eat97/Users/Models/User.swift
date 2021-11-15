//
//  User.swift
//  User
//
//  Created by Kamlesh on 21/10/21.
//

import Foundation


// MARK: - Users
struct Users: Codable {
  let data: [User]
  var total, page, limit: Double?
}

// MARK: - Datum
struct User: Codable {
  var id, title:String?
  var firstName, lastName: String!
  var email: String?
  var picture: String?
  
  enum CodingKeys: String, CodingKey {
    case firstName
    case lastName
    case email
    case picture
    case title
    case id
  }
  
}

