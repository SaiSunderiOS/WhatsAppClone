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
        guard let firstName = firstNameTxf.text, !firstName.isEmpty,
               let lastName = lastNameTxf.text, !lastName.isEmpty,
               let phoneNumber = phoneNumberTxf.text, !phoneNumber.isEmpty,
               let status = statusTxf.text, !status.isEmpty,
               let profileImage = profileImg.image else {
             // Show an error message or handle the empty fields
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
    
    
//    @IBAction func saveBtn(_ sender: UIButton) {
//      
//    }

    
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
}
