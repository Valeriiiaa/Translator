//
//  DrawerMenuViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit
import StoreKit

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let shared = DrawerMenuViewController()
    
    public weak var drawerNavigationController: UINavigationController?
    
    private var previousVC: UIViewController?
    
    let transitionManager = DrawerTransitionManager()
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: CellManager.getCell(by: "PremiumImageCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "PremiumImageCell"))
        table.register(UINib(nibName: CellManager.getCell(by: "MenuItemsCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MenuItemsCell"))
        table.backgroundColor = nil
        table.separatorColor = .clear
        return table
    }()
    
    private var  closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: button.setImage(UIImage(named: "close"), for: .normal)
            
        default: button.setImage(UIImage(named: "close-ipad"), for: .normal)
        }
        return button
    }()
    
    private var menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.textColor = UIColor(red: 93/255, green: 104/255, blue: 131/255, alpha: 1)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:  label.font = UIFont(name: "Sriracha", size: 20)
            
        default:  label.font = UIFont(name: "Sriracha", size: 35)
        }
        return label
    }()
    
    private var menuBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Gain new experience using\nour Voice Translator"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1)
       
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: label.font = UIFont(name: "Fixel", size: 16)
            
        default: label.font = UIFont(name: "Fixel", size: 35)
        }
        return label
    }()
    
    
    @objc func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    var models = [DrawerMenuCellType.premiumPicture, .itemsMenu(MenuItemsModel(label: "History", image: ImageManager.getImage(by: "history"))), .itemsMenu(MenuItemsModel(label: "Share it", image: ImageManager.getImage(by: "shareIt"))), .itemsMenu(MenuItemsModel(label: "Rate us", image: ImageManager.getImage(by: "rateUs"))), .itemsMenu(MenuItemsModel(label: "Contact us", image: ImageManager.getImage(by: "contactUs"))), .itemsMenu(MenuItemsModel(label: "Privacy Policy", image: ImageManager.getImage(by: "privacyPolicy")))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(menuLabel)
        view.addSubview(menuBottomLabel)
        tableView.delegate = self
        tableView.dataSource = self
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        menuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        menuBottomLabel.translatesAutoresizingMaskIntoConstraints = false
        menuBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuBottomLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
    }
    public func back() {
        drawerNavigationController?.setViewControllers([previousVC].compactMap({ $0 }), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 60, width: view.bounds.size.width - 0, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: model.reusedId) , for: indexPath)
        switch model {
        case .premiumPicture: break
        case .itemsMenu(let itemsMenuModel):
            (cell as? MenuItemsCell)?.configure(image: itemsMenuModel.image , label: itemsMenuModel.label)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousVC = drawerNavigationController?.viewControllers.last
        switch indexPath.row {
        case 0: openPremiumVC()
        case 1: openHistoryVC()
        case 2: openHistoryVC()
        case 3: rateUs()
        case 4: openHistoryVC()
        default: print ("ppp")
        }
    }
    
    private func openPremiumVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Premium").instantiateViewController(identifier: "PremiumViewController")
        guard !(drawerNavigationController?.viewControllers.last is HistoryViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func openHistoryVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "History").instantiateViewController(identifier: "HistoryViewController")
        guard !(drawerNavigationController?.viewControllers.last is HistoryViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.pushViewController(entrance, animated: false) //?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func shareIt() {
        let entrance = StoryboardFabric.getStoryboard(by: "History").instantiateViewController(identifier: "HistoryViewController")
        guard !(drawerNavigationController?.viewControllers.last is HistoryViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func rateUs() {
        SKStoreReviewController.requestReview()
    }
}
