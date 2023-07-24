//
//  DrawerMenuEnums.swift
//  Translator
//
//  Created by Valeriya Chernyak on 24.07.2023.
//

import Foundation

enum DrawerMenuCellType {
    case itemsMenu(MenuItemsModel)
    case premiumPicture
    
    var reusedId: String {
        switch self {
        case.itemsMenu:
            return "MenuItemsCell"
        case.premiumPicture:
            return "PremiumImageCell"
        }
    }
}
