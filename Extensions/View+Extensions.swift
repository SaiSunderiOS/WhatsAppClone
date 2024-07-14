//
//  View+Extensions.swift
//  WhatsApp Clone
//
//  Created by SaiSunder on 14/07/24.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


class PlaceholderTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        return label
    }()
    
    var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            updatePlaceholderVisibility()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textDidChange() {
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}

