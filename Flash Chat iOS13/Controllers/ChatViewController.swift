//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hi"),
        Message(sender: "ahoi@2.com", body: "Whats up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constans.cellNibName, bundle: nil), forCellReuseIdentifier: Constans.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages(){
        
        db.collection(Constans.FStore.collectionName)
          .order(by: Constans.FStore.dateField)
          .addSnapshotListener {
                (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("There was an issue retrieving ata from Firebase \(e)")
            } else {
                if let snapshotDucument = querySnapshot?.documents {
                    for doc in snapshotDucument {
                        let data = doc.data()
                        if let messagesender = data[Constans.FStore.senderField] as? String,
                           let messageBody = data[Constans.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messagesender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constans.FStore.collectionName)
                .addDocument( data: [
                    Constans.FStore.senderField: messageSender,
                    Constans.FStore.bodyField: messageBody,
                    Constans.FStore.dateField: Date().timeIntervalSince1970])
            { (error) in
                if let e = error {
                    print("There was an issue to save the data inside the Database")
                } else {
                    print("Succesfuly saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: Constans.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        // this is a message from the current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constans.BrandColor.lightPurple)
            cell.label.textColor = UIColor(named: Constans.BrandColor.purple)
        }
        
        //This is a message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constans.BrandColor.purple)
            cell.label.textColor = UIColor(named: Constans.BrandColor.lightPurple)
        }
        
        return cell
    }
    
}
