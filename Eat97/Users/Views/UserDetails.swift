//
//  UserDetails.swift
//  UserDetails
//
//  Created by Kamlesh on 21/10/21.
//

import Foundation
import UIKit
import Combine

class UserDetails: UIViewController{
  private var firstNameTxt: UITextField!
  private var lastNameTxt: UITextField!
  private var emailTxt: UITextField!
  private var update: UIButton!
  private var parentStack: UIStackView!
  
  weak var viewModel: UserViewModel!
  var subscriptions = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    viewModel.isNew ? setupDetails() : getUserDetails()
  }
  
  private func getUserDetails(){
    viewModel.getUser(id: viewModel.selectedUser.id!).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
          print("Couldn't get users: \(error)")
      case  .finished:
        break
      }
    }, receiveValue: { user in
      self.viewModel.selectedUser = user
      self.setupDetails()
    })
  .store(in: &subscriptions)
  }
  
  private func setupDetails(){
    firstNameTxt.text = viewModel.isNew ? "" : viewModel.selectedUser!.firstName
    lastNameTxt.text = viewModel.isNew ? "" : viewModel.selectedUser!.lastName
    emailTxt.text = viewModel.isNew ? "" : viewModel.selectedUser!.email
    emailTxt.isHidden = viewModel.isNew ? false : viewModel.selectedUser!.email?.isEmpty ?? true
  }
  
 private func configureUI(){
   parentStack = UIStackView()
   parentStack.axis = .vertical
   parentStack.distribution = .fill
   parentStack.spacing = 30
   parentStack.alignment = .fill
   
   parentStack.translatesAutoresizingMaskIntoConstraints = false
   self.view.addSubview(parentStack)

   NSLayoutConstraint.activate([
    parentStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
    parentStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
    parentStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
   ])
   
   update = UIButton()
   update.setTitle(viewModel.isNew ? "Create User" : "Update User", for: .normal)
   update.addTarget(self, action: #selector(updateClicked),
                    for: .touchUpInside)
   update.setTitleColor(.black, for: .normal)
   update.frame = CGRect(x: 0, y: 0, width: parentStack.frame.width, height: 60)
   update.layer.borderColor = UIColor.gray.cgColor
   update.layer.borderWidth = 2.0
   update.layer.cornerRadius = 8.0
   
   setupFirstName()
   setupLastName()
   setupEmail()
   
   parentStack.addArrangedSubview(update)
  }
  
  private func setupFirstName(){
   
    firstNameTxt = UITextField()
    firstNameTxt.font = .boldSystemFont(ofSize: 12)
    firstNameTxt.borderStyle = .roundedRect
    firstNameTxt.placeholder = "First name"
    parentStack.addArrangedSubview(firstNameTxt)

  }
  
  private func setupLastName(){
    lastNameTxt = UITextField()
    lastNameTxt.font = .boldSystemFont(ofSize: 12)
    lastNameTxt.borderStyle = .roundedRect
    lastNameTxt.placeholder = "Last name"

    parentStack.addArrangedSubview(lastNameTxt)
  }
  
  private func setupEmail(){
    emailTxt = UITextField()
    emailTxt.font = .boldSystemFont(ofSize: 12)
    emailTxt.borderStyle = .roundedRect
    emailTxt.placeholder = "Email"

    parentStack.addArrangedSubview(emailTxt)
  }
  
  @objc func updateClicked(sender:UIButton)
  {
    viewModel.isNew ? createUser() : updateUser()
  }
  
  private func createUser(){
    viewModel.createUser(payload: User(firstName: firstNameTxt.text!, lastName: lastNameTxt.text!, email: emailTxt.text!)).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
          print("Couldn't get users: \(error)")
      case  .finished:
          AlertView.instance.showAlert(message: "Email is invalid or regiuster before", alertType:.success)
        break
      }
    }, receiveValue: { users in
      self.fetchUpdatedList()
    })
  .store(in: &subscriptions)
  }
  
  
  private func updateUser(){
    viewModel.updateUser(id: viewModel.selectedUser.id!, payload: User(firstName: firstNameTxt.text ?? "", lastName: lastNameTxt.text ?? "", email: emailTxt.text ?? "")).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
          print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { users in
      self.fetchUpdatedList()
    })
  .store(in: &subscriptions)
  }
  
  private func fetchUpdatedList(){
//    viewModel.getUsers(true).sink(receiveCompletion: { (completion) in
//      switch completion {
//      case let .failure(error):
//          print("Couldn't get users: \(error)")
//      case .finished: break
//      }
//    }, receiveValue: { users in
//      self.viewModel.myUsers = users.data
//      self.navigationController?.popViewController(animated: true)
//    })
//  .store(in: &subscriptions)
  }
}
