//
//  GoogleMic.swift
//  Translator
//
//  Created by Valeriya Chernyak on 06.08.2023.
//

import UIKit

class GoogleMic: UIView {
   
    @IBOutlet weak var saySmthLabel: UILabel!
    @IBOutlet weak var translatedLanguage: UILabel!
    @IBOutlet weak var micImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}

extension GoogleMic {
    class func fromNib() -> GoogleMic {
        return Bundle(for: GoogleMic.self).loadNibNamed("GoogleMic", owner: nil, options: nil)![0] as! GoogleMic
    }
}

