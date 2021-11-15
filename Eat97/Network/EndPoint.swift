//
//  EndPoint.swift
//  EndPoint
//
//  Created by Kamlesh on 20/10/21.
//

import Foundation

struct Endpoint {
  var path: String
  var queryItems: [URLQueryItem] = []
}

extension Endpoint {
  
  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "dummyapi.io"
    components.path = "/data/v1" + path
    components.queryItems = queryItems
    
    guard let url = components.url?.absoluteURL else {
      preconditionFailure("Invalid URL components: \(components)")
    }
    return url
  }
  
  var headers: [String: Any] {
    return [
      "app-id": "61629e58979cc186d47bdece",
      "Content-Type": "Application/json"
    ]
  }
  
}


extension Endpoint {
  
  //MARK: User end points

  static func users(page: Int) -> Self {
    return Endpoint(path: "/user",  queryItems: [ URLQueryItem(name: "page", value: "\(page)") ])
  }
  
  static func user(id: String) -> Self {
    return Endpoint(path: "/user/\(id)")
  }
  
  static func createUser() -> Self {
    return Endpoint(path: "/user/create")
  }
  
  //MARK: Post end points
  static var allPosts: Self {
    return Endpoint(path: "/post")
  }
  
  static func pagedPosts(page: Int) -> Self {
    return Endpoint(path: "/post",  queryItems: [ URLQueryItem(name: "page", value: "\(page)") ])
  }
  
   static func createPost() -> Self {
    return Endpoint(path: "/post/create")
  }
  
  static func updatePost(id: String) ->Self {
    return Endpoint(path: "/post/\(id)")
  }
  
  static func deletePost(id: String) ->Self {
    return Endpoint(path: "/post/\(id)")
  }
  
  //MARK: Comments end points
  static var allComments: Self {
    return Endpoint(path: "/comment")
  }
  
  static func pagedComments(page: Int) -> Self {
    return Endpoint(path: "/comment",  queryItems: [ URLQueryItem(name: "page", value: "\(page)") ])
  }
  
  static func myComments(id: String) -> Self {
    return Endpoint(path: "/post/\(id)/comment/")
  }
  
   static func createComment() -> Self {
    return Endpoint(path: "/comment/create")
  }

  static func deleteCommentt(id: String) ->Self {
    return Endpoint(path: "/comment/\(id)")
  }
  
    //MARK: Tags end point
  static var tags: Self {
    return Endpoint(path: "/tag")
  }
  
}


enum FailureReason : Error {
    case decoding(description: String)
    case api(description: String)
}
