//
//  NewContactVC.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 13/07/24.
//

import UIKit
import Foundation
import CoreData

class NewContactVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameTxf: UITextField!
    @IBOutlet weak var lastNameTxf: UITextField!
    @IBOutlet weak var phoneNumberTxf: UITextField!
    @IBOutlet weak var statusTxf: UITextField!
    @IBOutlet weak var titleLbl : UILabel!
    
    var isFromEdit = false
    var contactsInfo: NewContacts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEdit == true {
            setUp()
        }
    }
    
    func setUp() {
        titleLbl.text = "Edit Contact"
        firstNameTxf.text = (contactsInfo?.firstName ?? "")
        lastNameTxf.text = (contactsInfo?.lastName ?? "")
        phoneNumberTxf.text = contactsInfo?.phoneNumber
        statusTxf.text = contactsInfo?.status ?? ""
        if let imageData = contactsInfo?.profileImg, !imageData.isEmpty, let image = UIImage(data: imageData) {
            profileImg.image = image
        } else {
            profileImg.image = UIImage(systemName: "person.crop.circle") // Placeholder image if no profile image available
        }
    }
    
    
    @IBAction func profileIMgBtnTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        guard let firstName = firstNameTxf.text, !firstName.isEmpty else {
            showToast(message: "Please enter FirstName")
            return
        }
        
        guard let lastName = lastNameTxf.text, !lastName.isEmpty else {
            showToast(message: "Please enter LastName")
            return
        }
        
        guard let phoneNumber = phoneNumberTxf.text, !phoneNumber.isEmpty, phoneNumber.count >= 10, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneNumber)) else {
            showToast(message: "Please enter a valid number")
            return
        }
        
        guard let status = statusTxf.text, !status.isEmpty else {
            showToast(message: "Please enter status")
            return
        }
        
        guard let profileImage = profileImg.image else {
            // Show an error message or handle the empty profile image
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if isFromEdit, let existingContact = contactsInfo {
            // Editing existing contact
            existingContact.firstName = firstName
            existingContact.lastName = lastName
            existingContact.phoneNumber = phoneNumber
            existingContact.status = status
            existingContact.profileImg = profileImage.pngData()
            
            do {
                try context.save()
                print("Successfully updated contact")
                navigationController?.popToRootViewController(animated: true)
            } catch {
                print("Failed to update contact: \(error)")
            }
        } else {
            // Creating new contact
            let newContact = NSEntityDescription.insertNewObject(forEntityName: "NewContacts", into: context) as! NewContacts
            
            newContact.firstName = firstName
            newContact.lastName = lastName
            newContact.phoneNumber = phoneNumber
            newContact.status = status
            newContact.profileImg = profileImage.pngData()
            
            do {
                try context.save()
                print("Successfully saved new contact")
                navigationController?.popViewController(animated: false)
            } catch {
                print("Failed to save contact: \(error)")
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 140, y: 60, width: 280, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
