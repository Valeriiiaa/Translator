//
//  GoogleMic.swift
//  Translator
//
//  Created by Valeriya Chernyak on 06.08.2023.
//

import UIKit

class GoogleMic: UIView {
   
    @IBOutlet weak var textViewTrySaySmth: UITextView!
    @IBOutlet weak var translatedLanguage: UILabel!
    @IBOutlet weak var micImageView: UIImageView!
    
    public var didHideView: (() -> Void)?
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview == nil else { return }
        didHideView?()
    }
}

extension GoogleMic {
    class func fromNib() -> GoogleMic {
        return Bundle(for: GoogleMic.self).loadNibNamed("GoogleMic", owner: nil, options: nil)![0] as! GoogleMic
    }
}

