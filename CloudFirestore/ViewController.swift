//
//  ViewController.swift
//  CloudFirestore
//
//  Created by Sparkout on 07/02/23.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var usersList: [QueryDocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        getDataFromFirestore()
    }
    
    func setupView() {
        self.navigationItem.title = "Employees"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        usersTableView.dataSource = self
        usersTableView.delegate = self
        let collectionRef = db.collection("users")
        collectionRef.addSnapshotListener { snapshot, error in
            print(snapshot?.documents)
            guard let datas = snapshot?.documents, !datas.isEmpty else { return }
            self.usersList = datas
            self.usersTableView.reloadData()
        }
    }
    
    func getDataFromFirestore() {
        let collectionRef = db.collection("users")
        collectionRef.getDocuments { snapshot, error in
            if let datas = snapshot?.documents, !datas.isEmpty {
                print(datas)
                self.usersList = datas
                self.usersTableView.reloadData()
            }
        }
        
        let docRef = db.document("Users/Employee")
        docRef.getDocument { snapshot, error in
            if let data = snapshot?.data(), !data.isEmpty {
                print(data)
            }
        }
    }
    
    @objc func addTapped() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserViewController") as? AddUserViewController {
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell
        cell?.configureCell(data: usersList[indexPath.row].data())
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let collectionRef = db.collection("users")
            collectionRef.document(usersList[indexPath.row].documentID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            usersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
