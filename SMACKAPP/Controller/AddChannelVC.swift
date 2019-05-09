//
//  AddChannelVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 5/2/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet var Vieww: UIView!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var chanDesc: UITextField!
    @IBOutlet var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closetap = UITapGestureRecognizer(target: self, action:  #selector(AddChannelVC.Closetap(_:)))
        bgView.addGestureRecognizer(closetap)
    
        
    }

    @IBAction func CreateChannel(_ sender: Any) {
        guard let channelName = nameTxt.text, nameTxt.text != "" else {return}
        guard let channelDes = chanDesc.text, chanDesc.text != "" else {return}
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDes) { (success) in
            if success {
                self.dismiss(animated: true, completion: {
                    
                })
            }
        }
    }
    
    @objc func Closetap(_ recognize: UITapGestureRecognizer ){
        dismiss(animated: true, completion: nil)
    }
    

}
