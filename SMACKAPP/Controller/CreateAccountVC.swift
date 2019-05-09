//
//  CreateAccountVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/23/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var BGColor: UIColor?
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDataServices.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataServices.instance.avatarName)
            avatarName = UserDataServices.instance.avatarName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    @IBAction func CreateAccountPressed(_ sender: Any) {
        
        guard let name = usernameTxt.text, usernameTxt.text != "" else {
            return showAlertCreateAccountVC(title: "Nofication", message: "Vui lòng điền Username")
        }
        
        guard let email = emailTxt.text, emailTxt.text != "" else {
            return showAlertCreateAccountVC(title: "Nofication", message: "Vui lòng điền Email")
        }
        
        guard let password = passTxt.text, passTxt.text != "" else {
            return showAlertCreateAccountVC(title: "Nofication", message: "Vui lòng điền password")
        }
        
        if name != "" && email != "" && password != "" {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            
            AuthService.instance.registerUser(email: email, password: password) { (success) in
                if success {    
                    AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                        if success {
                            AuthService.instance.AddUser(name: name,email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                                if success {
                                    print("THANH CONG")
                                    self.spinner.stopAnimating()
                                    self.spinner.isHidden = true
                                    self.performSegue(withIdentifier: "UNWIND", sender: nil)
                                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: "CreateAccountVCtoPickerAvatarVC", sender: nil)
    }
    
    @IBAction func ChangeAvatarColor(_ sender: Any) {
    }
    
    @IBAction func AvatarPickerVCtoCreateAccountVC(unwind: UIStoryboardSegue) {
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        
        BGColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        UIView.animate(withDuration: 0.3) {
            self.userImg.backgroundColor = self.BGColor
//            self.usernameTxt.textColor = self.BGColor
//            self.passTxt.textColor = self.BGColor
//            self.emailTxt.textColor = self.BGColor
            
        }
        avatarColor = "[\(r), \(g), \(b), 1]"
    }
    
    func setupView() {
        spinner.isHidden = true
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: purpleColorForTextfield])
        passTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: purpleColorForTextfield])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: purpleColorForTextfield])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    func showAlertCreateAccountVC(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
