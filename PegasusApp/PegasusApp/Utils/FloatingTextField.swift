//
//  FloatingTextField.swift
//  Neanderthal
//
//  Created by João Paulo Serodio on 23/08/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class FloatingTextField: JVFloatLabeledTextField {

    private let paddingDefault = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0);

    var image: UIImage?

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddingDefault)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddingDefault)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, paddingDefault)
    }

    override var placeholder: String? {
        didSet {
            let attr = [
                NSAttributedStringKey.font: UIFont.semiBold(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.darkGray
            ]
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attr)
        }
    }

    let line = UIView.newAutoLayout()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.floatingLabelTextColor = .dark2
        self.floatingLabelActiveTextColor = .secundaryColor
        self.floatingLabelFont = UIFont.semiBold(ofSize: 13)
        self.font = UIFont.regular(ofSize: 15)
        self.textColor = .light1
        self.keyboardAppearance = .dark
        line.backgroundColor = .dark2
        self.addSubview(line)
        line.autoSetDimension(.height, toSize: 1)
        line.autoPinEdge(toSuperviewEdge: .left)
        line.autoPinEdge(toSuperviewEdge: .right)
        line.autoPinEdge(toSuperviewEdge: .bottom)
    }

}