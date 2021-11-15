//
//  TagViewModel.swift
//  TagViewModel
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import Combine

class TagViewModel:  TagsControllerProtocol{
  var tags = [String]()
  var networkController: NetworkManagerProtocol
  var objectWillChange = PassthroughSubject<Void, Never>()
  var subscriptions = Set<AnyCancellable>()

  // MARK: - Usage Example
  init(networkController :NetworkManagerProtocol){
    self.networkController = networkController
  }
  
  func getComment() {
    let endPoints = Endpoint.tags
    networkController.get(type: Tags.self, url: endPoints.url, headers: endPoints.headers).sink { (completion) in
      switch completion{
      case let .failure(error):
        print("Coudn't get tags \(error)")
        break
      case .finished:
        break
      }
    } receiveValue: { tags in
      self.tags = tags.data.filter{!$0.isEmpty || $0 != ""}
      self.objectWillChange.send()
    }.store(in: &subscriptions)

  }
}

protocol TagsControllerProtocol:AnyObject {
  var networkController: NetworkManagerProtocol { get }
  func getComment()
}
