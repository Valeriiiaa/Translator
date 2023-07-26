//
//  SelectionCountryHeaderView.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class SelectionCountryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerName: UILabel!
    
    func configure(name: String) {
        headerName.text = name
    }
    
}
