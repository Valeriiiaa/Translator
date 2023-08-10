//
//  CameraEditPhotoViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 27.07.2023.
//

import UIKit
import TOCropViewController
import CropViewController
import IHProgressHUD

class CameraEditPhotoViewController: UIViewController {
    @IBOutlet weak var arrowDownWhiteButton: UIButton!
    @IBOutlet weak var bottomStuckConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldMenu: TextField!
    @IBOutlet weak var backgroundTableView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundStuckView: UIView!
    @IBOutlet weak var backgrounMainView: UIView!
    @IBOutlet weak var backgroundRotateView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    private var croppedImage: UIImage?
    public var image: UIImage?
    
    private lazy var textRecognizer: TextDetectionManager = {
        TextDetectionManager()
    }()
    
    private weak var cropViewController: CropViewController?
    
    var backDidTap: (() -> Void)?
    
    var allItems = [SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans) ,SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans)] {
        didSet {
            countriesModels = allItems
        }
    }
    
    private var countriesModels = [SelectionCountryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embeddedCropView()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundStuckView.layer.cornerRadius = 10
            backgroundRotateView.layer.cornerRadius = 15
            backgroundTableView.layer.cornerRadius = 15
            textFieldMenu.layer.cornerRadius = 15
            
        default:  backgroundStuckView.layer.cornerRadius = 20
            backgroundRotateView.layer.cornerRadius = 25
            backgroundTableView.layer.cornerRadius = 25
            textFieldMenu.layer.cornerRadius = 25
        }
        
        backgroundStuckView.layer.masksToBounds = true
        backgroundRotateView.layer.maskedCorners = [.layerMinXMaxYCorner]
        backgroundTableView.layer.masksToBounds = true
        countriesModels = allItems
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: textFieldMenu.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 15)])
            
        default: textFieldMenu.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 25)])
        }
        
        textFieldMenu.delegate = self
        textFieldMenu.placeholder = "Search your language..."
        textFieldMenu.leftView = UIImageView(image: UIImage(named: ImageManager.getImage(by: "loope")))
        textFieldMenu.leftViewMode = .always
        textFieldMenu.layer.masksToBounds = true
        
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.register(UINib(nibName: CellManager.getCell(by: "SectionMenuCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "SectionMenuCell"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func embeddedCropView() {
        guard let image else { return }
        let cropController = CropViewController(croppingStyle: .default, image: image)
        cropController.toolbar.isHidden = true
        cropController.cropView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cropController.cropView)
        self.addChild(cropController)
        cropController.cropView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        cropController.cropView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        cropController.cropView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        cropController.cropView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -50).isActive = true
        cropController.didMove(toParent: self)
        cropController.resetCropViewLayout()
        cropController.cropView.setNeedsLayout()
        cropController.cropView.layoutIfNeeded()
        self.cropViewController = cropController
        
        cropController.onDidCropToRect = { image, rect, int in
            print(image)
        }
        cropController.delegate = self
    }
    
    private func openTranslateText(with: String) {
        let entrance = StoryboardFabric.getStoryboard(by: "TranslatorText").instantiateViewController(identifier: "TranslatorTextViewController")
        (entrance as? TranslatorTextViewController)?.text = with
        DrawerMenuViewController.shared.set(viewController: entrance)
    }
    
    private func recognize() {
        guard let image = croppedImage else { return }
        Task { @MainActor [weak self, weak image] in
            defer {
                IHProgressHUD.dismiss()
            }
            guard let self else { return }
            guard let image else { return }
            do {
                let text = try await textRecognizer.recognizeText(from: image)
                self.openTranslateText(with: text)
            } catch {
                print("[log] text recognition error \(error.localizedDescription)")
            }
        }
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
        cropViewController?.cropView.rotateImageNinetyDegrees(animated: true, clockwise: true)
    }
    
    @IBAction func checkmarkDidTap(_ sender: Any) {
        cropViewController?.commitCurrentCrop()
        IHProgressHUD.show()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        backDidTap?()
        navigationController?.popViewController(animated: true)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "SectionMenuCell"), for: indexPath)
        (cell as? SectionMenuCell)?.configure(flagPicture: model.flagPicture, labelCountry: model.nameCountry)
        return cell
    }
}

extension CameraEditPhotoViewController: CropViewControllerDelegate {
    func cropViewDidBecomeResettable(_ cropView: TOCropView) {
    }
    
    func cropViewDidBecomeNonResettable(_ cropView: TOCropView) {
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        croppedImage = image
        recognize()
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print("hui")
    }
}
