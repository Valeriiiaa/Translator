//
//  TranslatorTextViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit


class TranslatorTextViewController: UIViewController, UITextViewDelegate {
    
    
   
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstFlag: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var getTextView: UIView!
    @IBOutlet weak var putTextView: UIView!
    @IBOutlet weak var textViewGetText: UITextView!
    @IBOutlet weak var textViewTypeText: UITextView!
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var backgroundFlagSecondView: UIView!
    @IBOutlet weak var backgroundFlagFirstView: UIView!
    
    var overlayView: OverlayView!
    
    var isSwapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewTypeText.delegate = self
        backgroundMainView.layer.cornerRadius = 15
        backgroundMainView.layer.masksToBounds = true
        backgroundFlagSecondView.layer.cornerRadius = 10
        backgroundFlagSecondView.layer.masksToBounds = true
        backgroundFlagFirstView.layer.cornerRadius = 10
        backgroundFlagFirstView.layer.masksToBounds = true
        textViewTypeText.layer.cornerRadius = 20
        textViewTypeText.layer.masksToBounds = true
        textViewGetText.layer.cornerRadius = 20
        textViewGetText.layer.masksToBounds = true
        setupOverlayView()
        putTextView.layer.borderWidth = 2
        putTextView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        putTextView.layer.cornerRadius = 20
        putTextView.layer.masksToBounds = true
        
        getTextView.layer.borderWidth = 2
        getTextView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        getTextView.layer.cornerRadius = 20
        getTextView.layer.masksToBounds = true
        
        
    }
    
    func setupOverlayView() {
        overlayView = OverlayView(frame: textViewTypeText.bounds)
        overlayView.isUserInteractionEnabled = false
        textViewTypeText.addSubview(overlayView)
    }
    
    func showOverlayView(_ show: Bool) {
        overlayView.isHidden = !show
        if show {
            textViewTypeText.bringSubviewToFront(overlayView)
        } else {
            textViewTypeText.sendSubviewToBack(overlayView)
        }
    }
    
    @objc func dismissKeyboard() {
        textViewTypeText.resignFirstResponder()
    }
    //
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        if textView.text.isEmpty {
            showOverlayView(false)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.gestureRecognizers?.forEach {
            if let tapGesture = $0 as? UITapGestureRecognizer {
                view.removeGestureRecognizer(tapGesture)
            }
            if textView.text.isEmpty {
                showOverlayView(true)
            }
        }
    }
    @IBAction func deleteTypeTextDidTap(_ sender: Any) {
        textViewTypeText.text = ""
        
    }
    
    @IBAction func riversoButtonDidTap(_ sender: Any) {
        if isSwapped {
            let tempText = firstLabel.text
            firstLabel.text = secondLabel.text
            secondLabel.text = tempText
            let tempImage = firstFlag.image
            firstFlag.image = secondImage.image
            secondImage.image = tempImage
           
        } else {
            let tempText = secondLabel.text
            secondLabel.text = firstLabel.text
            firstLabel.text = tempText
            let tempImage = secondImage.image
            secondImage.image = firstFlag.image
            firstFlag.image = tempImage
        }
        isSwapped.toggle()
    }
    
    
    @IBAction func backbuttonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


