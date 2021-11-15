//
//  File.swift
//  File
//
//  Created by Kamlesh on 20/10/21.
//

import Foundation
import UIKit
class MenuVC: UIViewController{
  
  @IBOutlet weak var tabBar: UITabBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBar.delegate = self
    view.insertSubview(TabItem.users.view , belowSubview: self.tabBar)
  }
  
}

extension MenuVC: UITabBarDelegate{
  func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    switch item.tag {
    case 1:
      self.view.insertSubview(TabItem.users.view , belowSubview: self.tabBar)
      break
    case 2:
      break
    case 3:
      break
    default:
      break
    }
  }
}
