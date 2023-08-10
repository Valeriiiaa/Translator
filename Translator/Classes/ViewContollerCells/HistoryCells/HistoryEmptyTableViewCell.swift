//
//  HistoryEmptyTableViewCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import UIKit

class HistoryEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyCellImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyCellImage.image = emptyCellImage.image?.imageByMakingWhiteBackgroundTransparent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
