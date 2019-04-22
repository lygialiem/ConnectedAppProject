//
//  ChatVC.swift
//  SMACKAPP
//
//  Created by Lý Gia Liêm on 4/22/19.
//  Copyright © 2019 LGL. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet var menuBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        
        
    }
}
