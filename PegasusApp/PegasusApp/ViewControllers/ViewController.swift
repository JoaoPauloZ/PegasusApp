//
//  ViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 15/09/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var labelNetworkName = UILabel.newAutoLayout()
    private lazy var fieldIP = UITextField.newAutoLayout()

    private lazy var labelThrottle = UILabel.newAutoLayout()
    private lazy var labelYaw = UILabel.newAutoLayout()

    private lazy var labelPitch = UILabel.newAutoLayout()
    private lazy var labelRoll = UILabel.newAutoLayout()

    private lazy var leftJoystick = CDJoystick()

    private lazy var rightJoystick = CDJoystick()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        addTopView()

        leftJoystick.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        leftJoystick.substrateColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        leftJoystick.substrateBorderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        leftJoystick.substrateBorderWidth = 1.0
        leftJoystick.stickSize = CGSize(width: 100, height: 100)
        leftJoystick.stickColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        leftJoystick.stickBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        leftJoystick.stickBorderWidth = 2.0
        leftJoystick.fade = 0.5
        view.addSubview(leftJoystick)
        leftJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoPinEdge(toSuperviewMargin: .left, withInset: 20)
        leftJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: 20)


        rightJoystick.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        rightJoystick.substrateColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        rightJoystick.substrateBorderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        rightJoystick.substrateBorderWidth = 1.0
        rightJoystick.stickSize = CGSize(width: 100, height: 100)
        rightJoystick.stickColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        rightJoystick.stickBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rightJoystick.stickBorderWidth = 2.0
        rightJoystick.fade = 0.5
        view.addSubview(rightJoystick)
        rightJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoPinEdge(toSuperviewMargin: .right, withInset: 20)
        rightJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: 20)

        labelYaw.text = "Yaw\n1.25"
        labelYaw.textColor = .white
        labelYaw.numberOfLines = 2
        labelYaw.textAlignment = .center
        labelYaw.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelYaw)
        labelYaw.autoPinEdge(.bottom, to: .top, of: leftJoystick, withOffset: -5)
        labelYaw.autoPinEdge(.left, to: .left, of: leftJoystick, withOffset: 15)

        labelThrottle.text = "Thottle\n23%"
        labelThrottle.textColor = .white
        labelThrottle.numberOfLines = 2
        labelThrottle.textAlignment = .center
        labelThrottle.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelThrottle)
        labelThrottle.autoPinEdge(.bottom, to: .top, of: leftJoystick, withOffset: -5)
        labelThrottle.autoPinEdge(.right, to: .right, of: leftJoystick, withOffset: -10)

        labelPitch.text = "Pitch\n10.0"
        labelPitch.textColor = .white
        labelPitch.numberOfLines = 2
        labelPitch.textAlignment = .center
        labelPitch.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelPitch)
        labelPitch.autoPinEdge(.bottom, to: .top, of: rightJoystick, withOffset: -5)
        labelPitch.autoPinEdge(.left, to: .left, of: rightJoystick, withOffset: 10)

        labelRoll.text = "Roll\n0.5"
        labelRoll.textColor = .white
        labelRoll.numberOfLines = 2
        labelRoll.textAlignment = .center
        labelRoll.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelRoll)
        labelRoll.autoPinEdge(.bottom, to: .top, of: rightJoystick, withOffset: -5)
        labelRoll.autoPinEdge(.right, to: .right, of: rightJoystick, withOffset: -15)
    }

    private func addTopView() {

        let topView = UIView.newAutoLayout()
        view.addSubview(topView)
        topView.autoAlignAxis(toSuperviewAxis: .vertical)
        topView.autoPinEdge(toSuperviewMargin: .top, withInset: 15)

        let iconNet = UIImageView.newAutoLayout()
        iconNet.backgroundColor = .green
        iconNet.contentMode = .center
        topView.addSubview(iconNet)
        iconNet.autoSetDimensions(to: CGSize(width: 25, height: 25))
        iconNet.autoPinEdge(toSuperviewMargin: .left)

        labelNetworkName.text = "T.A.R.D.I.S."
        labelNetworkName.textColor = .white
        labelNetworkName.textAlignment = .center
        labelNetworkName.font = UIFont.boldSystemFont(ofSize: 22)
        topView.addSubview(labelNetworkName)
        labelNetworkName.autoPinEdge(.left, to: .right, of: iconNet, withOffset: 10)
        labelNetworkName.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        iconNet.autoAlignAxis(.horizontal, toSameAxisOf: labelNetworkName)

        fieldIP.font = UIFont.boldSystemFont(ofSize: 22)
        fieldIP.placeholder = "192.168.0.100"
        fieldIP.keyboardType = .numberPad
        fieldIP.textAlignment = .center
        fieldIP.textColor = .white
        topView.addSubview(fieldIP)
        fieldIP.autoPinEdge(.top, to: .bottom, of: iconNet, withOffset: 10)
        fieldIP.autoPinEdge(toSuperviewEdge: .left)
        fieldIP.autoPinEdge(toSuperviewEdge: .right)
        fieldIP.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)

        let line = UIView.newAutoLayout()
        line.backgroundColor = .gray
        topView.addSubview(line)
        line.autoSetDimension(.height, toSize: 1)
        line.autoPinEdge(toSuperviewEdge: .left)
        line.autoPinEdge(toSuperviewEdge: .right)
        line.autoPinEdge(toSuperviewEdge: .bottom)
    }

}
