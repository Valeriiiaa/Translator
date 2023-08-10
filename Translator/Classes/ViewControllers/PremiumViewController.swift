//
//  PremiumViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit
import IHProgressHUD
import SwiftEntryKit

class PremiumViewController: UIViewController {
    @IBOutlet weak var backgroundTextView: UIView!
    @IBOutlet weak var backgroundPremiumView: UIView!
    
    private let storage = DrawerMenuViewController.shared.storage
    
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
    }
    
    private func showSpecialOffer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.showPopup()
        })
    }
    
    private func showPopup() {
        let view = Offer30View.fromNib()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        attributes.entryInteraction = .forward
        SwiftEntryKit.display(entry: view, using: attributes)
        
        view.closeDidTap = {
            SwiftEntryKit.dismiss()
        }
        
        view.buySubscriptionDidTap = {
            IHProgressHUD.show()
            Task {
                let result = await IAPManager.shared.buyStandartPack()
                IHProgressHUD.dismissWithDelay(0.5)
                SwiftEntryKit.dismiss()
            }
        }
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        let entarcen = StoryboardFabric.getStoryboard(by: "MainTranslator").instantiateViewController(identifier: "MainTranslatoreViewController")
        self.navigationController?.setViewControllers([entarcen], animated: true)
        
        let countOfClosePremium = storage.get(key: .countOfClosePremium, defaultValue: 0) + 1
        if countOfClosePremium % 3 == 1 {
            showSpecialOffer()
        }
        storage.set(key: .countOfClosePremium, value: countOfClosePremium)
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
                IHProgressHUD.showError(withStatus: error.localizedDescription)
                IHProgressHUD.showError(withStatus: "No purchases yet")
                IHProgressHUD.dismissWithDelay(0.5)
            }
        }
    }
    
    @IBAction func buyNowButtonDidTap(_ sender: Any) {
        IHProgressHUD.show()
        Task { [weak self] in
            do {
                let result = try await IAPManager.shared.buyStandartPack()
                IHProgressHUD.dismissWithDelay(0.2)
            }
            catch {
                print("[log] restore Error \(error)")
                IHProgressHUD.showError(withStatus: error.localizedDescription)
                IHProgressHUD.dismissWithDelay(0.5)
            }
        }
    }
}
