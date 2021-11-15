//
//  PostViewModel.swift
//  PostViewModel
//
//  Created by Kamlesh on 22/10/21.
//

import Foundation
import Combine

class PostViewModel: PostControllerProtocol, ObservableObject{
  var objectWillChange = PassthroughSubject<Void, Never>()
  
  var posts = [Post]()
  var postDetails:Posts!
  
  var networkController: NetworkManagerProtocol
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Usage Example
  init(networkManagerProtocol: NetworkManagerProtocol) {
    self.networkController = networkManagerProtocol
  }
  
  func getPost(page: Int = 0) {
    let endpoint = Endpoint.pagedPosts(page: page)
    networkController.get(type: Posts.self, url: endpoint.url, headers: endpoint.headers).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { posts in
      self.postDetails = posts
      self.posts = self.posts + posts.data
      self.objectWillChange.send()
    })
      .store(in: &subscriptions)
  }
  
  func createPost(payload: PayloadPost) -> AnyPublisher<Post, FailureReason> {
    let endPoints = Endpoint.createPost()
    let result = networkController.post(url: endPoints.url, headers: endPoints.headers, payload: payload, type: Post.self)
    return result
  }
  
  func updatePost(payload: PayloadPost){
    let endPoints = Endpoint.updatePost(id: payload.id!)
    networkController.update(url: endPoints.url, headers: endPoints.headers, payload: payload).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { posts in
      self.objectWillChange.send()
    })
      .store(in: &subscriptions)
  }
  
  func deletePost(id: String)-> AnyPublisher<Post, Error>{
    let endPoints = Endpoint.deletePost(id: id)
    let result = networkController.delete(type: Post.self, url: endPoints.url, headers: endPoints.headers)
    return result
  }

}

protocol PostControllerProtocol:AnyObject {
  var networkController: NetworkManagerProtocol { get }
  func getPost( page: Int)
  func createPost(payload: PayloadPost)-> AnyPublisher<Post, FailureReason>
  func updatePost(payload: PayloadPost)
  func deletePost(id: String) -> AnyPublisher<Post, Error>
}
 
