//
//  SplashScreen.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loaderImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var storage = UserDefaultsStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loaderImage.startRotation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let self else { return }
            let isFirstOpen = self.storage.get(key: .isFirstOpen, defaultValue: true)
            self.storage.set(key: .isFirstOpen, value: false)
            let countOfOpens = self.storage.get(key: .countOfOpens, defaultValue: 0) + 1
            self.storage.set(key: .countOfOpens, value: countOfOpens)
            guard !isFirstOpen else {
                self.openPremium()
                return
            }
            
            if countOfOpens % 2 == 0 {
                self.openPremium()
            } else {
                self.openMainScreen()
            }
        })
    }
    
    private func openPremium() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(withIdentifier: "PremiumViewController")
        self.navigationController?.pushViewController(entrance, animated: true)
    }
    
    private func openMainScreen() {
        let entrance = StoryboardFabric.getStoryboard(by: "MainTranslator").instantiateViewController(withIdentifier: "MainTranslatoreViewController")
        self.navigationController?.pushViewController(entrance, animated: true)
    }
}
