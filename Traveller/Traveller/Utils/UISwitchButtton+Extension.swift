//
//  UISwitchButtton+Extension.swift
//  EveraveUpdate
//
//  Created by Mac on 5/10/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import Foundation
import UIKit
extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
