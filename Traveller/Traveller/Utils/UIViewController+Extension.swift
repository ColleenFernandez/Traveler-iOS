//
//  UIViewController+Extension.swift
//  EveraveUpdate
//
//  Created by Mac on 6/19/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import UIKit
import AVFoundation

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController
{
    /*func tabbarStoryBoard()->UIStoryboard {
           return  UIStoryboard(name: "Tabbar", bundle: nil)
    }*/
    
    func addBackButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action:#selector(btnActionBackClicked))
    }
    
    @objc func btnActionBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*func raveStoryBoard()->UIStoryboard {
        return  UIStoryboard(name: "Rave", bundle: nil)
    }
    func mainStoryBoard()->UIStoryboard {
        return  UIStoryboard(name: "Main", bundle: nil)
    }
    
    func chatStoryBoard()->UIStoryboard {
        return  UIStoryboard(name: "Chat", bundle: nil)
    }*/
    
    func showAlerMessage(message:String) {
        let alertController = UIAlertController(title: nil, message:message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

/*extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}*/
