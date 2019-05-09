//
//  ProfileSelected.swift
//  Connected
//
//  Created by Lý Gia Liêm on 5/9/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ProfileSelected: UIViewController {
    @IBOutlet var image: UIImageView!
    @IBOutlet var email: UILabel!
    @IBOutlet var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfile()
        
        let closetap = UITapGestureRecognizer(target: self, action: #selector(Closetap(_:)))
        view.addGestureRecognizer(closetap)
    }
    
    
    @objc func Closetap(_ recognize: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpProfile(){
        
        image.image = UIImage(named: MessageServices.instance.profileUser!.userAvatar)
        name.text = MessageServices.instance.profileUser?.userName
        image.backgroundColor = UserDataServices.instance.returnUIColor(component: MessageServices.instance.profileUser!.userAvatarColor)
        
    }
    
}
