//
//  UserCell.swift
//  UserCell
//
//  Created by Kamlesh on 21/10/21.
//

import Foundation
import UIKit
import Combine

class UserCell: UITableViewCell{
  private var title: UILabel!
  private var name: UILabel!
  private var poster: UIImageView!
  private var cancellable: AnyCancellable?
  private var animator: UIViewPropertyAnimator?

  override public func prepareForReuse() {
    super.prepareForReuse()
    poster.image = nil
    poster.alpha = 0.0
    name.text = nil
    title.text = nil
    animator?.stopAnimation(true)
    cancellable?.cancel()
  }
  
  func configureUser(user: User){
    setupUI()
    title.text = user.title
    name.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
    cancellable = loadImage(for: user).sink { [unowned self] image in self.showImage(image: image) }
  }
  
  private func loadImage(for user: User) -> AnyPublisher<UIImage?, Never> {
    return Just(user.picture)
      .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
        let url = URL(string: user.picture ?? "" )
        return ImageLoader.shared.loadImage(from: url ?? URL(fileURLWithPath: ""))
      })
      .eraseToAnyPublisher()
  }
  
  private func showImage(image: UIImage?) {
    poster.alpha = 0.0
    animator?.stopAnimation(false)
    poster.image = (image != nil) ? image : UIImage(named: "img")
    animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
      self.poster.alpha = 1.0
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
    
    poster = UIImageView()
    stackView.addArrangedSubview(poster)
    NSLayoutConstraint.activate([
      poster.widthAnchor.constraint(equalToConstant: 60),
      poster.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    title = UILabel()
    title.font = .boldSystemFont(ofSize: 14)
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    
    name = UILabel()
    name.font = .boldSystemFont(ofSize: 12)
    name.numberOfLines = 0
    name.lineBreakMode = .byWordWrapping

    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.distribution = .equalSpacing
    textStackView.alignment = .leading
    textStackView.spacing = 4
    textStackView.addArrangedSubview(title)
    textStackView.addArrangedSubview(name)
    
    stackView.addArrangedSubview(textStackView)
  }
  

}

