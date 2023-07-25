//
//  PremiumViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var backgroundTextView: UIView!
    @IBOutlet weak var backgroundPremiumView: UIView!
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(red: 89/255, green: 170/255, blue: 246/255, alpha: 1).cgColor,
            UIColor(red: 94/255, green: 82/255, blue: 240/255, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.2)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
       
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundTextView.layer.cornerRadius = 20
        backgroundTextView.layer.masksToBounds = true
        buyNowButton.layer.cornerRadius = 15
        buyNowButton.layer.masksToBounds = true
       
        gradient.frame = buyNowButton.bounds
        buyNowButton.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        let entarcen = UIStoryboard(name: "MainTranslator", bundle: nil).instantiateViewController(identifier: "MainTranslatoreViewController")
        self.navigationController?.pushViewController(entarcen, animated: true)
    }
    
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
    }
    

}
