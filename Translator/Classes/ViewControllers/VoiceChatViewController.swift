//
//  VoiceChatViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit
import Combine
import SwiftEntryKit
import IHProgressHUD
import AVRouting
import Speech
import Hero

class VoiceChatViewController: UIViewController {
    @IBOutlet weak var backgroundflagSecond: UIView!
    @IBOutlet weak var backgroundflagFirst: UIView!
    @IBOutlet weak var backgroundStuckView: UIView!
    @IBOutlet weak var backgroundEraserView: UIView!
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var orangeMicButton: UIButton!
    @IBOutlet weak var blueMicButton: UIButton!
    @IBOutlet weak var adsSwitcher: PVSwitch!
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var secondFlag: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var tableViewChat: UITableView!
    
    @IBOutlet weak var firstPulseOneView: UIView!
    @IBOutlet weak var firstPulseTwoView: UIView!
    
    @IBOutlet weak var secondPulseOneView: UIView!
    @IBOutlet weak var secondPulseTwoView: UIView!
    
    private var speechUtterance: AVSpeechUtterance?
    private var synthesizer: AVSpeechSynthesizer?
    
    public var languageManager: LanguageManager!
    
    public var storage: UserDefaultsStorage!
    
    private let speechManager = DrawerMenuViewController.shared.speechManager
    
    private var listeners = Set<AnyCancellable>()
    
    var messagesModel: [BaseMessagesModel] = [MessagesFullModel(id: "1", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "2", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: true), MessagesFullModel(id: "3", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false), MessagesFullModel(id: "4", textFirst: "Ukraine will win!", textSecond: "Україна переможе!", isMe: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: backgroundStuckView.layer.cornerRadius = 15
            backgroundflagFirst.layer.cornerRadius = 10
            backgroundflagSecond.layer.cornerRadius = 10
            
        default: backgroundStuckView.layer.cornerRadius = 25
            backgroundflagFirst.layer.cornerRadius = 20
            backgroundflagSecond.layer.cornerRadius = 20
        }
        
        backgroundStuckView.layer.masksToBounds = true
        backgroundflagFirst.layer.masksToBounds = true
        backgroundflagSecond.layer.masksToBounds = true
       
        tableViewChat.dataSource = self
        tableViewChat.delegate = self
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        tableViewChat.register(UINib(nibName: CellManager.getCell(by: "EmptyChatCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "EmptyChatCell"))
        checkMessageModels()
        bind()
        roundPulses()
        animatePulses()
        
        if UserManager.shared.isPremium {
            noAdsLabel.isHidden = true
            adsSwitcher.isHidden = true
        } else {
        }
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
    
    private func animatePulses() {
        let firstValueFirst = 1.3
        let firstValueSecond = 1.2
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: { [unowned self] in
            self.firstPulseOneView.transform = .init(scaleX: firstValueFirst, y: firstValueFirst)
            self.firstPulseTwoView.transform = .init(scaleX: firstValueSecond, y: firstValueSecond)
            self.secondPulseOneView.transform = .init(scaleX: firstValueFirst, y: firstValueFirst)
            self.secondPulseTwoView.transform = .init(scaleX: firstValueSecond, y: firstValueSecond)
        })
    }
    
    private func roundPulses() {
        [firstPulseOneView, firstPulseTwoView, secondPulseOneView, secondPulseTwoView].forEach({ view in
            view?.layer.cornerRadius = 50 / 2
            view?.layer.masksToBounds = true
        })
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
        orangeMicButton.setImage(UIImage(named: "orangeMicOn"), for: .normal)
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        SwiftEntryKit.display(entry: view, using: attributes)
        
        let language = languageManager.originalLanguage.key
        let languageKey = language.rawValue

        
        view.translatedLanguage.text = language.name
        view.didHideView = { [weak self] in
            guard let self else { return }
            self.speechManager.stopRecognize()
            self.orangeMicButton.setImage(UIImage(named: "orangeMic"), for: .normal)
        }
        
        do {
            try speechManager.startRecognize(for: languageKey, textChanged: { [weak view] text in
                guard let view else { return }
                view.trySaySmth.text = ""
            }, volumeChanged: { [weak view] volume in
                guard let view else { return }
                DispatchQueue.main.async {
                    view.addPulse(volume: volume)
                }
            })
        } catch {
            print("[log] speech \(error.localizedDescription)")
        }
    }
    
    @IBAction func blueMicDidTap(_ sender: Any) {
        let view = GoogleMic.fromNib()
        blueMicButton.setImage(UIImage(named: "blueMicOn"), for: .normal)
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        SwiftEntryKit.display(entry: view, using: attributes)
        
        let language = languageManager.originalLanguage.key
        let languageKey = language.rawValue

        
        view.translatedLanguage.text = language.name
        view.didHideView = { [weak self] in
            guard let self else { return }
            self.speechManager.stopRecognize()
            self.blueMicButton.setImage(UIImage(named: "blueMic"), for: .normal)
        }
        
        do {
            try speechManager.startRecognize(for: languageKey, textChanged: { [weak view] text in
                guard let view else { return }
                view.trySaySmth.text = ""
            }, volumeChanged: { [weak view] volume in
                guard let view else { return }
                DispatchQueue.main.async {
                    view.addPulse(volume: volume)
                }
            })
        } catch {
            print("[log] speech \(error.localizedDescription)")
        }
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
