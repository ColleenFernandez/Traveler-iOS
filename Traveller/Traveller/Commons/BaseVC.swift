//
//  BaseVC.swift
//  meets
//
//  Created by top Dev on 9/20/20.
//

import UIKit
import Toast_Swift
import SwiftyUserDefaults
import SwiftyJSON
import MBProgressHUD
import Foundation
import IQKeyboardManagerSwift
import SafariServices

class DarkVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseVC: UIViewController {

    var hud: MBProgressHUD?
    var alertController : UIAlertController? = nil
    var is_allow_swipe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !(self.hud?.isHidden ?? false){
            self.hideLoadingView()
        }
    }
    
    func gotoWebViewWithProgressBar(_ link: String, title: String = "")  {
//        let browser = KAWebBrowser()
//        browser.str_title = title
//        show(browser, sender: nil)
//        browser.loadURLString(link)
        
        if let url = URL(string: link) {
            let controller = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            //vc.delegate = self
            controller.dismissButtonStyle = .close
            controller.configuration.barCollapsingEnabled = true
            present(controller, animated: true)
        }
    }
   
    func showLoginAlert() {
        let alertController = UIAlertController(title: nil, message: "Please login to use this feature!", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            self.gotoVC("LoginVCNav")
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = COLORS.PRIMARY
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func hideNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // for general part for common project
    func gotoVC(_ nameVC: String, animated: Bool = true){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: nameVC)
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: animated, completion: nil)
    }
    
    func gotoVCModal(_ name: String) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)
        targetVC.modalPresentationStyle = .overFullScreen
        //targetVC.modalTransitionStyle = .crossDissolve
        self.present(targetVC, animated: false, completion: nil)
    }
    
    func gotoStoryBoardVC(_ name: String, fullscreen: Bool) {
        let storyboad = UIStoryboard(name: name, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: name)
        if fullscreen{
            targetVC.modalPresentationStyle = .fullScreen
        }
        self.present(targetVC, animated: false, completion: nil)
    }
    
    func showProgressHUDHUD(view : UIView, mode: MBProgressHUDMode = .annularDeterminate) -> MBProgressHUD {
    
        let hud = MBProgressHUD .showAdded(to:view, animated: true)
        hud.mode = mode
        hud.label.text = "Loading";
        hud.animationType = .zoomIn
        
        hud.contentColor = .white
        return hud
    }
    
    func hideLoadingView() {
       if let hud = hud {
           hud.hide(animated: true)
       }
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_")
        return String(text.filter {okayChars.contains($0) })
    }
    
    func showLoadingView(vc: UIViewController, label: String = "") {
        
        hud = MBProgressHUD .showAdded(to: vc.view, animated: true)
        
        if label != "" {
            hud!.label.text = label
        }
        hud!.mode = .indeterminate
        hud!.animationType = .zoomIn
        hud!.bezelView.color = .clear
        hud!.contentColor = COLORS.PRIMARYDARK
        hud!.bezelView.style = .solidColor
    }
    
    //MARK:- Toast function
    func showToast(_ message : String) {
        self.view.makeToast(message)
    }
    
    func showToast(_ message : String, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = .bottom) {
        self.view.makeToast(message, duration: duration, position: position)
    }
    
    func showToastCenter(_ message : String, duration: TimeInterval = ToastManager.shared.duration) {
        showToast(message, duration: duration, position: .center)
    }
    
    func setEdtPlaceholder(_ edittextfield : UITextField , placeholderText : String, placeColor : UIColor, padding: UITextField.PaddingSide)  {
        edittextfield.attributedPlaceholder = NSAttributedString(string: placeholderText,
        attributes: [NSAttributedString.Key.foregroundColor: placeColor])
        edittextfield.addPadding(padding)
    }
    
    func gotoNavPresent(_ storyname : String, fullscreen: Bool) {
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: storyname)
        if fullscreen{
            toVC?.modalPresentationStyle = .fullScreen
        }else{
            toVC?.modalPresentationStyle = .pageSheet
        }
        self.navigationController?.pushViewController(toVC!, animated: true)
    }
    
    /**func gotoWebViewWithProgressBar(_ link: String, title: String = "")  {
        let browser = KAWebBrowser()
        browser.str_title = title
        show(browser, sender: nil)
        browser.loadURLString(link)
    }*/
    // MARK: UIAlertView Controller
    func alertMake(_ msg : String) -> UIAlertController {
        alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController!
    }
    
    func alertDisplay(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createVC(_ controller_name: String, storyboard_name: String = "Main", is_fullscreen: Bool = true) -> UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboard_name, bundle: nil)
        let toVC = storyBoard.instantiateViewController(withIdentifier: controller_name)
        if is_fullscreen{
            toVC.modalPresentationStyle = .fullScreen
        }else{
            toVC.modalPresentationStyle = .pageSheet
        }
        return toVC
    }
    
    func gotoTabControllerWithIndex(_ index: Int) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let toVC = storyBoard.instantiateViewController( withIdentifier: "TabBarVC") as! UITabBarController
        toVC.selectedIndex = index
        toVC.modalPresentationStyle = .fullScreen
        self.present(toVC, animated: false, completion: nil)
    }
    
    // navigation remove top line and restore
    func removeNavbarTopLine()  {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func restoreNavbarTopLine()  {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    /**func showBottomDlg(storyboard_name: String = "Main", vcname: String)  {
        let configuration = NBBottomSheetConfiguration(animationDuration: 0.4, sheetSize: .fixed(Constants.SCREEN_HEIGHT))
        let bottomSheetController = NBBottomSheetController(configuration: configuration)
        let storyboad = UIStoryboard(name: storyboard_name, bundle: nil)
        let targetVC = storyboad.instantiateViewController(withIdentifier: vcname)
        bottomSheetController.present(targetVC, on: self)
    }*/
}
