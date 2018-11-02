//
//  MotorSettingsCell.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 14/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

protocol MotorSettingsCellDelegate: class {
    func update(_ preference: MotorPreference, forMotorAt index: Int)
}

class MotorSettingsCell: UICollectionViewCell {

    static let reuseId: String = "MotorSettingsCell"

    private lazy var titleLabel = UILabel.newAutoLayout()
    private lazy var increaseField = FloatingTextField.newAutoLayout()
    private lazy var minSpeedField = FloatingTextField.newAutoLayout()
    private lazy var maxSpeedField = FloatingTextField.newAutoLayout()

    var motorIndex: Int = -1 {
        didSet {
            titleLabel.text = "Motor \(motorIndex)"
        }
    }

    var motorPref: MotorPreference? {
        didSet {
            if let pref = self.motorPref {
                minSpeedField.text = String(pref.minAngleESC)
                maxSpeedField.text = String(pref.maxAngleESC)
                increaseField.text = String(pref.increaseValue)
            }
        }
    }

    var delegate: MotorSettingsCellDelegate?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black
        self.layer.borderColor = UIColor.pegasusGreen.cgColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.pegasusGreen.cgColor
        self.layer.shadowOpacity = 0.3
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
        minSpeedField.keyboardType = .numberPad
        minSpeedField.delegate = self
        contentView.addSubview(minSpeedField)
        minSpeedField.autoMatch(.width, to: .width, of: minSpeedField.floatingLabel)
        minSpeedField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        minSpeedField.autoPinEdge(.left, to: .left, of: titleLabel)

        maxSpeedField.floatingLabel.text = "Potência máxima"
        maxSpeedField.alwaysShowFloatingLabel = true
        maxSpeedField.keyboardType = .numberPad
        maxSpeedField.delegate = self
        contentView.addSubview(maxSpeedField)
        maxSpeedField.autoMatch(.width, to: .width, of: maxSpeedField.floatingLabel)
        maxSpeedField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        maxSpeedField.autoPinEdge(.left, to: .right, of: minSpeedField, withOffset: 20)

        increaseField.floatingLabel.text = "Incremento"
        increaseField.alwaysShowFloatingLabel = true
        increaseField.keyboardType = .numberPad
        increaseField.delegate = self
        contentView.addSubview(increaseField)
        increaseField.autoMatch(.width, to: .width, of: increaseField.floatingLabel)
        increaseField.autoPinEdge(.top, to: .bottom, of: minSpeedField, withOffset: 15)
        increaseField.autoPinEdge(.left, to: .left, of: titleLabel)
    }
}

extension MotorSettingsCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let fullText = text.replacingCharacters(in: textRange, with: string)

            let number = Int(fullText) ?? 0

            if textField == minSpeedField {
                motorPref?.minAngleESC = number
            } else if textField == maxSpeedField {
                motorPref?.maxAngleESC = number
            } else if textField == increaseField {
                motorPref?.increaseValue = number
            }
            if let pref = self.motorPref, motorIndex > -1 {
                delegate?.update(pref, forMotorAt: self.motorIndex)
            }

        }
        return true
    }
}
