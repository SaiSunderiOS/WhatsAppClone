//
//  PersonalChatVC.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 13/07/24.
//

import UIKit
import AVFoundation
import CoreData

class PersonalChatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var contactsInfo: NewContacts?
    var messages: [Messages] = []
    
    @IBOutlet weak var userName : UILabel!
    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var messageText : PlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        Setup UserInfo
        if let data = contactsInfo {
            userName.text = "\(data.firstName ?? "") \(data.lastName ?? "")"
            if let imageData = data.profileImg, let image = UIImage(data: imageData) {
                profileImg.image = image
            } else {
                profileImg.image = UIImage(named: "default_profile_image") // Placeholder image if no profile image available
            }
        }
        
        // TableView delegate, datasource, register
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TextMessageCell", bundle: nil), forCellReuseIdentifier: "TextMessageCell")
        tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageViewCell")
        
        //        TapGesture
        let profileImgTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImgTapped))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(profileImgTapGesture)
        
        let userNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(userNameTapped))
        userName.isUserInteractionEnabled = true
        userName.addGestureRecognizer(userNameTapGesture)
        
        fetchMessages()
        
        messageText.placeholder = "Enter your text here..."

        
    }
    
    func fetchMessages() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Messages> = Messages.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contact == %@", contactsInfo!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            messages = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    func saveTextMessage(_ text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let message = Messages(context: managedContext)
        message.textMessage = text
        message.timestamp = Date()
        message.contact = contactsInfo // Assigning the contact
        
        do {
            try managedContext.save()
            fetchMessages()
        } catch {
            print("Failed to save message: \(error)")
        }
    }
    
    func saveImageMessage(_ imageData: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let message = Messages(context: managedContext)
        message.image = imageData
        message.timestamp = Date()
        message.contact = contactsInfo // Assigning the contact
        
        do {
            try managedContext.save()
            fetchMessages()
        } catch {
            print("Failed to save message: \(error)")
        }
    }
    
    @objc func profileImgTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactInfoVC") as? ContactInfoVC {
            vc.contactsInfo = contactsInfo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func userNameTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ContactInfoVC") as? ContactInfoVC {
            vc.contactsInfo = contactsInfo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)

    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let text = messageText.text, !text.isEmpty else { return }
        saveTextMessage(text)
        messageText.text = ""
    }
    
    
    
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func albumBtnTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func presentCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                saveImageMessage(imageData)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// Extension PersonalChatVC

extension PersonalChatVC : UITableViewDataSource,UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if let text = message.textMessage, !text.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextMessageCell", for: indexPath) as! TextMessageCell
            cell.textMessageLbl?.text = text
            return cell
        } else if let imageData = message.image, let image = UIImage(data: imageData), !imageData.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
            cell.messageImageView.image = image
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let text = messages[indexPath.row].textMessage, !text.isEmpty {
            return UITableView.automaticDimension
        } else if messages[indexPath.row].image != nil {
            return 280 // Adjust this value as needed
        }
        return UITableView.automaticDimension
    }
}
