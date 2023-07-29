//
//  CameraEditPhotoViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 27.07.2023.
//

import UIKit

class CameraEditPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var bottomStuckConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldMenu: UITextField!
    @IBOutlet weak var backgroundTableView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundStuckView: UIView!
    @IBOutlet weak var backgrounMainView: UIView!
    @IBOutlet weak var backgroundRotateView: UIView!
    
    public var image: UIImage?
    
    var allItems = [SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false) ,SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false)] {
        didSet {
            countriesModels = allItems
    }
}
    
    private var countriesModels = [SelectionCountryModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundStuckView.layer.cornerRadius = 10
        backgroundStuckView.layer.masksToBounds = true
        backgroundRotateView.layer.cornerRadius = 15
        backgroundRotateView.layer.maskedCorners = [.layerMinXMaxYCorner]
        backgroundTableView.layer.cornerRadius = 15
        
        backgroundTableView.layer.masksToBounds = true
        countriesModels = allItems
        
        textFieldMenu.delegate = self
        textFieldMenu.placeholder = "Search your language..."
        textFieldMenu.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1)])
        textFieldMenu.leftView = UIImageView(image: UIImage(named: "loope"))
        textFieldMenu.leftViewMode = .always
        textFieldMenu.layer.cornerRadius = 15
        textFieldMenu.layer.masksToBounds = true
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(UINib(nibName: "SectionMenuCell", bundle: nil), forCellReuseIdentifier: "SectionMenuCell")
        
        guard let image else { return }
        backgroundImageView.image = image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backgroundImageView.addGestureRecognizer(tapGesture)
        
        backgroundImageView.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        bottomStuckConstraint.constant = 200
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomStuckConstraint.constant = 0
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        textFieldMenu.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldMenu.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func selectCountryButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0, animations: {
            self.backgroundTableView.isHidden = !self.backgroundTableView.isHidden
        })
    }
    
    @IBAction func rotateButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func checkmarkDidTap(_ sender: Any) {
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
    }
}

extension CameraEditPhotoViewController: UITextFieldDelegate {
    
    func textField(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defer { menuTableView.reloadData() }
        guard !searchText.isEmpty else {
            countriesModels = allItems
            return
        }
        countriesModels = allItems.filter({ $0.nameCountry.localizedCaseInsensitiveContains(searchText) })
        
    }
}


extension CameraEditPhotoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = countriesModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionMenuCell", for: indexPath)
        (cell as? SectionMenuCell)?.configure(flagPicture: model.flagPicture, labelCountry: model.nameCountry)
        return cell
    }
}
