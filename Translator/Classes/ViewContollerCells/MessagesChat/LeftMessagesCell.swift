//
//  LeftMessagesCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit
import IHProgressHUD

class LeftMessagesCell: UITableViewCell {
    
    var listenTextDidTap: ((String) -> Void)?
    
    var deleteButtonTapped: (() -> Void)?

    @IBOutlet weak var translatedFlag: UIImageView!
    @IBOutlet weak var originalFlag: UIImageView!
    @IBOutlet weak var labelTextSecond: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var backgroundMessageView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundMessageView.layer.cornerRadius = 20
            translatedFlag.layer.cornerRadius = 1
            originalFlag.layer.cornerRadius = 1

        default: backgroundMessageView.layer.cornerRadius = 30
                 translatedFlag.layer.cornerRadius = 2
                 originalFlag.layer.cornerRadius = 2
        }
        backgroundMessageView.layer.borderWidth = 2
        translatedFlag.layer.masksToBounds = true
        originalFlag.layer.masksToBounds = true
        translatedFlag.layer.borderWidth = 1
        translatedFlag.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        originalFlag.layer.borderWidth = 1
        originalFlag.layer.borderColor = UIColor(red: 235/255, green: 239/255, blue: 248/255, alpha: 1).cgColor
        backgroundMessageView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
        backgroundMessageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
       
    }

    @IBAction func listenTextDidTap(_ sender: Any) {
        guard let text = labelTextSecond.text else { return }
        listenTextDidTap?(text)
    }
   
    @IBAction func copyTextDidTap(_ sender: Any) {
        UIPasteboard.general.string = labelTextSecond.text
        IHProgressHUD.showSuccesswithStatus("Translation copied")
        IHProgressHUD.dismissWithDelay(0.5)
    }
   
    @IBAction func deleteBinDidTap(_ sender: Any) {
        deleteButtonTapped?()
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func configure(labelFirst: String, labelSecond: String) {
        labelTextSecond.text = labelSecond
        labelText.text = labelFirst
    }
}
