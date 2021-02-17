//
//  UIButton+Extension.swift
//

import Foundation
import UIKit

extension UIButton {
    
    func applyRoundShadow() {
        //self.backgroundColor = UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
}

// MARK: - round button with round shadow effect
class roundShadowButton: UIButton {
    override func didMoveToWindow() {
        self.backgroundColor =  UIColor(cgColor: UIColor.white.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
}

// MARK: - round button with drop-down shadow effect
class dropShadowDarkButton: UIButton {
    override func didMoveToWindow() {
        //self.backgroundColor =  UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

class dropShadowThemeButton: UIButton {
    override func didMoveToWindow() {
        //self.backgroundColor =  UIColor(cgColor: UIColor.darkGray.cgColor)
        self.layer.cornerRadius = self.height / 2
        //self.setTitleColor(UIColor.white, for: .normal)
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

extension UIButton {
    func configure(color: UIColor = .blue, font: UIFont = UIFont.boldSystemFont(ofSize: 12)) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }

    func configure(icon: UIImage, color: UIColor? = nil) {
        self.setImage(icon, for: .normal)
        if let color = color {
            tintColor = color
        }
    }

    func configure(color: UIColor = .blue,
                   font: UIFont = UIFont.boldSystemFont(ofSize: 12),
                   cornerRadius: CGFloat,
                   borderColor: UIColor? = nil,
                   backgroundColor: UIColor,
                   borderWidth: CGFloat? = nil) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        self.layer.cornerRadius = cornerRadius
    }
}




