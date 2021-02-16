//
//  ViewController.swift
//  MemeMe-v1.0
//
//  Created by Herbert Dodge on 7/8/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class CreateMemeVC: UIViewController {
    
    //MARK: - properties

    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var shareButton: UIBarButtonItem!
    

    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Methods
    
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true, completion: nil)
    }
    
    func save() {
        _ = Meme(topText: topTextField.text ?? "", bottomText: bottomTextField.text ?? "", originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
    }
    
    func generateMemedImage() -> UIImage {
        hideToolBars(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(false)
        
        return memedImage
    }
    
    //MARK: - Helpers

    @IBAction func share(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        
        let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareSheet.completionWithItemsHandler = { (_, completed, _, _) in
            if (completed) {
                self.save()
                
            }
        }
        present(shareSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        openImagePicker(.camera)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    //MARK: - Configuration
    
    func configureUI() {
        setUpTextFieldStyle(toTextField: topTextField, defaultText: "TOP")
        setUpTextFieldStyle(toTextField: bottomTextField, defaultText: "BOTTOM")
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func hideToolBars(_ hide: Bool) {
        navigationController?.navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func setUpTextFieldStyle(toTextField textField: UITextField, defaultText: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0
        ]
        
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        
    }
    
}




