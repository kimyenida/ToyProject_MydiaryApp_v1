//
//  ClearBtnExtension.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/13/23.
//

import UIKit

extension UITextField{
    
    func setTextFieldStyle(holdertext: String){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.attributedPlaceholder = NSAttributedString(string: holdertext, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.keyboardType = .emailAddress
        self.text = ""
        self.textColor = .black

    }
    
    func setClearButton(mode: UITextField.ViewMode) {
            let clearButton = UIButton(type: .custom)
            clearButton.setImage(UIImage(systemName: "delete.left.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
            clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            clearButton.contentMode = .scaleAspectFit
            clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
            self.rightView = clearButton
            self.rightViewMode = mode
        }
        
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
    }
    
}
