//
//  MainTranslatoreViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit
import Switches

class MainTranslatoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var noAdsLabel: UILabel!
    @IBOutlet weak var adsSwitcher: PVSwitch!
    @IBOutlet weak var collectionCell: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    
    public lazy var storage: UserDefaultsStorage = {
        UserDefaultsStorage()
    }()
    
    public lazy var languageManager: LanguageManager = { [unowned self] in
        LanguageManager(storage: self.storage)
    }()
    
    var models = [MainTranslatoreModel(text: "Text", image: ImageManager.getImage(by: "text")),MainTranslatoreModel(text: "Voice", image: ImageManager.getImage(by: "voice")), MainTranslatoreModel(text: "Camera", image: ImageManager.getImage(by: "camera")), MainTranslatoreModel(text: "Import", image: ImageManager.getImage(by: "import"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCell.dataSource = self
        collectionCell.delegate = self
        collectionCell.register(UINib(nibName: "MainTranslatorCell", bundle: nil),forCellWithReuseIdentifier: "MainTranslatorCell")
        
        if UserManager.shared.isPremium {
            noAdsLabel.isHidden = true
            adsSwitcher.isHidden = true
        } else {
        }
    }
    
    func pushPremiumScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(identifier: "PremiumViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func valueDidTap(_ sender: Any) {
        if adsSwitcher.isOn == true {
            pushPremiumScreen()
        } else {
            
        }
    }
    
    @IBAction func menuButtonDidTap(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
}

extension MainTranslatoreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGSize(width: 131, height: 131)
            
        default:  return CGSize(width: 262, height: 262)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIEdgeInsets(top: 19, left: 50, bottom: 19, right: 50)
            
        default:  return UIEdgeInsets(top: 29, left: 100, bottom: 29, right: 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let entrance = StoryboardFabric.getStoryboard(by: "TranslatorText").instantiateViewController(identifier: "TranslatorTextViewController")
            (entrance as? TranslatorTextViewController)?.languageManager = languageManager
            (entrance as? TranslatorTextViewController)?.storage = storage
            navigationController?.pushViewController(entrance, animated: true)
        } else if indexPath.row == 1 {
            let entrance = StoryboardFabric.getStoryboard(by: "VoiceChat").instantiateViewController(identifier: "VoiceChatViewController")
            (entrance as? VoiceChatViewController)?.languageManager = languageManager
            (entrance as? VoiceChatViewController)?.storage = storage
            navigationController?.pushViewController(entrance, animated: true)
        } else if indexPath.row == 2 {
            let entrance = StoryboardFabric.getStoryboard(by: "CameraTranslator").instantiateViewController(identifier: "CameraTranslatorViewController")
            (entrance as? CameraTranslatorViewController)?.languageManager = languageManager
            navigationController?.pushViewController(entrance, animated: true)
        } else if indexPath.row == 3 {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTranslatorCell", for: indexPath)
        (cell as? MainTranslatorCell)?.configure(label: item.text, image: item.image)
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pushAnotherScreen(image: image)
        }
        
    }
    
    func pushAnotherScreen(image: UIImage) {
        let entrance = StoryboardFabric.getStoryboard(by: "CameraEditPhoto").instantiateViewController(identifier: "CameraEditPhotoViewController")
        (entrance as? CameraEditPhotoViewController)?.image = image
        navigationController?.pushViewController(entrance, animated: true)
    }
    
}



