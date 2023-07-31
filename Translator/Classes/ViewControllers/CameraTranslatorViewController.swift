//
//  CameraTranslatorViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 27.07.2023.
//

import UIKit
import AVFoundation

class CameraTranslatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var backgroundstackView: UIView!
    @IBOutlet weak var backgroundMainView: UIView!
    
    
    var imagePicker = UIImagePickerController()
    
    var session: AVCaptureSession?
    
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    let output = AVCapturePhotoOutput()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMainView.layer.cornerRadius = 15
        backgroundMainView.layer.masksToBounds = true
        backgroundstackView.layer.cornerRadius = 10
        backgroundstackView.layer.masksToBounds = true
      
        checkCameraPermissions()
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
    }
   
    @IBAction func splashButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func takePhotoButtonDidTap(_ sender: Any) {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
        
    }
   
    @IBAction func galleryButtonDidTap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)
                }
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
        (entrance as? CameraEditPhotoViewController)?.backDidTap = { [weak self] in
            DispatchQueue.global().async {
                self?.session?.startRunning()
            }
        }
        navigationController?.pushViewController(entrance, animated: true)
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
