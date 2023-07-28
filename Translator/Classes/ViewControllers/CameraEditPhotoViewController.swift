//
//  CameraEditPhotoViewController.swift
//  Translator
//
//  Created by Valeriya Chernyak on 27.07.2023.
//

import UIKit

class CameraEditPhotoViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundStuckView: UIView!
    @IBOutlet weak var backgrounMainView: UIView!
    @IBOutlet weak var backgroundRotateView: UIView!
    
    public var image: UIImage?
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        backgrounMainView.layer.cornerRadius = 15
        backgrounMainView.layer.masksToBounds = true
        backgroundStuckView.layer.cornerRadius = 10
        backgroundStuckView.layer.masksToBounds = true
        backgroundRotateView.layer.cornerRadius = 15
        backgroundRotateView.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        guard let image else { return }
        backgroundImageView.image = image
        
    }
    

    @IBAction func selectCountryButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func rotateButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func checkmarkDidTap(_ sender: Any) {
    }
   
    @IBAction func backButtonDidTap(_ sender: Any) {
    }
    
}
