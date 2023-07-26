//
//  MainTranslatoreViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class MainTranslatoreViewController: UIViewController {
    
    @IBOutlet weak var collectionCell: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
   
    var models = [MainTranslatoreModel(text: "Text", image: "text"),MainTranslatoreModel(text: "Voice", image: "voice"), MainTranslatoreModel(text: "Camera", image: "camera"), MainTranslatoreModel(text: "Import", image: "import") ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCell.dataSource = self
        collectionCell.delegate = self
        collectionCell.register(UINib(nibName: "MainTranslatorCell", bundle: nil), forCellWithReuseIdentifier: "MainTranslatorCell")
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
        return CGSize(width: 131, height: 131)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 19, left: 50, bottom: 19, right: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let entrance = UIStoryboard(name: "TranslatorText", bundle: nil).instantiateViewController(identifier: "TranslatorTextViewController")
            navigationController?.pushViewController(entrance, animated: true)
        } else if indexPath.row == 1 {
            let entrance = UIStoryboard(name: "VoiceChat", bundle: nil).instantiateViewController(identifier: "VoiceChatViewController")
            navigationController?.pushViewController(entrance, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTranslatorCell", for: indexPath)
        (cell as? MainTranslatorCell)?.configure(label: item.text, image: item.image)
        return cell
    }
    
    
}
