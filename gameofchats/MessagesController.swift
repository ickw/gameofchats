//
//  MessagesController.swift
//  gameofchats
//
//  Created by daiki ichikawa on 2017/10/26.
//  Copyright © 2017年 Daiki Ichikawa. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserISLoggedIn()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navConroller = UINavigationController(rootViewController: newMessageController)
        present(navConroller, animated: true, completion: nil)
        
    }
    
    func checkIfUserISLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            // User is not logged in
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    self?.navigationItem.title = dict["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }

    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }

}

