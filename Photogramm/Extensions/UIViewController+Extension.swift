//
//  UIViewController+Extension.swift
//  Photogramm
//
//  Created by User on 20.04.2022.
//

import UIKit

extension UIViewController {
    @discardableResult
    func showAlert(_ title: String = "", message: String = "", showCancel: Bool = false, cancelTitle: String = "Отмена", okTitle: String = "OK", present: Bool = true, completion: (() -> ())? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if completion == nil {
            alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: nil))
        }
        else {
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                completion?()
            }))
            if showCancel {
                alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
            }
        }
        
        if present {
            if presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: false) { () -> Void in
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
        
        return alert
    }

    @discardableResult
    func showError(_ error: Error, completion: (() -> ())? = nil) -> UIAlertController {
        return showAlert(error.localizedTitle, message: error.localizedDescription, completion: completion)
    }
}
