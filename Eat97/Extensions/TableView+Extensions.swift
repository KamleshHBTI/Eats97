//
//  TableView+Extensions.swift
//  TableView+Extensions
//
//  Created by Kamlesh on 23/10/21.
//

import Foundation
import UIKit

extension UITableView{
  
  func getFooterView() -> UIActivityIndicatorView{
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.color = .darkGray
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(50))
    return spinner
  }
  
}
