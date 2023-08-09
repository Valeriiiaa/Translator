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
import AVRouting
import Speech
import Hero

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
    
    private var speechUtterance: AVSpeechUtterance?
    private var synthesizer: AVSpeechSynthesizer?
    
    public var languageManager: LanguageManager!
    
    public var storage: UserDefaultsStorage!
    
    private var listeners = Set<AnyCancellable>()
    
    var messagesModel: [BaseMessagesModel] = [MessagesFullModel(id: "1", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "2", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "3", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false), MessagesFullModel(id: "4", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewChat.dataSource = self
        tableViewChat.delegate = self
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "EmptyChatCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "EmptyChatCell"))
        checkMessageModels()
        bind()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSpeaking()
    }
    
    func checkMessageModels() {
        eraserButton.isHidden = messagesModel.isEmpty
        backgroundEraserView.isHidden = messagesModel.isEmpty
        if messagesModel.isEmpty == true {
            self.messagesModel = [MessagesEmptyModel(id: "1")]
            tableViewChat.reloadData()
        }
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
        view.deletedAllCellsTapped = { [weak self] in
            self?.messagesModel.removeAll()
            self?.stopSpeaking()
            self?.checkMessageModels()
            SwiftEntryKit.dismiss(with: {
                IHProgressHUD.showSuccesswithStatus("Chat was cleared")
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
        var cell = UITableViewCell()
        guard let fullModel = model as? MessagesFullModel else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "EmptyChatCell"), for: indexPath)
            return cell
        }
        if fullModel.isMe {
            cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "LeftMessagesCell"), for: indexPath)
            (cell as? LeftMessagesCell)?.configure(labelFirst: fullModel.textFirst, labelSecond: fullModel.textSecond)
            (cell as? LeftMessagesCell)?.deleteButtonTapped = { [weak self] in
                self?.deleteCell(at: indexPath)
                self?.checkMessageModels()
                IHProgressHUD.showSuccesswithStatus("Message was cleared")
                IHProgressHUD.dismissWithDelay(0.4)
            }
            (cell as? LeftMessagesCell)?.listenTextDidTap = { [weak self] text in
                self?.stopSpeaking()
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: self?.languageManager.originalLanguage.key.rawValue)!
                utterance.rate = 0.4
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                self?.synthesizer = synthesizer
                self?.speechUtterance = utterance
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "RightMessagesCell"), for: indexPath)
            (cell as? RightMessegesCell)?.configure(textFirst: fullModel.textFirst, textSecond: fullModel.textSecond)
            (cell as? RightMessegesCell)?.deleteButtonTapped = { [weak self] in
                self?.deleteCell(at: indexPath)
                self?.checkMessageModels()
                IHProgressHUD.showSuccesswithStatus("Message was cleared")
                IHProgressHUD.dismissWithDelay(0.4)
            }
            (cell as? RightMessegesCell)?.listenTextDidTap = { [weak self] text in
                self?.stopSpeaking()
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: self?.languageManager.translatedLanguage.key.rawValue)!
                utterance.rate = 0.4
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
                self?.synthesizer = synthesizer
                self?.speechUtterance = utterance
            }
        }
        return cell
    }
    
    func deleteCell(at indexPath: IndexPath) {
        messagesModel.remove(at: indexPath.row)
        tableViewChat.deleteRows(at: [indexPath], with: .automatic)
        tableViewChat.reloadData()
    }
   
    func stopSpeaking() {
        synthesizer?.stopSpeaking(at: .immediate)
    }
}
