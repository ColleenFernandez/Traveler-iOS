//
//  EmailLoginVC.swift
//  Traveller
//
//  Created by top Dev on 16.02.2021.
//

import UIKit

class EmailLoginVC: BaseVC {

    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setEdtPlaceholder(edt_email, placeholderText:"Email", placeColor: UIColor.lightGray, padding: .left(20))
        setEdtPlaceholder(edt_password, placeholderText:"Password", placeColor: UIColor.lightGray, padding: .left(20))
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        let email = self.edt_email.text ?? ""
        let password = self.edt_password.text ?? ""
        
        if email.isEmpty{
            self.showToast("Please input your email")
            return
        }
        if !email.isValidEmail(){
            self.showToast("Please input your valid email")
            return
        }
        
        if password.isEmpty{
            self.showToast("Please input your password")
            return
        }else{
            self.showLoadingView(vc: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideLoadingView()
                self.gotoTabControllerWithIndex(0)
            }
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.gotoVC("LoginVCNav")
    }
}
