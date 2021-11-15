//
//  CreateUpdateCommentVC.swift
//  CreateUpdateCommentVC
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import UIKit
import Combine

class CreateUpdateCommentVC: UIViewController{
  private var commentTxt: UITextField!
  private var imageTxt:UITextField!
  private var update: UIButton!
  private var parentStack: UIStackView!
  
  weak var viewModel: CommentViewModel!
  var subscriptions = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
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
   update.setTitle("Create Comment", for: .normal)
   update.addTarget(self, action: #selector(updateClicked),
                    for: .touchUpInside)
   update.setTitleColor(.black, for: .normal)
   update.frame = CGRect(x: 0, y: 0, width: parentStack.frame.width, height: 60)
   update.layer.borderColor = UIColor.gray.cgColor
   update.layer.borderWidth = 2.0
   update.layer.cornerRadius = 8.0
   
   setupCommentTxt()
   setupImageTxt()
   parentStack.addArrangedSubview(update)
  }
  
  private func setupCommentTxt(){
   
    commentTxt = UITextField()
    commentTxt.font = .boldSystemFont(ofSize: 12)
    commentTxt.borderStyle = .roundedRect
    commentTxt.placeholder = "Enter comment here"
    parentStack.addArrangedSubview(commentTxt)

  }
  
  private func setupImageTxt(){
    imageTxt = UITextField()
    imageTxt.font = .boldSystemFont(ofSize: 12)
    imageTxt.borderStyle = .roundedRect
    imageTxt.keyboardType = .URL
    imageTxt.placeholder = "Enter owner image url here"
    parentStack.addArrangedSubview(imageTxt)
  }
  
  @objc func updateClicked(sender:UIButton)
  {
    createComment()
  }
  
  private func createComment(){
    let rendomComment = viewModel.comments.randomElement()
    let image:String! = imageTxt.text!.isEmpty ? rendomComment?.owner.picture : imageTxt.text
    viewModel.createComment(payload: PayloadComment(message: commentTxt.text!, owner: (rendomComment?.owner.id)!, post: (rendomComment?.post)!, picture: image)).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
          print("Couldn't get users: \(error)")
      case  .finished:
        break
      }
    }, receiveValue: { users in
      self.navigationController?.popViewController(animated: true)
    })
  .store(in: &subscriptions)
  }
  
  

}
