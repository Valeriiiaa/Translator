//
//  HistoryFullTableViewCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class HistoryFullTableViewCell: UITableViewCell {

    @IBOutlet weak var flagSecond: UIImageView!
    @IBOutlet weak var flagFirst: UIImageView!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var backgroundHistoryView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundHistoryView.layer.cornerRadius = 20
        backgroundHistoryView.layer.masksToBounds = true
        backgroundHistoryView.layer.borderWidth = 2
        backgroundHistoryView.layer.borderColor = UIColor(red: 112/255, green: 139/255, blue: 194/255, alpha: 1).cgColor
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    @IBAction func binDeleteDidTap(_ sender: Any) {
    }
}
