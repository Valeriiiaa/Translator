//
//  TranslatorTextViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit


class TranslatorTextViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var backgroundFlagSecondView: UIView!
    @IBOutlet weak var backgroundFlagFirstView: UIView!
    
    var overlayView: OverlayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        backgroundMainView.layer.cornerRadius = 15
        backgroundMainView.layer.masksToBounds = true
        backgroundFlagSecondView.layer.cornerRadius = 10
        backgroundFlagSecondView.layer.masksToBounds = true
        backgroundFlagFirstView.layer.cornerRadius = 10
        backgroundFlagFirstView.layer.masksToBounds = true
        textView.layer.borderWidth = 2
        textView.layer.borderColor =  UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        textView.layer.cornerRadius = 20
        textView.layer.masksToBounds = true
        setupOverlayView()
        
    }
    
    func setupOverlayView() {
        overlayView = OverlayView(frame: textView.bounds)
        overlayView.isUserInteractionEnabled = false
        textView.addSubview(overlayView)
    }
    
    func showOverlayView(_ show: Bool) {
        overlayView.isHidden = !show
        if show {
            textView.bringSubviewToFront(overlayView)
        } else {
            textView.sendSubviewToBack(overlayView)
        }
    }
   
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
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
    
    
    
    
}
