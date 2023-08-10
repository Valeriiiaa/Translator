//
//  PremiumViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit
import IHProgressHUD

class PremiumViewController: UIViewController {
    
    
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
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundTextView.layer.cornerRadius = 20
           
            
        default:  backgroundTextView.layer.cornerRadius = 30
           
        }
        
        backgroundTextView.layer.masksToBounds = true
       
        
//        gradient.frame = buyNowButton.bounds
//        buyNowButton.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        let entarcen = StoryboardFabric.getStoryboard(by: "MainTranslator").instantiateViewController(identifier: "MainTranslatoreViewController")
        self.navigationController?.setViewControllers([entarcen], animated: true)
    }
    
    @IBAction func restorePurchasesDidTap(_ sender: Any) {
        IHProgressHUD.show()
        Task { [weak self] in
            do {
                let result = try await IAPManager.shared.restorePurchases()
                IHProgressHUD.dismissWithDelay(0.2)
            }
            catch {
                print("[log] restore Error \(error)")
                IHProgressHUD.showError(withStatus: "No purchases yet")
                
            }
        }
    }
  
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
        Task { [weak self] in
            do {
                let result = try await IAPManager.shared.buyStandartPack()
            }
            catch {
                print("[log] restore Error \(error)")
            }
        }
    }
}
