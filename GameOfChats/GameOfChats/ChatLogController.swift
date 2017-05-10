//
//  ChatLogController.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/8/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let cellId = "messageId"
    private var containerViewBottomAnchor: NSLayoutConstraint?

    var messages = [Message]()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message......"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.keyboardDismissMode = .interactive
        
//        setupKeyboardObservers()
    }
    
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        // Upload Image View
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "image_upload")
        uploadImageView.tintColor = UIColor.lightGray
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageUploadTap)))
        containerView.addSubview(uploadImageView)
        
        // x, y, w, h
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Message
        let sendButton = UIButton(type: UIButtonType.system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleMessageSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        // Constraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // TextField
        containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // Separator View
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            
            // view here had no reference and so
            // textField was not working
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    // MARK: ImagePicker
    func handleImageUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editiedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editiedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { metadata, error in
                if error != nil {
                    print(error ?? "Failed to upload Image")
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    self.sendMessageWithUrlString(imageUrl: imageUrl)
                }
            })
        }
    }
    
    private func sendMessageWithUrlString(imageUrl: String) {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        // Get the user id
        guard let toId = user?.id,
            let fromId = FIRAuth.auth()?.currentUser?.uid else {
                return
        }
        
        let timeStamp = Int(Date().timeIntervalSince1970)
        let values: [String: Any] = ["imageUrl": imageUrl, "toId": toId, "fromId": fromId, "timestamp": timeStamp]
        childRef.updateChildValues(values, withCompletionBlock: { (error, _) in
            
            if let error = error {
                print(error)
                return
            }
            
            // create fanout
            let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let recepientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recepientUserMessageRef.updateChildValues([messageId: 1])
        })
    }
    
    // MARK: Keyboard
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func handleKeyboardWillShow(notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -(keyboardFrame?.height)!
        
        UIView.animate(withDuration: keyboardAnimationDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(notification: Notification) {
    
        let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Firebase Fetch
    func observeMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessageRef.observe(.childAdded, with: { snapshot in
            
            let messageId = snapshot.key
            
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { snapshot in
                
                guard let dict = snapshot.value as? [String: Any] else {
                    return
                }
                
                // Message Handle
                let message = Message()
                message.setValuesForKeys(dict)
                self.messages.append(message)
            
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
        })
    }
    
    func handleMessageSend() {
        
        if let messageText = inputTextField.text {
            let ref = FIRDatabase.database().reference().child("messages")
            let childRef = ref.childByAutoId()
            
            // Get the user id
            guard let toId = user?.id,
                let fromId = FIRAuth.auth()?.currentUser?.uid else {
                    return
            }
            
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values: [String: Any] = ["text": messageText, "toId": toId, "fromId": fromId, "timestamp": timeStamp]
            childRef.updateChildValues(values, withCompletionBlock: { (error, _) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                self.inputTextField.text = nil
                
                // create fanout
                let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
                let messageId = childRef.key
                userMessageRef.updateChildValues([messageId: 1])
                
                let recepientUserMessageRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
                recepientUserMessageRef.updateChildValues([messageId: 1])
            })
        }
    }
    
    
    // MARK: textField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleMessageSend()
        return true
    }
    
    // MARK: DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.messageTextView.text = message.text
        
        setupMessageCell(cell: cell, message: message)
        
        // modify bubblewidth somehow
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
        }
        
        return cell
    }
    
    private func setupMessageCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithURLString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.messageTextView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.messageTextView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        // get estimated height
        if let text = messages[indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}
