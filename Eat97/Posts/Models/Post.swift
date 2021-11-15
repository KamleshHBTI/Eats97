//
//  Post.swift
//  Post
//
//  Created by Kamlesh on 22/10/21.
//

import Foundation
// MARK: - Posts
struct Posts: Codable {
  let data: [Post]
  var total, page, limit: Int
}

// MARK: - Datum
struct Post: Codable {
  let id: String
  let image: String?
  let likes: Int?
  let tags: [String]?
  let text, publishDate: String?
  let owner: Owner
  let post: String?
}

// MARK: - Payload Post
struct PayloadPost: Codable {
  let id:String?
  let image: String
  let likes: Int?
  let tags: [String]?
  let text:String?
  let owner: String
  let post: String
}

// MARK: - Owner
struct Owner: Codable {
  let id: String?
  let title: String
  let firstName, lastName: String
  let picture: String

}
