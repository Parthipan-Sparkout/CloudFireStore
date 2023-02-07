//
//  UIViewController+Extension.swift
//  CloudFirestore
//
//  Created by Sparkout on 07/02/23.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withMessage: String) {
        let alert = UIAlertController(title: "Alert!", message: withMessage, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}
