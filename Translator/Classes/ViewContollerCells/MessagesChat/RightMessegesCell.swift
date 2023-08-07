//
//  RightMessegesCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class RightMessegesCell: UITableViewCell {

    @IBOutlet weak var translatedFlag: UIImageView!
    @IBOutlet weak var originalFlag: UIImageView!
    @IBOutlet weak var textLabelSecond: UILabel!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var backgorundMessagesView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgorundMessagesView.layer.cornerRadius = 20
            translatedFlag.layer.cornerRadius = 1
            originalFlag.layer.cornerRadius = 1

        default: backgorundMessagesView.layer.cornerRadius = 30
                 translatedFlag.layer.cornerRadius = 2
                 originalFlag.layer.cornerRadius = 2
            
        }
       
        translatedFlag.layer.masksToBounds = true
        originalFlag.layer.masksToBounds = true
        translatedFlag.layer.borderWidth = 1
        translatedFlag.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        originalFlag.layer.borderWidth = 1
        originalFlag.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        backgorundMessagesView.layer.borderWidth = 2
        backgorundMessagesView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        backgorundMessagesView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
       
      
    }

    @IBAction func listenTextDidTap(_ sender: Any) {
    }
    @IBAction func copyTextDidTap(_ sender: Any) {
    }
    @IBAction func deleteBinDidTap(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    func configure(textFirst: String, textSecond: String) {
        textLabelSecond.text = textSecond
        firstTextLabel.text = textFirst
    }
}
