//
//  LoginController+handlers.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/5/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase

// MARK: ImagePicker
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var seletecImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            seletecImageFromPicker  = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"]
            as? UIImage {
            seletecImageFromPicker = originalImage
        }
        
        if let selectedImage = seletecImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Login Handlers
extension LoginController {
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        // change height of input container using contraint
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of name text field
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(
            equalTo: inputContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(
            equalTo: inputContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(
            equalTo: inputContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion:
            { (user, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "Login Error")
                    return
                }
                
                // Login Successful
                self.messageController?.fetchUserAndSetupNavBarTitle()
                
                self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Auth Error")
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // For image we will use storage
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            
            if let profileImage = self.profileImageView.image, let uploadImageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadImageData, metadata: nil, completion: {
                    (metadata, error) in
                    
                    if error != nil {
                        print(error?.localizedDescription ?? "Image Upload Error")
                        return
                    }
                    // Image Upload Successful
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name,
                                      "email": email,
                                      "profileImageUrl": profileImageURL]
                        self.registerUserIntoDatabaseWithUid(uid: uid, values: values)
                    }
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUid(uid: String, values: [String: Any]) {
        // use child node named users to store user data
        let userReference = self.databaseReference.child("users").child(uid)
        userReference.updateChildValues(
            values,
            withCompletionBlock: {(err, databaseRef) in
            if err != nil {
                print(err?.localizedDescription ?? "Insert Error")
                return
            }
             
            let user = User()
            //This might fail if keys doesn't matches
            user.setValuesForKeys(values)
            self.messageController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}

