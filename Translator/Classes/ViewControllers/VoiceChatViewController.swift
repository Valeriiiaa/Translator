//
//  VoiceChatViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class VoiceChatViewController: UIViewController {
    
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var secondFlag: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var tableViewChat: UITableView!
    
    var messagesModel = [MessagesModel(id: "1", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesModel(id: "2", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesModel(id: "3", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false), MessagesModel(id: "4", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewChat.dataSource = self
        tableViewChat.delegate = self
        tableViewChat.register(UINib(nibName: "LeftMessagesCell" , bundle: nil), forCellReuseIdentifier: "LeftMessagesCell")
        tableViewChat.register(UINib(nibName: "RightMessagesCell" , bundle: nil), forCellReuseIdentifier: "RightMessagesCell")
        tableViewChat.register(UINib(nibName: "EmptyChatCell" , bundle: nil), forCellReuseIdentifier: "EmptyChatCell")
}
    
    @IBAction func backButtonDidTap(_ sender: Any) {
    }
    @IBAction func riversoButtonDidTap(_ sender: Any) {
    }
    
}

extension VoiceChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagesModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messagesModel[indexPath.row]
        if model.isMe {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMessagesCell", for: indexPath)
            (cell as? LeftMessagesCell)?.configure(labelFirst: model.textFirst, labelSecond: model.textSecond)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightMessagesCell", for: indexPath)
            (cell as? LeftMessagesCell)?.configure(labelFirst: model.textFirst, labelSecond: model.textSecond)
            return cell
        }
    }
}



