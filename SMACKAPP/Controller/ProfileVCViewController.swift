//
//  ProfileVCViewController.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/1/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit



class ProfileVCViewController: UIViewController {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var avatarProfile: RoundedImage!
    @IBOutlet var nameProfile: UILabel!
    @IBOutlet var emailProfile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.layer.cornerRadius = 5
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoggOutButton(_ sender: Any) {
        UserDataServices.instance.LoggoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setupView () {
        self.avatarProfile.image = UIImage(named: UserDataServices.instance.avatarName)
        self.avatarProfile.backgroundColor = UserDataServices.instance.returnUIColor(component: UserDataServices.instance.avatarColor)
        self.nameProfile.text = UserDataServices.instance.name
        self.nameProfile.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.emailProfile.text = UserDataServices.instance.email
        self.emailProfile.textColor = UIColor.black
        view.layer.cornerRadius = 5
        
        let closetap = UITapGestureRecognizer(target: self, action:  #selector(ProfileVCViewController.Closetap(_:)))
        bgView.addGestureRecognizer(closetap)
        
        
    }
    
    @objc func Closetap(_ recognize: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
