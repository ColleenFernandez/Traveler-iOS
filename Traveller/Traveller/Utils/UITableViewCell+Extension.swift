//
//  UITableViewCell+Extension.swift
//  EveraveUpdate
//
//  Created by Mac on 6/19/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewCell {
    var getParentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

