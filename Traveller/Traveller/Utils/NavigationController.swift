//
//  Navigation+rootViewController.swift
//  EveraveUpdate
//
//  Created by Ubuntu on 12/20/19.
//  Copyright © 2019 Ubuntu. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(red:0.00, green:0.20, blue:0.40, alpha:1.0)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
 //---------------------------------------------------------------------------------------------------------------------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent
    }
}
