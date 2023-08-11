//
//  GoogleMic.swift
//  Translator
//
//  Created by Valeriya Chernyak on 06.08.2023.
//

import UIKit

class GoogleMic: UIView {
    @IBOutlet weak var trySaySmth: UILabel!
    @IBOutlet weak var translatedLanguage: UILabel!
    @IBOutlet weak var micImageView: UIImageView!
    
    @IBOutlet weak var pulseTwoView: UIView!
    @IBOutlet weak var pulseOneView: UIView!
    
    public var isAnimating = false
    public var didHideView: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.masksToBounds = true
        roundPulse()
    }
    
    public func addPulse(volume: Float) {
        let value = volume > 0 ? CGFloat(volume) * 1 + 1.4 : 1
        let secondValue = volume > 0 ? CGFloat(volume) * 1 + 1.1 : 1
        print("[log] new widht \(value)")
        UIView.animate(withDuration: 1, animations: {
            self.pulseOneView.transform = .init(scaleX: value, y: value)
            self.pulseTwoView.transform = .init(scaleX: secondValue, y: secondValue)
        })
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview == nil else { return }
        didHideView?()
    }
    
    private func roundPulse() {
        pulseOneView.layer.cornerRadius = 84 / 2
        pulseTwoView.layer.cornerRadius = 84 / 2
        pulseOneView.layer.masksToBounds = true
        pulseTwoView.layer.masksToBounds = true
    }
}

extension GoogleMic {
    class func fromNib() -> GoogleMic {
        return Bundle(for: GoogleMic.self).loadNibNamed("GoogleMic", owner: nil, options: nil)![0] as! GoogleMic
    }
}

