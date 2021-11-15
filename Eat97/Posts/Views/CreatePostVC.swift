//
//  CreatePostVC.swift
//  CreatePostVC
//
//  Created by Kamlesh on 22/10/21.
//

import Foundation
import UIKit
import Combine

class CreatePostVC: UIViewController{
  private var imageTxt: UITextField!
  private var likeTxt: UITextField!
  private var messageTxt: UITextField!
  private var tagText: UITextField!
  private var update: UIButton!
  private var parentStack: UIStackView!
  
  weak var viewModel: PostViewModel!
  var subscriptions = Set<AnyCancellable>()
  private var cancellable: Set<AnyCancellable> = []

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
   update.setTitle("Create Post", for: .normal)
   update.addTarget(self, action: #selector(updateClicked),
                    for: .touchUpInside)
   update.setTitleColor(.black, for: .normal)
   update.frame = CGRect(x: 0, y: 0, width: parentStack.frame.width, height: 60)
   update.layer.borderColor = UIColor.gray.cgColor
   update.layer.borderWidth = 2.0
   update.layer.cornerRadius = 8.0
   
   setupImageTxt()
   setupLikeTxt()
   setupMessageTxt()
   setupTagText()
   
   parentStack.addArrangedSubview(update)
  }
  
  private func setupImageTxt(){
   
    imageTxt = UITextField()
    imageTxt.font = .boldSystemFont(ofSize: 12)
    imageTxt.borderStyle = .roundedRect
    imageTxt.keyboardType = .URL
    imageTxt.placeholder = "Enter image url here"
    parentStack.addArrangedSubview(imageTxt)
  }
  
  private func setupLikeTxt(){
    likeTxt = UITextField()
    likeTxt.keyboardType = .numberPad
    likeTxt.font = .boldSystemFont(ofSize: 12)
    likeTxt.borderStyle = .roundedRect
    likeTxt.placeholder = "Enter number of likes here"

    parentStack.addArrangedSubview(likeTxt)
  }
  
  private func setupMessageTxt(){
    messageTxt = UITextField()
    messageTxt.font = .boldSystemFont(ofSize: 12)
    messageTxt.borderStyle = .roundedRect
    messageTxt.placeholder = "Enter message here"

    parentStack.addArrangedSubview(messageTxt)
  }
  
  private func setupTagText(){
    tagText = UITextField()
    tagText.font = .boldSystemFont(ofSize: 12)
    tagText.borderStyle = .roundedRect
    tagText.placeholder = "Enter tags with comma seperated"

    parentStack.addArrangedSubview(tagText)
  }
  
  @objc func updateClicked(sender:UIButton)
  {
    createPost()
  }
  
  private func createPost(){
    let rendomPost = viewModel.posts.randomElement()
    let tags = tagText.text?.split(separator: ",").map{String($0)}
    let payload = PayloadPost(id: nil, image: (imageTxt.text ?? rendomPost?.image)!, likes: Int(likeTxt.text ?? "0"), tags:tags, text: messageTxt.text ?? "", owner: (rendomPost?.owner.id!)!, post: rendomPost!.id)
    viewModel.createPost(payload: payload).sink(receiveCompletion: { (completion) in
      switch completion {
      case let .failure(error):
        print("Couldn't get users: \(error)")
      case .finished: break
      }
    }, receiveValue: { posts in
      self.navigationController?.popViewController(animated: true)
    })
      .store(in: &subscriptions)
  }
  
}
