//
//  CommentVC.swift
//  CommentVC
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import UIKit
import Combine

class CommentVC: UIViewController{
  var subscriptions = Set<AnyCancellable>()
  
  lazy var commentTblView: UITableView = {
    let tblView = UITableView()
    tblView.delegate = self
    tblView.dataSource = self
    tblView.register(CommentCell.self, forCellReuseIdentifier: "cell")
    return tblView
  }()
  
  lazy var viewModel = CommentViewModel(networkController: NetworkManager())
  private var cancellable: Set<AnyCancellable> = []
  
  //MARK: ViewDidload
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBar()
    configureNavBar()
    viewModel.getComment()
  }
  
  //MARK: SetupUI
  private func setupUI(){
    setupTableView()
    setupNavigationBar()
    viewModelBinding()
  }
  
  
  //MARK: configureNavBar
  private func configureNavBar(){
    let createUser = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(createComment))
    createUser.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem  = createUser
  }
  
  //MARK: createComment
  @objc func createComment(){
    let vc = CreateUpdateCommentVC.instantiateFromStoryboard()
    vc.viewModel = viewModel
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //MARK: Setup tableview
  private func setupTableView(){
    view.addSubview(commentTblView)
    commentTblView.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [commentTblView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                       commentTblView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                       commentTblView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
                       commentTblView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  //MARK: Setup ViewModel Binding
  private func viewModelBinding(){
    viewModel.objectWillChange.sink { [weak self] in
      guard let _ = self else {
        return
      }
      self?.commentTblView.reloadData()
    }.store(in: &cancellable)
  }
}

extension CommentVC: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.comments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath) as? CommentCell else {
      fatalError()
    }
    cell.configureComment(comment: viewModel.comments[indexPath.row])
    return cell
  }
  
}

extension CommentVC: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let userToDelete = viewModel.comments.remove(at: indexPath.row)
      viewModel.deleteComment(id: userToDelete.id!).sink(receiveCompletion: { (completion) in
        DispatchQueue.main.async {
          self.commentTblView.deleteRows(at: [indexPath], with: .fade)
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
    let lastItem = viewModel.comments.count - 1
    if indexPath.row == lastItem {
      if viewModel.commentDetails.page < viewModel.commentDetails.total {
        var pages = viewModel.commentDetails.page
        pages += 1
        viewModel.commentDetails.page = pages
        self.commentTblView.tableFooterView = commentTblView.getFooterView()
        self.commentTblView.tableFooterView?.isHidden = false
        viewModel.getComment(pages)
      }
    }
  }
  
}
