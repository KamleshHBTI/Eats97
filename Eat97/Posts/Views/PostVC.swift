//
//  PostVC.swift
//  PostVC
//
//  Created by Kamlesh on 22/10/21.
//

import Foundation
import UIKit
import Combine

class PostVC:UIViewController{
  
  lazy var postTblView: UITableView = {
    let tblView = UITableView()
    tblView.delegate = self
    tblView.dataSource = self
    tblView.register(PostCell.self, forCellReuseIdentifier: "cell")
    return tblView
  }()
  
  lazy var viewModel = PostViewModel(networkManagerProtocol: NetworkManager())
  private var cancellable: Set<AnyCancellable> = []
  var subscriptions = Set<AnyCancellable>()

  //MARK: ViewDidload
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel.getPost()
  }
  
  //MARK: SetupUI
  private func setupUI(){
    setupTableView()
    setupNavigationBar()
    viewModelBinding()
    configureNavBar()
  }
  
  //MARK: Setup tableview
  private func setupTableView(){
    view.addSubview(postTblView)
    postTblView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [postTblView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                       postTblView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                       postTblView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
                       postTblView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  //MARK: Setup ViewModel Binding
  private func viewModelBinding(){
    viewModel.objectWillChange.sink { [weak self] in
      guard let _ = self else {
        return
      }
      self?.postTblView.reloadData()
    }.store(in: &cancellable)
  }
  
  private func configureNavBar(){
    let createUser = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(createPost))
    createUser.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem  = createUser
  }
  
  //MARK: Create post
  @objc func createPost(sender: UIButton){
    let vc = CreatePostVC.instantiateFromStoryboard()
    vc.viewModel = viewModel
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension PostVC: UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell else {
      fatalError()
    }
    cell.configurePost(post: viewModel.posts[indexPath.row])
    return cell
  }
  
  
}

extension PostVC: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let userToDelete = viewModel.posts.remove(at: indexPath.row)
      
      viewModel.deletePost(id: userToDelete.id).sink(receiveCompletion: { (completion) in
        DispatchQueue.main.async {
          self.postTblView.deleteRows(at: [indexPath], with: .fade)
        }
        switch completion {
        case let .failure(error):
          print("Couldn't get users: \(error)")
        case .finished: break
        }
      }, receiveValue: { user in
        print(user)
      })
        .store(in: &subscriptions)
    }
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastItem = viewModel.posts.count - 1
    if indexPath.row == lastItem {
      if viewModel.postDetails.page < viewModel.postDetails.total {
        var pages = viewModel.postDetails.page
        pages += 1
        viewModel.postDetails.page = pages
        self.postTblView.tableFooterView = postTblView.getFooterView()
        self.postTblView.tableFooterView?.isHidden = false
        viewModel.getPost(page: pages)
      }
    }
  }
}
