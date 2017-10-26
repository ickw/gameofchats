//
//  LoginController+handler.swift
//  gameofchats
//
//  Created by daiki ichikawa on 2017/10/26.
//  Copyright © 2017年 Daiki Ichikawa. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let _email = emailTextField.text, let _password = passwordTextField.text, let _name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: _email, password: _password) { [weak self] (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let _uid = user?.uid else {
                return
            }
            
            // Successfully authenticated (created new) user
            let imageName = NSUUID().uuidString // generate unique string for image name
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self?.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name" : _name, "email": _email, "profileImageUrl": profileImageUrl]
                        
                        self?.registerUserIntoDatabaseWithUID(uid: _uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String : AnyObject]) {
        
        let DBRef = Database.database().reference()
        let usersReference = DBRef.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { [weak self] (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            // self?.messageController?.fetchUserAndSetupNavBarTitle() // avoid unnecessary call to set nav bar title
            // self?.messageController?.navigationItem.title = values["name"] as? String
            
            // this setter potenially crash if keys don't match
            let user = User()
            user.setValuesForKeys(values)
            self?.messageController?.setupNavBarWithUser(user: user)
            
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel picker")
        dismiss(animated: true, completion: nil)
    }
    
}
