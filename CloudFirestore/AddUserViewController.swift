//
//  AddUserViewController.swift
//  CloudFirestore
//
//  Created by Sparkout on 07/02/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var employeeIDTextfield: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var imageUrl = ""
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
          
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
    }
    
    @objc func addAction() {
        guard let userName = userNameTextfield.text, !userName.isEmpty else {
            self.showAlert(withMessage: "User name must not be empty")
            return
        }
        guard let employeeId = employeeIDTextfield.text, !employeeId.isEmpty else {
            self.showAlert(withMessage: "Employee ID must not be empty")
            return
        }
        
        let docRef = db.document("Users/Employee")
        let imageData: Data = userImageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
        docRef.setData([
            "employeeID": employeeId,
            "userName": userName,
            "imageData": imageUrl
        ])
        showAlert(withMessage: "Data saved successfully")
        
        ref = db.collection("users").addDocument(data: [
            "employeeID": employeeId,
            "userName": userName,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    @objc func openGallery() {
        var imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {

       let storageRef = Storage.storage().reference().child("myImage.png")
       if let uploadData = self.userImageView.image?.jpegData(compressionQuality: 0.5) {
           storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
               if error != nil {
                   print("error")
                   completion(nil)
               } else {

                   storageRef.downloadURL(completion: { (url, error) in

                       print(url?.absoluteString)
                       completion(url?.absoluteString)
                   })
               }
           }
       }
   }
}

extension AddUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               userImageView.contentMode = .scaleToFill
            userImageView.image = pickedImage
           }
//         uploadMedia { url in
//             self.imageUrl = url ?? ""
//        }
        picker.dismiss(animated: true, completion: nil)
    }
}
