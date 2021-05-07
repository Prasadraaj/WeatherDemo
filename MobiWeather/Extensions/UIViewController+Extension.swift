//
//  UIViewController+Extension.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil )
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
