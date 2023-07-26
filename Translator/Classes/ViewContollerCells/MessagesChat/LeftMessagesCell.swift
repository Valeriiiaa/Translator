//
//  LeftMessagesCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class LeftMessagesCell: UITableViewCell {

    @IBOutlet weak var labelTextSecond: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var backgroundMessageView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.layer.borderWidth = 2
        backgroundMessageView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        backgroundMessageView.layer.cornerRadius = 20
        backgroundMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func configure(labelFirst: String, labelSecond: String) {
        labelTextSecond.text = labelSecond
        labelText.text = labelFirst
    }
}
