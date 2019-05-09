//
//  ChannelVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit
import SocketIO

class ChannelVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var addChannelButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var avatarLogin: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width
        self.avatarLogin.layer.cornerRadius = self.avatarLogin.frame.width / 2
        self.loginBtn.titleLabel?.numberOfLines = 3
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.UserDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addChannelButton(_ sender: Any) {
        if AuthService.instance.isLogginIn{
            let addchannelVC = AddChannelVC()
            addchannelVC.modalPresentationStyle = .custom
            present(addchannelVC, animated: true, completion: nil)
        } else {
            showAlertChannelVC(title: "Notification", message: "Please Login User")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthService.instance.isLogginIn {
            self.avatarLogin.image = UIImage(named: UserDataServices.instance.avatarName)
            self.avatarLogin.backgroundColor = UserDataServices.instance.returnUIColor(component: UserDataServices.instance.avatarColor)
            self.loginBtn.setTitle(UserDataServices.instance.name, for: .normal)
//            self.loginBtn.setTitleColor(UserDataServices.instance.returnUIColor(component: UserDataServices.instance.avatarColor), for: .normal)
            
        } else {
            loginBtn.setTitle("Login", for: .normal)
            avatarLogin.image = UIImage(named: "girl")
            avatarLogin.backgroundColor = UIColor.clear
            loginBtn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    @objc func UserDataDidChange(_ nofify: Notification){
        if AuthService.instance.isLogginIn {
            self.avatarLogin.image = UIImage(named: UserDataServices.instance.avatarName)
            self.avatarLogin.backgroundColor = UserDataServices.instance.returnUIColor(component: UserDataServices.instance.avatarColor)
            self.loginBtn.setTitle(UserDataServices.instance.name, for: .normal)
            //self.loginBtn.setTitleColor(UserDataServices.instance.returnUIColor(component: UserDataServices.instance.avatarColor), for: .normal)
            MessageServices.instance.findAllChannel { (success) in
                if success {
                    self.tableView.reloadData()
                } else {
                    print("không tim đc")
                }
            }
        } else {
            loginBtn.setTitle("Login", for: .normal)
            avatarLogin.image = UIImage(named: "girl")
            avatarLogin.backgroundColor = UIColor.clear
            loginBtn.setTitleColor(UIColor.black, for: .normal)
            MessageServices.instance.removeChannel()
            self.tableView.reloadData()
        }
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLogginIn {
            let profileVC = ProfileVCViewController()
            profileVC.modalPresentationStyle = .custom
            present(profileVC, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "loginVC", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell {
            let channel = MessageServices.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let channel = MessageServices.instance.channels[indexPath.row]
        MessageServices.instance.selectedChannel = channel
        self.revealViewController()?.revealToggle(animated: true)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func showAlertChannelVC(title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
   //Back Button From...
    @IBAction func BackfromLoginVC(unwind: UIStoryboardSegue){}
    @IBAction func BackfromCreateAccountVC(unwind: UIStoryboardSegue){}
    
    
    
    
    
}
