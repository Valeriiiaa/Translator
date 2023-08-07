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
    
    override func viewDidLoad() {
        super.viewDidLoad()
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loaderImage.startRotation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(withIdentifier: "PremiumViewController")
            self?.navigationController?.pushViewController(entrance, animated: true)
        })
    }
}
