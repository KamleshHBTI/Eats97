//
//  UserViewModel.swift
//  UserViewModel
//
//  Created by Kamlesh on 21/10/21.
//

import Foundation
import Combine
import UIKit



class UserViewModel: UsersControllerProtocol, ObservableObject{
  
  var users = [User]()
  var objUsers: Users!
  
  let objectWillChange = PassthroughSubject<Void, Never>()
  
  let networkController: NetworkManagerProtocol
  var isMyUsers = false
  var isNew = false
  var isFirstTime = true
  var subscriptions = Set<AnyCancellable>()
  var selectedUser: User!
  
  // MARK: - Usage Example
  init(networkManagerProtocol: NetworkManagerProtocol) {
    self.networkController = networkManagerProtocol
  }
  
  
  //MARK: Get users details with user id
  func getUser(id: String) -> AnyPublisher<User, Error> {
    let endpoint = Endpoint.user(id: id)
    let apiResult = networkController.get(type: User.self, url: endpoint.url, headers: endpoint.headers)
    return apiResult
  }
  
  func deleteUser(id: String) -> AnyPublisher<User, Error> {
    let endpoint = Endpoint.user(id: id)
    let apiResult = networkController.delete(type: User.self, url: endpoint.url, headers: endpoint.headers)
    return apiResult
  }
  
  func createUser(payload: User) -> AnyPublisher<User, FailureReason> {
    let endpoint = Endpoint.createUser()
    let apiResult = networkController.post(url: endpoint.url, headers: endpoint.headers, payload: payload)
    return apiResult
  }
  
  func updateUser(id: String, payload: User) -> AnyPublisher<User, Error> {
    let endpoint = Endpoint.user(id: id)
    let apiResult = networkController.update(url: endpoint.url, headers: endpoint.headers, payload: payload)
    return apiResult
  }
  
  //MARK: Get users with defaults
  func getUsers(_ page: Int = 0) {
    let endpoint = Endpoint.users(page: page)
    networkController.get(type: Users.self, url: endpoint.url, headers: endpoint.headers).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { users in
      self.objUsers = users
      self.users = self.users + users.data
      self.objectWillChange.send()
    })
      .store(in: &subscriptions)
  }
  
}


protocol UsersControllerProtocol:AnyObject {
  var networkController: NetworkManagerProtocol { get }
  func getUsers(_ page: Int)
  func getUser(id: String) -> AnyPublisher<User, Error>
}

public protocol ObservableObject : AnyObject {
  associatedtype ObjectWillChangePublisher : Publisher = ObservableObjectPublisher where Self.ObjectWillChangePublisher.Failure == Never
  var objectWillChange: Self.ObjectWillChangePublisher { get }
}

extension UIViewController{
  internal func setupNavigationBar(){
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    navBarAppearance.backgroundColor = UIColor(displayP3Red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 1.0)
    self.navigationController?.navigationBar.standardAppearance = navBarAppearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    self.navigationController?.navigationBar.tintColor = .white
  }
}
