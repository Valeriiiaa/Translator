//
//  RightMessegesCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class RightMessegesCell: UITableViewCell {

    @IBOutlet weak var textLabelSecond: UILabel!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var backgorundMessagesView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgorundMessagesView.layer.borderWidth = 2
        backgorundMessagesView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        backgorundMessagesView.layer.cornerRadius = 20
        backgorundMessagesView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
       
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    func configure(textFirst: String, textSecond: String) {
        textLabelSecond.text = textSecond
        firstTextLabel.text = textFirst
    }
}
