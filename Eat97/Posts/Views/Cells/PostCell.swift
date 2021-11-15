//
//  PostCell.swift
//  PostCell
//
//  Created by Kamlesh on 22/10/21.
//

import Foundation
import UIKit
import Combine

class PostCell: UITableViewCell{
  private var ownerImage: UIImageView!
  private var ownerName: UILabel!
  private var postedTime: UILabel!
  
  private var title: UILabel!
  private var postImage: UIImageView!
  private var likeLbl: UILabel!
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?

  override public func prepareForReuse() {
    super.prepareForReuse()
    postImage.image = nil
    postImage.alpha = 0.0
    likeLbl.text = nil
    title.text = nil
//    setUpOwner()
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  
  private func setUpOwner(){
    ownerName.text = nil
    ownerImage.image = nil
    ownerImage.alpha = 0.0
    postedTime.text = nil
  }
  
  func configurePost(post: Post){
    setupUI()
    title.text = post.text
    likeLbl.text =  "👍🏻 " + String(post.likes!)
    cancellable = loadImage(for: post).sink { [unowned self] image in self.showImage(image: image) }
//    configureOwnerDetails(post.owner)
  }
  
  private func configureOwnerDetails(_ owner: Owner){
    ownerName.text = owner.firstName + " " + owner.lastName
    postedTime.text = owner.title
    cancellable = loadImage(for: owner).sink { [unowned self] image in self.showImage(image: image) }

  }
  
  private func loadImage(for owner: Owner) -> AnyPublisher<UIImage?, Never> {
    return Just(owner.picture)
      .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
        let url = URL(string: owner.picture )
        return ImageLoader.shared.loadImage(from: url ?? URL(fileURLWithPath: ""))
      })
      .eraseToAnyPublisher()
  }
  
  private func loadImage(for post: Post) -> AnyPublisher<UIImage?, Never> {
    return Just(post.image)
      .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
        let url = URL(string: post.image ?? "" )
        return ImageLoader.shared.loadImage(from: url ?? URL(fileURLWithPath: ""))
      })
      .eraseToAnyPublisher()
  }
  
  private func showImage(image: UIImage?) {
    postImage.alpha = 0.0
    animator?.stopAnimation(false)
    postImage.image = (image != nil) ? image : UIImage(named: "img")
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.postImage.alpha = 1.0
    })
  }
  
  private func setupUI() {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
    
    postImage = UIImageView()
    NSLayoutConstraint.activate([
      postImage.widthAnchor.constraint(equalToConstant: self.contentView.frame.width),
      postImage.heightAnchor.constraint(equalToConstant: 300),
    ])
    postImage.contentMode = .scaleAspectFit
    
    title = UILabel()
    title.font = .boldSystemFont(ofSize: 14)
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    
    likeLbl = UILabel()
    likeLbl.font = .boldSystemFont(ofSize: 12)
    likeLbl.numberOfLines = 0
    likeLbl.lineBreakMode = .byWordWrapping
//    stackView.addArrangedSubview(ownerSetUI())
    stackView.addArrangedSubview(title)
    stackView.addArrangedSubview(postImage)
    stackView.addArrangedSubview(likeLbl)
  }
  
  private func ownerSetUI() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
    
    ownerImage = UIImageView()
    stackView.addArrangedSubview(ownerImage)
    NSLayoutConstraint.activate([
      ownerImage.widthAnchor.constraint(equalToConstant: 40),
      ownerImage.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    ownerName = UILabel()
    ownerName.font = .boldSystemFont(ofSize: 14)
    ownerName.numberOfLines = 0
    ownerName.lineBreakMode = .byWordWrapping
    
    postedTime = UILabel()
    postedTime.font = .boldSystemFont(ofSize: 12)
    postedTime.numberOfLines = 0
    postedTime.lineBreakMode = .byWordWrapping

    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.distribution = .equalSpacing
    textStackView.alignment = .leading
    textStackView.spacing = 4
    textStackView.addArrangedSubview(ownerName)
    textStackView.addArrangedSubview(postedTime)
    
    stackView.addArrangedSubview(textStackView)
    return stackView
  }
  
  

}

