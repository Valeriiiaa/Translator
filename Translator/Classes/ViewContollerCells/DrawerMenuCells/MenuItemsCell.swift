//
//  MenuItemsCell.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import UIKit

class MenuItemsCell: UITableViewCell {
   
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
   
    func configure(image: String, label: String) {
        menuLabel.text = label
        menuImageView.image = UIImage(named: image)
    }
}
