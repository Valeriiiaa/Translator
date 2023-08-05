//
//  HistoryFullTableViewCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class HistoryFullTableViewCell: UITableViewCell {
    
    var deleteButtonTapped: (() -> Void)?

    @IBOutlet weak var translatedTextLabel: UILabel!
    @IBOutlet weak var originalTextLabel: UILabel!
    @IBOutlet weak var flagSecond: UIImageView!
    @IBOutlet weak var flagFirst: UIImageView!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var backgroundHistoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            backgroundHistoryView.layer.cornerRadius = 20

        default: backgroundHistoryView.layer.cornerRadius = 30
        }
        
        backgroundHistoryView.layer.masksToBounds = true
        backgroundHistoryView.layer.borderWidth = 2
        backgroundHistoryView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
}
    
    func configure(originalText: String, translatedText: String, flagFirst: String, flagSecond: String, firstLanguage: String, secondLanguage: String ) {
        self.translatedTextLabel.text = translatedText
        self.originalTextLabel.text = originalText
        self.flagSecond.image = UIImage(named: flagSecond)
        self.flagFirst.image = UIImage(named: flagFirst)
        labelSecond.text = secondLanguage
        labelFirst.text = firstLanguage
    }

    @IBAction func binDeleteDidTap(_ sender: Any) {
        deleteButtonTapped?()
    }
}
