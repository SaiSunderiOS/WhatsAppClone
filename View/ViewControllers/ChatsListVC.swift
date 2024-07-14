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
    
    var contacts: [NewContacts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ChatsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
    }
    
    private func fetchContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NewContacts>(entityName: "NewContacts")
        
        do {
            contacts = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch contacts: \(error)")
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
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
