//
//  TagVC.swift
//  TagVC
//
//  Created by Kamlesh on 23/10/21.
//

import UIKit
import Combine

class TagVC:UIViewController{
  lazy var viewModel = TagViewModel(networkController: NetworkManager())
  
  lazy var tagsCollView: UICollectionView = {
    var collView = UICollectionView()
    return collView
  }()
  
  private var cancellable: Set<AnyCancellable> = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    viewModelBinding()
    setupNavigationBar()
    self.view.addSubview(tagsCollView)
    viewModel.getComment()
  }
  
  private func setupCollectionView(){
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    layout.minimumLineSpacing = 5
    layout.minimumInteritemSpacing = 5
    tagsCollView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
    tagsCollView.dataSource = self
    tagsCollView.delegate = self
    tagsCollView.backgroundColor = .white
    tagsCollView.collectionViewLayout = layout
    tagsCollView.register(TagCell.self, forCellWithReuseIdentifier: "Cell")
  }
  
  private func viewModelBinding(){
    viewModel.objectWillChange.sink{ [weak self] in
      guard let _ = self else {
        return
      }
      self?.tagsCollView.reloadData()
    }.store(in: &cancellable)
  }

  
}

extension TagVC: UICollectionViewDelegate{
  
}

extension TagVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.tags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TagCell else {
      fatalError()
    }
    cell.layer.borderColor = UIColor.lightGray.cgColor
    cell.layer.borderWidth = 1
    cell.layer.cornerRadius = cell.frame.size.height / 2
    cell.configureTag(tag: viewModel.tags[indexPath.row])
    return cell
  }
  
}

extension TagVC: UICollectionViewDelegateFlowLayout{
  //Use for size
  func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let name: String = viewModel.tags[indexPath.row]
    let size: CGSize = name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0)])
    let sizeNew: CGSize = CGSize.init(width:((size.width  > collectionView.frame.size.width) ? collectionView.frame.size.width - 20 : size.width), height: size.height)
    return sizeNew
  }
}
