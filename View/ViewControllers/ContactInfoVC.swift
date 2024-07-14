//
//  ContactInfoVC.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 14/07/24.
//

import UIKit

class ContactInfoVC: UIViewController {

    var contactsInfo: NewContacts?
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var userStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

    }
    
    func setUp() {
        userName.text = "\(contactsInfo?.firstName ?? "") \(contactsInfo?.lastName ?? "")"
        phoneNumber.text = contactsInfo?.phoneNumber
        userStatus.text = contactsInfo?.status ?? ""
        if let imageData = contactsInfo?.profileImg, !imageData.isEmpty, let image = UIImage(data: imageData) {
            profileImg.image = image
        } else {
            profileImg.image = UIImage(systemName: "person.crop.circle") // Placeholder image if no profile image available
        }
    }
    
    @IBAction func backBtnTapped(_ sender : UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func editBtnTapped(_ sender : UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewContactVC") as! NewContactVC
        vc.isFromEdit = true
        vc.contactsInfo = contactsInfo
        navigationController?.pushViewController(vc, animated: false)
    }
}
