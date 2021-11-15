//
//  PostCell.swift
//  PostCell
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import UIKit
import Combine

class TagCell: UICollectionViewCell{
  
  var tagLbl: UILabel?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    tagLbl?.text = nil
    setupLabel()
  }
  
  private func setupLabel(){
    tagLbl = UILabel()
    tagLbl?.numberOfLines = 0
    tagLbl?.font = .systemFont(ofSize: 14)
    
    contentView.addSubview(tagLbl!)
    tagLbl!.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagLbl!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      tagLbl!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      tagLbl!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      tagLbl!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
  }
  
  func configureTag(tag: String){
    self.tagLbl?.text = tag
    self.tagLbl?.tintColor = .red
  }
  
}

