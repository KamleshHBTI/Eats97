//
//  ViewController.swift
//  Eat97
//
//  Created by Kamlesh on 21/10/21.
//

import UIKit
import Combine

class UsersVC: UIViewController {
  
  lazy var usersList: UITableView = {
    let tblView = UITableView()
    tblView.delegate = self
    tblView.dataSource = self
    tblView.register(UserCell.self, forCellReuseIdentifier: "cell")
    return tblView
  }()
  
  var subscriptions = Set<AnyCancellable>()
  private var cancellable: Set<AnyCancellable> = []
  
  lazy var viewModel = UserViewModel(networkManagerProtocol: NetworkManager())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindViewModel()
    viewModel.getUsers()
  }
  
  private func configureUI(){
    setupNavigationBar()
    setupTblView()
    configureNavBar()
  }
  
  private func bindViewModel() {
    viewModel.objectWillChange.sink { [weak self] in
      guard let _ = self else {
        return
      }
      self?.usersList.reloadData()
    }.store(in: &cancellable)
  }
  
  private func configureNavBar(){
    let createUser = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(createUser))
    createUser.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem  = createUser
  }

  private func setupTblView(){
    view.addSubview(usersList)
    usersList.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [usersList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                       usersList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                       usersList.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
                       usersList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  @objc func createUser(action: UIBarButtonItem){
    let vc = UserDetails.instantiateFromStoryboard()
    viewModel.isNew = true
    vc.viewModel = viewModel
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension UsersVC: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserCell else{
      fatalError()
    }
    cell.configureUser(user: viewModel.users[indexPath.row])
    return cell
  }
  
}

extension UsersVC: UITableViewDelegate{
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let userToDelete = viewModel.users.remove(at: indexPath.row)
      
      viewModel.deleteUser(id: userToDelete.id!).sink(receiveCompletion: { (completion) in
        switch completion {
        case let .failure(error):
          print("Couldn't get users: \(error)")
        case .finished: break
        }
      }, receiveValue: { user in
        self.usersList.deleteRows(at: [indexPath], with: .fade)
        print(user)
      })
        .store(in: &subscriptions)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UserDetails.instantiateFromStoryboard()
    viewModel.selectedUser = viewModel.users[indexPath.row]
    vc.viewModel = viewModel
    viewModel.isNew = false
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastItem = viewModel.users.count - 1
    if indexPath.row == lastItem {
      if Int(viewModel.objUsers.page ?? 0) < Int(viewModel.objUsers.total ?? 0) {
        var pages = Int(viewModel.objUsers.page ?? 0)
        pages += 1
        viewModel.objUsers.page = Double(pages)
        self.usersList.tableFooterView = usersList.getFooterView()
        self.usersList.tableFooterView?.isHidden = false
        viewModel.getUsers(pages)
      }
    }
  }
}
