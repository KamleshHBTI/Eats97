//
//  PostCell.swift
//  PostCell
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import UIKit
import Combine

class CommentCell: UITableViewCell{
  private var title: UILabel!
  private var ownerName: UILabel!
  private var ownerImage: UIImageView!
  private var message: UILabel!
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    message.text = nil
    title.text = nil
    setUpOwner()
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  
  private func setUpOwner(){
    ownerName.text = nil
    ownerImage.image = nil
    ownerImage.alpha = 0.0
  }
  
  func configureComment(comment: Comment){
    setupUI()
    title.text = comment.owner.title
//    message.text = comment.message.decodeEmoji
    configureOwnerDetails(comment.owner)
  }
  
  private func configureOwnerDetails(_ owner: Owner){
    ownerName.text = owner.firstName + " " + owner.lastName
    cancellable = loadImage(for: owner).sink { [weak self] image in self?.showImage(image: image) }
    
  }
  
  private func loadImage(for owner: Owner) -> AnyPublisher<UIImage?, Never> {
    return Just(owner.picture)
      .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
        let url = URL(string: owner.picture )
        return ImageLoader.shared.loadImage(from: url ?? URL(fileURLWithPath: ""))
      })
      .eraseToAnyPublisher()
  }
  
  private func showImage(image: UIImage?) {
    ownerImage.alpha = 0.0
    animator?.stopAnimation(false)
    ownerImage.image = (image != nil) ? image : UIImage(named: "img")
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.ownerImage.alpha = 1.0
    })
  }
  
  private func setupUI() {
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
    NSLayoutConstraint.activate([
      ownerImage.widthAnchor.constraint(equalToConstant: 40),
      ownerImage.heightAnchor.constraint(equalToConstant: 40),
    ])
    ownerImage.contentMode = .scaleAspectFit
    
    title = UILabel()
    title.font = .boldSystemFont(ofSize: 14)
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    
    ownerName = UILabel()
    ownerName.font = .boldSystemFont(ofSize: 14)
    ownerName.numberOfLines = 0
    ownerName.lineBreakMode = .byWordWrapping
    
    message = UILabel()
    message.font = .boldSystemFont(ofSize: 12)
    message.numberOfLines = 1
    message.lineBreakMode = .byWordWrapping
    
    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.distribution = .equalSpacing
    textStackView.alignment = .leading
    textStackView.spacing = 4
    textStackView.addArrangedSubview(title)
    textStackView.addArrangedSubview(ownerName)
    textStackView.addArrangedSubview(message)
    
    stackView.addArrangedSubview(ownerImage)
    stackView.addArrangedSubview(textStackView)
    
  }
  
}

