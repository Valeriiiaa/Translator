//
//  TextField.swift
//  Translator
//
//  Created by Valeriya Chernyak on 25.07.2023.
//

import Foundation
import UIKit
           
class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: UIDevice.current.userInterfaceIdiom == .phone ? 45 : 65, bottom: 0, right: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: UIDevice.current.userInterfaceIdiom == .phone ? 10 : 20, bottom: 0, right: UIDevice.current.userInterfaceIdiom == .phone ? -10 : -20))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: UIDevice.current.userInterfaceIdiom == .phone ? -20 : -40, bottom: 0, right: UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40))
    }
}

