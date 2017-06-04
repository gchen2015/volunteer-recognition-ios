//
//  NewAwesomenessViewController.swift
//  APASlapApp
//
//  Created by Jeffrey Linwood on 6/3/17.
//  Copyright © 2017 Jeff Linwood. All rights reserved.
//

import UIKit

import Firebase

class NewAwesomenessViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let databaseReference = FIRDatabase.database().reference(withPath: "awesomes")
    
    let imagesStorageRef = FIRStorage.storage().reference().child("images")
    
    var imageStorageRefId:String?

    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var addAPhotoButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addAPhotoButton.layer.borderColor = UIColor.white.cgColor
        addAPhotoButton.layer.borderWidth = 1.0
        addAPhotoButton.layer.cornerRadius = 4.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let userId = FIRAuth.auth()!.currentUser?.uid
        
        var data = ["message": messageTextView.text,
                    "userId": userId]
        
        if let imageStorageRefId = imageStorageRefId {
            data["imageStorageRefId"] = imageStorageRefId
        }

        databaseReference.childByAutoId().setValue(
            data
        )
        dismiss(animated: true, completion: nil)

    }


    @IBAction func addAPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @IBAction func useCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func tapView(_ sender: Any) {
        messageTextView.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = image
            if let imageData = UIImageJPEGRepresentation(image,0.3) {
                let imageMetadata = FIRStorageMetadata()
                imageMetadata.contentType = "image/jpeg"
                let imagePath = NSUUID().uuidString
                let uploadTask = imagesStorageRef.child(imagePath).put(imageData, metadata: imageMetadata)
                
                uploadTask.observe(.success) { snapshot in
                    self.imageStorageRefId = imagePath
                    print("Uploaded image")
                }
                

            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
