//
//  UserTableViewCell.swift
//  CloudFirestore
//
//  Created by Sparkout on 07/02/23.
//

import UIKit
import FirebaseFirestore

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDesignation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
    }

    func configureCell(data: [String: Any]) {
        if data["imageData"] != nil {
            userImageView.image = UIImage(data: data["imageData"] as? Data ?? Data())
        } else {
            userImageView.image = UIImage(named: "placeholder")
        }
        userName.text = data["userName"] as? String ?? ""
        userDesignation.text = "Reg ID : " + (data["employeeID"] as? String ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
