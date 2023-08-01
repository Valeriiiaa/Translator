//
//  VoiceChatViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit
import Switches

class VoiceChatViewController: UIViewController {
    
    @IBOutlet weak var adsSwitcher: YapSwitch!
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
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "EmptyChatCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "EmptyChatCell"))
}
    
    @IBAction func valueDidTap(_ sender: Any) {
        if adsSwitcher.isOn == true {
            pushPremiumScreen()
        } else {
            
        }
    }
    
    func pushPremiumScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(identifier: "PremiumViewController")
        navigationController?.pushViewController(entrance, animated: true)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "LeftMessagesCell"), for: indexPath)
            (cell as? LeftMessagesCell)?.configure(labelFirst: model.textFirst, labelSecond: model.textSecond)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "RightMessagesCell"), for: indexPath)
            (cell as? LeftMessagesCell)?.configure(labelFirst: model.textFirst, labelSecond: model.textSecond)
            return cell
        }
    }
}



