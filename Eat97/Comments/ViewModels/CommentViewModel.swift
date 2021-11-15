//
//  CommentViewModel.swift
//  CommentViewModel
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import Combine

class CommentViewModel: CommentControllerProtocol, ObservableObject{

  var networkController: NetworkManagerProtocol
  var objectWillChange = PassthroughSubject<Void, Never>()
  var subscriptions = Set<AnyCancellable>()
  var comments = [Comment]()
  var commentDetails:Comments!
  
  // MARK: - Usage Example
  init(networkController :NetworkManagerProtocol){
    self.networkController = networkController
  }
  
  func getComment(_ page: Int = 0) {
    let endPoints = Endpoint.pagedPosts(page:page )
    networkController.get(type: Comments.self, url: endPoints.url, headers: endPoints.headers).sink(receiveCompletion: {(completion) in
      switch completion{
      case let .failure(error):
        print("couldn't get usres: \(error)")
      case .finished:
        break
      }
    }, receiveValue: { comments in
      self.commentDetails = comments
      self.comments = self.comments + comments.data
      self.objectWillChange.send()
    }).store(in: &subscriptions)
  }
  

  func createComment(payload: PayloadComment) -> AnyPublisher<Comment, FailureReason> {
    let endpoints = Endpoint.createComment()
    let result = networkController.post(url: endpoints.url, headers: endpoints.headers, payload: payload, type: Comment.self)
    return result
  }
   
  func deleteComment(id: String)  -> AnyPublisher<Comment, Error>{
    let endPoints = Endpoint.deleteCommentt(id: id)
    let result = networkController.delete(type: Comment.self, url: endPoints.url, headers: endPoints.headers)
    return result
  }
  
}

protocol CommentControllerProtocol:AnyObject {
  var networkController: NetworkManagerProtocol { get }
  func getComment(_ page: Int)
  func createComment(payload: PayloadComment)-> AnyPublisher<Comment, FailureReason>
  func deleteComment(id: String)  -> AnyPublisher<Comment, Error>
}
