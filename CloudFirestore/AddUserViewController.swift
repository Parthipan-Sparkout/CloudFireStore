//
//  AddUserViewController.swift
//  CloudFirestore
//
//  Created by Sparkout on 07/02/23.
//

import UIKit
import FirebaseFirestore

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var employeeIDTextfield: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
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
        docRef.setData([
            "employeeID": employeeId,
            "userName": userName,
        ])
        
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
        print("open gallery")
    }
    

}
