//
//  TextMessageView.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class OverlayView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 160/255, green: 168/255, blue: 196/255, alpha: 1)
        label.text = "Type something here..."
        label.font = UIFont(name: "Fixel-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
   
    private func setupViews() {
            addSubview(messageLabel)
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
            ])
        }
    }

