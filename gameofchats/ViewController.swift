//
//  ViewController.swift
//  gameofchats
//
//  Created by daiki ichikawa on 2017/10/26.
//  Copyright © 2017年 Daiki Ichikawa. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }

    func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }

}

