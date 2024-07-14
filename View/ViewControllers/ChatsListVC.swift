//
//  SettingsVC.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 12/07/24.
//

import CoreData
import UIKit


class ChatsListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noChatsView: UIView!
    
    var contacts: [NewContacts] = []
    var messages: [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noChatsView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ChatsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
        fetchMessages()
    }
    
    private func fetchContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NewContacts>(entityName: "NewContacts")
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            if contacts.isEmpty {
                noChatsView.isHidden = false
            }else{
                noChatsView.isHidden = true
            }
            tableView.reloadData()
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    func fetchMessages() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Messages> = Messages.fetchRequest()
        
        do {
            messages = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    
    @IBAction func addContactBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NewContactVC") as! NewContactVC
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as? ChatsCell else { return UITableViewCell() }
        let contact = contacts[indexPath.row]
        cell.userNameLbl?.text = "\(contact.firstName ?? "") \(contact.lastName ?? "")"
        
        if let imageData = contact.profileImg, let image = UIImage(data: imageData) {
            cell.profileImg.image = image
        } else {
            cell.profileImg.image = UIImage(systemName: "person.crop.circle") // Placeholder image if no profile image available
        }
        
        if !messages.isEmpty {
            if messages[indexPath.row].contact?.phoneNumber == contact.phoneNumber {
                if messages.last?.textMessage == nil && messages.last?.image == nil {
                    cell.messageLbl.text = "No New Messages"
                }else if messages.last?.textMessage == nil && messages.last?.image != nil {
                    cell.messageLbl.text = "Sent a photo"
                }else if messages.last?.textMessage != nil && messages.last?.image == nil{
                    cell.messageLbl.text = messages.last?.textMessage
                }
            }else{
                cell.messageLbl.text = "No New Messages"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PersonalChatVC") as! PersonalChatVC
        vc.contactsInfo = contacts[indexPath.row]
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = contacts[indexPath.row]
            contacts.remove(at: indexPath.row)
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(contactToDelete)
                do {
                    try context.save()
                } catch {
                    print("Failed to delete contact: \(error)")
                }
            }
            if contacts.isEmpty {
                noChatsView.isHidden = false
            }else{
                noChatsView.isHidden = true
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
