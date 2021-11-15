//
//  TabBar.swift
//  TabBar
//
//  Created by Kamlesh on 20/10/21.
//

import Foundation
import UIKit

enum TabItem: String, CaseIterable {
  case users = "users"
  case posts = "posts"
  case comments = "comments"
  case tags = "tags"
  
  var view: UIView {
    switch self {
    case .users:
      return UsersVC().view
    case .posts:
      return UsersVC.instantiateFromStoryboard().view
    case .comments:
      return UsersVC.instantiateFromStoryboard().view
    case .tags:
      return UsersVC.instantiateFromStoryboard().view
    }
  }
  
  var displayTitle: String {
    return self.rawValue.capitalized(with: nil)
  }
}

extension UIViewController
{
  class func instantiateFromStoryboard(_ name: String = "Main") -> Self
  {
    return instantiateFromStoryboardHelper(name)
  }
  
  fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
  {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    return controller
  }
  
}
