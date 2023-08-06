//
//  TranslatorTextViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit
import Switches
import MLKitTranslate
import IHProgressHUD
import Combine

class TranslatorTextViewController: UIViewController, UITextViewDelegate {
   
    @IBOutlet weak var translatedFlagImage: UIImageView!
    @IBOutlet weak var translatedTextLabel: UILabel!
    @IBOutlet weak var originalFlagImage: UIImageView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var originalTextLabel: UILabel!
    @IBOutlet weak var adsSwitcher: YapSwitch!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var getTextView: UIView!
    @IBOutlet weak var putTextView: UIView!
    @IBOutlet weak var textViewGetText: UITextView!
    @IBOutlet weak var textViewTypeText: UITextView!
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var backgroundFlagSecondView: UIView!
    @IBOutlet weak var backgroundFlagFirstView: UIView!
    
    private lazy var networkManager: NetworkManager = {
        NetworkManager()
    }()
    
    private lazy var translatorService: TranslatorService = { [unowned self] in
        TranslatorService(networkManager: self.networkManager)
    }()
    
    private lazy var translator: TextTranslator = { [unowned self] in
        GooglePrivateAPITranslator(translatorService: self.translatorService)
    }()
    
    private var listeners = Set<AnyCancellable>()
    
    public var languageManager: LanguageManager!
    public var storage: UserDefaultsStorage!
    
    var overlayView: OverlayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundMainView.layer.cornerRadius = 15
            backgroundFlagSecondView.layer.cornerRadius = 10
            backgroundFlagFirstView.layer.cornerRadius = 10
            textViewTypeText.layer.cornerRadius = 20
            textViewGetText.layer.cornerRadius = 20
            putTextView.layer.cornerRadius = 20
            getTextView.layer.cornerRadius = 20
            firstFlag.layer.cornerRadius = 1
            secondImage.layer.cornerRadius = 1
            originalFlagImage.layer.cornerRadius = 1
            translatedFlagImage.layer.cornerRadius = 1
            
            
        default: backgroundMainView.layer.cornerRadius = 25
            backgroundFlagSecondView.layer.cornerRadius = 20
            backgroundFlagFirstView.layer.cornerRadius = 20
            textViewTypeText.layer.cornerRadius = 40
            textViewGetText.layer.cornerRadius = 40
            putTextView.layer.cornerRadius = 40
            getTextView.layer.cornerRadius = 40
            firstFlag.layer.cornerRadius = 2
            secondImage.layer.cornerRadius = 2
            originalFlagImage.layer.cornerRadius = 2
            translatedFlagImage.layer.cornerRadius = 2
        }
        
        textViewTypeText.delegate = self
        firstFlag.layer.masksToBounds = true
        secondImage.layer.masksToBounds = true
        backgroundMainView.layer.masksToBounds = true
        backgroundFlagSecondView.layer.masksToBounds = true
        backgroundFlagFirstView.layer.masksToBounds = true
        textViewTypeText.layer.masksToBounds = true
        textViewGetText.layer.masksToBounds = true
        setupOverlayView()
        originalFlagImage.layer.borderWidth = 1
        originalFlagImage.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        translatedFlagImage.layer.borderWidth = 1
        translatedFlagImage.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        firstFlag.layer.borderWidth = 1
        firstFlag.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        secondImage.layer.borderWidth = 1
        secondImage.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        putTextView.layer.borderWidth = 2
        putTextView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        putTextView.layer.masksToBounds = true
        
        getTextView.layer.borderWidth = 2
        getTextView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        getTextView.layer.masksToBounds = true
        bind()
    }
    
    private func bind() {
        languageManager.$originalLanguage.sink(receiveValue: { [weak self] language in
            guard let self else { return }
            self.firstLabel.text = language.key.name
            self.firstFlag.image = UIImage(named: language.flagPicture)
            self.originalFlagImage.image = UIImage(named: language.flagPicture)
            self.originalTextLabel.text = language.key.name
        }).store(in: &listeners)
        languageManager.$translatedLanguage.sink(receiveValue: { [weak self] language in
            guard let self else { return }
            self.secondLabel.text = language.key.name
            self.secondImage.image = UIImage(named: language.flagPicture)
            self.translatedFlagImage.image = UIImage(named: language.flagPicture)
            self.translatedTextLabel.text = language.key.name
            guard let text = self.textViewTypeText.text,
                  !text.isEmpty else { return }
            self.translate()
        }).store(in: &listeners)
    }
    
    private func translate() {
        guard let text = textViewTypeText.text else { return }
       
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let originalLanguage = self.languageManager.originalLanguage.key
                let translatedLanguage = self.languageManager.translatedLanguage.key
                let translatedText = try await self.translator.translate(text: text, from: originalLanguage.rawValue, to: translatedLanguage.rawValue)
                self.textViewGetText.text = translatedText
                let historyModel = HistoryFullModel(id: "2", originalText: text, translatedText: translatedText, firstFlag: self.languageManager.originalLanguage.key.rawValue, secondFlag: self.languageManager.translatedLanguage.key.rawValue, firstLanguageLabel: originalLanguage.name, secondLanguageLabel: translatedLanguage.name)
                self.storage.add(key: .history, value: historyModel)
            } catch {
                print("[log] translate \(error.localizedDescription)")
            }
        }
        textViewTypeText.resignFirstResponder()
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
    
    func setupOverlayView() {
        overlayView = OverlayView(frame: textViewTypeText.bounds)
        overlayView.isUserInteractionEnabled = false
        textViewTypeText.addSubview(overlayView)
    }
    
    func showOverlayView(_ show: Bool) {
        overlayView.isHidden = !show
        if show {
            textViewTypeText.bringSubviewToFront(overlayView)
        } else {
            textViewTypeText.sendSubviewToBack(overlayView)
        }
    }
    
    @objc func dismissKeyboard() {
        textViewTypeText.resignFirstResponder()
    }
    //
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        if textView.text.isEmpty {
            showOverlayView(false)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.gestureRecognizers?.forEach {
            if let tapGesture = $0 as? UITapGestureRecognizer {
                view.removeGestureRecognizer(tapGesture)
            }
            if textView.text.isEmpty {
                showOverlayView(true)
            }
        }
    }
    
    @IBAction func deleteTypeTextDidTap(_ sender: Any) {
        textViewTypeText.text = ""
        textViewGetText.text = ""
        
    }
    
    @IBAction func deleteGetTextDidTap(_ sender: Any) {
        textViewGetText.text = ""
    }
    
    @IBAction func riversoButtonDidTap(_ sender: Any) {
        let originalLanguage = languageManager.originalLanguage
        languageManager.originalLanguage = languageManager.translatedLanguage
        languageManager.translatedLanguage = originalLanguage
    }
    
    @IBAction func selectSecondButtonDidTap(_ sender: Any) {
        pushSelectionScreen()
    }
   
    @IBAction func selectCountryDidTap(_ sender: Any) {
        pushSelectionScreen()
    }
    
    func pushSelectionScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "SelectionCountry").instantiateViewController(identifier: "SelectionCountryViewController")
        (entrance as? SelectionCountryViewController)?.isOriginalLanguage = true
        (entrance as? SelectionCountryViewController)?.languageManager = languageManager
        (entrance as? SelectionCountryViewController)?.storage = storage
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func pushSelectionTranslatedLanguageScreen(_ sender: Any) {
        let entrance = StoryboardFabric.getStoryboard(by: "SelectionCountry").instantiateViewController(identifier: "SelectionCountryViewController")
        (entrance as? SelectionCountryViewController)?.isOriginalLanguage = false
        (entrance as? SelectionCountryViewController)?.languageManager = languageManager
        (entrance as? SelectionCountryViewController)?.storage = storage
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func translateDidTap(_ sender: Any) {
        translate()
    }
    
    @IBAction func copyTextDidTap(_ sender: Any) {
        UIPasteboard.general.string = textViewGetText.text
        IHProgressHUD.showSuccesswithStatus("Translation copied")
        IHProgressHUD.dismissWithDelay(0.5)
    }
   
    @IBAction func shareTextDidTap(_ sender: Any) {
        guard let textToShare = textViewGetText.text else  {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
           
            present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backbuttonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
