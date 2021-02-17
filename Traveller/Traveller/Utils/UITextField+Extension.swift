//
//  UIText+Extension.swift
//  bumerang
//
//  Created by RMS on 2019/9/15.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

class CustomTextField: UITextField {
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y + paddingTop, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height - paddingTop - paddingBottom);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension UITextField {
    enum PaddingSide1 {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding1(_ padding: PaddingSide1) {
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        switch padding {
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = .always
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

extension UITextField {
    func configure(color: UIColor = .blue,
                   font: UIFont = UIFont.boldSystemFont(ofSize: 12),
                   cornerRadius: CGFloat,
                   borderColor: UIColor? = nil,
                   backgroundColor: UIColor,
                   borderWidth: CGFloat? = nil) {
        if let borderWidth = borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        self.layer.cornerRadius = cornerRadius
        self.font = font
        self.textColor = color
        self.backgroundColor = backgroundColor
    }
}

extension UITextField {
    func setBottomBorder(width:CGFloat = 1) {
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setPlaceHolderColor(){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func setLeftView() {
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 35))
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    func addInputViewDatePicker(target: Any, selector: Selector,mode:String) {
        let screenWidth = UIScreen.main.bounds.width
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        if mode == "date" {
             datePicker.datePickerMode = .date
        }else{
             datePicker.datePickerMode = .dateAndTime
        }
        self.inputView = datePicker
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}
