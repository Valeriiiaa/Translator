//
//  CameraTranslatorViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 27.07.2023.
//

import UIKit
import AVFoundation

class CameraTranslatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var languageNameLabel: UILabel!
    @IBOutlet weak var backgroundTableView: UIView!
    @IBOutlet weak var bottomStuckConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var textFieldMenu: TextField!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var backgroundstackView: UIView!
    @IBOutlet weak var backgroundMainView: UIView!
    public var languageManager: LanguageManager?
    
    var imagePicker = UIImagePickerController()
    
    var session: AVCaptureSession?
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    let output = AVCapturePhotoOutput()
    
    var allItems = [SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans) ,SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans), SelectionCountryModel(nameCountry: "Hindi", flagPicture: "hindi", isSelected: false, key: .afrikaans)] {
        didSet {
            countriesModels = allItems
        }
    }
    
    private var countriesModels = [SelectionCountryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesModels = allItems
        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.register(UINib(nibName: CellManager.getCell(by: "SectionMenuCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "SectionMenuCell"))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundMainView.layer.cornerRadius = 15
            backgroundstackView.layer.cornerRadius = 10
            textFieldMenu.layer.cornerRadius = 15
            backgroundTableView.layer.cornerRadius = 15
            
            
        default:  backgroundMainView.layer.cornerRadius = 25
            backgroundstackView.layer.cornerRadius = 20
            textFieldMenu.layer.cornerRadius = 25
            backgroundTableView.layer.cornerRadius = 25
        }
    
        backgroundTableView.layer.masksToBounds = true
        backgroundMainView.layer.masksToBounds = true
        backgroundstackView.layer.masksToBounds = true
        textFieldMenu.layer.masksToBounds = true
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: textFieldMenu.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 15)])
            
        default: textFieldMenu.attributedPlaceholder = NSAttributedString(string: "Search your language...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1), .font: UIFont.systemFont(ofSize: 25)])
        }
        
        textFieldMenu.delegate = self
        textFieldMenu.placeholder = "Search your language..."
        textFieldMenu.leftView = UIImageView(image: UIImage(named: ImageManager.getImage(by: "loope")))
        textFieldMenu.leftViewMode = .always
        textFieldMenu.layer.masksToBounds = true
        
        checkCameraPermissions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        languageNameLabel.text = languageManager?.translatedLanguage.nameCountry
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        bottomStuckConstraint.constant = 200
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomStuckConstraint.constant = -50
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    private func checkCameraPermissions() {
        switch  AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self.setUpCamera()
                }
            }
        case .restricted:
            break
        case .authorized:
            setUpCamera()
        case .denied:
            break
        @unknown default: break
        }
    }
    
    private func setUpCamera() {
        let session  = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                
                //                pre
                previewLayer.session = session
                view.layer.insertSublayer(previewLayer, at: 0)
                
                DispatchQueue.global().async {
                    session.startRunning()
                    self.session = session
                }
                
            }
            catch {
                print(error)
            }
        }
    }
    
    func withDeviceLock(on device: AVCaptureDevice, block: (AVCaptureDevice) -> Void) {
        do {
            try device.lockForConfiguration()
            block(device)
            device.unlockForConfiguration()
        } catch {
        }
    }
    
    func turnOnTorch(device: AVCaptureDevice) {
        guard device.hasTorch else { return }
        withDeviceLock(on: device) {
            try? $0.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
        }
    }
    
    func turnOffTorch(device: AVCaptureDevice) {
        guard device.hasTorch else { return }
        withDeviceLock(on: device) {
            $0.torchMode = .off
        }
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCountryButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0, animations: {
            self.backgroundTableView.isHidden = !self.backgroundTableView.isHidden
        })
    }
    
    @IBAction func splashButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func takePhotoButtonDidTap(_ sender: Any) {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    
    @IBAction func galleryButtonDidTap(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
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
        (entrance as? CameraEditPhotoViewController)?.languageManager = languageManager
        (entrance as? CameraEditPhotoViewController)?.backDidTap = { [weak self] in
            DispatchQueue.global().async {
                self?.session?.startRunning()
            }
        }
        navigationController?.pushViewController(entrance, animated: true)
    }
}

extension CameraTranslatorViewController: UITextFieldDelegate {
    func textField(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defer { tableViewMenu.reloadData() }
        guard !searchText.isEmpty else {
            countriesModels = allItems
            return
        }
        countriesModels = allItems.filter({ $0.nameCountry.localizedCaseInsensitiveContains(searchText) })
    }
}

extension CameraTranslatorViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        guard let image  = UIImage(data: data) else { return }
        
        session?.stopRunning()
        
        pushAnotherScreen(image: image)
    }
}

extension CameraTranslatorViewController: UITableViewDelegate, UITableViewDataSource {
   
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
