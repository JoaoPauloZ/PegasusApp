//
//  MotorSettingsCell.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 14/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class MotorSettingsCell: UICollectionViewCell {

    static let reuseId: String = "MotorSettingsCell"

    lazy var titleLabel = UILabel.newAutoLayout()
    lazy var minSpeedField = FloatingTextField.newAutoLayout()
    lazy var maxSpeedField = FloatingTextField.newAutoLayout()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black
        self.layer.borderColor = UIColor.pegasusGreen.cgColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.shadowRadius = 8
        self.layer.shadowColor = UIColor.pegasusGreen.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)

        addLabelTitle()
    }

    private func addLabelTitle() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.bold(ofSize: 26)
        contentView.addSubview(titleLabel)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 25)

        minSpeedField.floatingLabel.text = "Potência mínima"
        minSpeedField.alwaysShowFloatingLabel = true
        minSpeedField.textAlignment = .right
        minSpeedField.keyboardType = .numbersAndPunctuation
        minSpeedField.autoSetDimension(.width, toSize: 50)
        contentView.addSubview(minSpeedField)
        minSpeedField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
        minSpeedField.autoPinEdge(toSuperviewEdge: .right, withInset: 25)

        maxSpeedField.floatingLabel.text = "Potência máxima"
        maxSpeedField.alwaysShowFloatingLabel = true
        maxSpeedField.textAlignment = .right
        maxSpeedField.keyboardType = .numbersAndPunctuation
        maxSpeedField.autoSetDimension(.width, toSize: 50)
        contentView.addSubview(maxSpeedField)
        maxSpeedField.autoPinEdge(.top, to: .bottom, of: minSpeedField, withOffset: 20)
        maxSpeedField.autoPinEdge(toSuperviewEdge: .right, withInset: 25)
    }
}
