//
//  LoginVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SocketIO

class LoginVC: UIViewController {
    
    static let instance = LoginVC()
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    @IBAction func loginButoonPressed(_ sender: Any) {
        
        guard let userName = userName.text, self.userName.text != "" else {
            return showAlertLogicVC(title: "Nofication", message: "Vui lòng điền Username")}
        
        guard let pass = password.text, password.text != "" else {
            return showAlertLogicVC(title: "Nofication", message: "Vui lòng điền Password")}
        
        if userName != "" && pass != "" {
            spinner.isHidden = false
            spinner.startAnimating()
            AuthService.instance.loginUser(email: userName, password: pass) { (success) in
                if success {
                    AuthService.instance.findUserByEmail(completion: {(success) in
                        if success {
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    
    
    @IBAction func CloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "ToAccountLogin", sender: nil)
        
    }
    
    func setUpView(){
       spinner.isHidden = true
        userName.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: purpleColorForTextfield])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: purpleColorForTextfield])
        
    }
    
    func showAlertLogicVC(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
