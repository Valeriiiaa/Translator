//
//  FullScreenTextViewController.swift
//  Translator
//
//  Created by Kyrylo Chernov on 08.08.2023.
//

import UIKit

class FullScreenTextViewController: UIViewController {
   
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var translatedTextView: UITextView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }
   
    var translatedText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translatedTextView.text = translatedText
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationWasChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
        
    
    @objc func orientationWasChange() {
        if UIDevice.current.orientation == .portrait {
//            translatedTextView.transform = .identity
//            translatedTextView.frame = CGRect(x: 30, y: 101, width: 665, height: 307)
        } else if UIDevice.current.orientation == .landscapeRight {
            let landscapeTransform = CGAffineTransform(rotationAngle: .pi / 2) // 90 degrees
//            translatedTextView.transform = landscapeTransform
//            translatedTextView.frame = CGRect(x: 30, y: 35, width: 725, height: 300)
        }
    }
    
    @IBAction func closeDidTap(_ sender: Any) {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
   
}
