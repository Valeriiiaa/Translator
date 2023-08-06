//
//  VoiceChatViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit
import Switches
import Combine
import SwiftEntryKit
import IHProgressHUD

class VoiceChatViewController: UIViewController {
    
    @IBOutlet weak var backgroundEraserView: UIView!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var orangeMicButton: UIButton!
    @IBOutlet weak var blueMicButton: UIButton!
    @IBOutlet weak var adsSwitcher: YapSwitch!
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var secondFlag: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var tableViewChat: UITableView!
    
    var messageModel: [BaseMessagesModel] = [MessagesEmptyModel(id: "1")]
    
    public var languageManager: LanguageManager!
    
    public var storage: UserDefaultsStorage!
    
    private var listeners = Set<AnyCancellable>()
    
    
    var messagesModel = [MessagesFullModel(id: "1", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "2", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "3", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false), MessagesFullModel(id: "4", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChat.dataSource = self
        tableViewChat.delegate = self
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "EmptyChatCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "EmptyChatCell"))
        bind()
        
    }
    
    @IBAction func valueDidTap(_ sender: Any) {
        if adsSwitcher.isOn == true {
            pushPremiumScreen()
        } else {
            
        }
    }
    @IBAction func eraserButtondidTap(_ sender: Any) {
        showPopup()
    }
    
    private func showPopup() {
        let view = ClearChatView.fromNib()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        attributes.entryInteraction = .forward
        SwiftEntryKit.display(entry: view, using: attributes)
        view.deletedAllCellsTapped = {[weak self] in
            self?.messageModel.removeAll()
            self?.tableViewChat.reloadData()
            SwiftEntryKit.dismiss(with: {
                IHProgressHUD.showSuccesswithStatus("History was cleared")
                IHProgressHUD.dismissWithDelay(0.5)
            })
        }
    }
    
    
    func pushSelectionScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "SelectionCountry").instantiateViewController(identifier: "SelectionCountryViewController")
        (entrance as? SelectionCountryViewController)?.isOriginalLanguage = true
        (entrance as? SelectionCountryViewController)?.languageManager = languageManager
        (entrance as? SelectionCountryViewController)?.storage = storage
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    func pushPremiumScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(identifier: "PremiumViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func selectionButtonSecondDidTap(_ sender: Any) {
        pushSelectionScreen()
    }
   
    @IBAction func selectionButtondidTap(_ sender: Any) {
        let entrance = StoryboardFabric.getStoryboard(by: "SelectionCountry").instantiateViewController(identifier: "SelectionCountryViewController")
        (entrance as? SelectionCountryViewController)?.isOriginalLanguage = false
        (entrance as? SelectionCountryViewController)?.languageManager = languageManager
        (entrance as? SelectionCountryViewController)?.storage = storage
        navigationController?.pushViewController(entrance, animated: true)
    }
   
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orangeMicDidTap(_ sender: Any) {
        let view = GoogleMic.fromNib()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        SwiftEntryKit.display(entry: view, using: attributes)
    }
    
    @IBAction func blueMicDidTap(_ sender: Any) {
        let view = GoogleMic.fromNib()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        SwiftEntryKit.display(entry: view, using: attributes)
    }
   
    @IBAction func riversoButtonDidTap(_ sender: Any) {
        let originalLanguage = languageManager.originalLanguage
        languageManager.originalLanguage = languageManager.translatedLanguage
        languageManager.translatedLanguage = originalLanguage
    }
    
    private func bind() {
        languageManager.$originalLanguage.sink(receiveValue: { [weak self] language in
            guard let self else { return }
            self.firstLabel.text = language.key.name
            self.firstFlag.image = UIImage(named: language.flagPicture)
        }).store(in: &listeners)
        languageManager.$translatedLanguage.sink(receiveValue: { [weak self] language in
            guard let self else { return }
            self.secondLabel.text = language.key.name
            self.secondFlag.image = UIImage(named: language.flagPicture)
        }).store(in: &listeners)
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



