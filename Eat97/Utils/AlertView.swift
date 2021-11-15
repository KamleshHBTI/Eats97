//
//  AlertView.swift
//  CustomAlert
//
//  Created by Kamlesh on 20/10/21.
//

import Foundation
import UIKit

class AlertView: UIView {
  
  static let instance = AlertView()
  
  @IBOutlet var parentView: UIView!
  @IBOutlet weak var alertView: UIView!
  @IBOutlet weak var messageLbl: UILabel!
  @IBOutlet weak var doneBtn: UIButton!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func commonInit() {
    
    alertView.layer.cornerRadius = 10
    parentView.backgroundColor = .white
    parentView.alpha = 0.5
    doneBtn.layer.cornerRadius = 5.0
    parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  enum AlertType {
    case success
    case failure
  }
  
  func showAlert(message: String, alertType: AlertType) {
    self.messageLbl.text = message
    
    switch alertType {
    case .success:
      doneBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    case .failure:
      doneBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    UIApplication.shared.keyWindow?.addSubview(parentView)
  }
  
  
  
  @IBAction func onClickDone(_ sender: Any) {
    parentView.removeFromSuperview()
  }
  
}
