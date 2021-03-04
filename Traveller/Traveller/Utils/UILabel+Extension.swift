//
//  SemiRoundLabel.swift
//  bumerang
//
//  Created by RMS on 2019/9/22.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SemiRoundLabel: UILabel {
     
    @IBInspectable var radius: Int = 5  // Int needed for IBInspectable
//    @IBInspectable var borderColor: UIColor = .black
    @IBInspectable var topLeft: Bool = true
    @IBInspectable var topRight: Bool = false
    @IBInspectable var bottomRight: Bool = true
    @IBInspectable var bottomLeft: Bool = false
  
    override func draw(_ rect: CGRect) {
         
        var corners : UIRectCorner = []
        if topLeft { corners.insert(.topLeft) }
        if topRight { corners.insert(.topRight) }
        if bottomRight { corners.insert(.bottomRight) }
        if bottomLeft { corners.insert(.bottomLeft) }
  
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
  
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
  
//        self.backgroundColor?.setFill()
//        path.fill()
//        borderColor.setStroke()
//        path.stroke()
        let textToDraw = self.attributedText!
        textToDraw.draw(in: rect)
    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
