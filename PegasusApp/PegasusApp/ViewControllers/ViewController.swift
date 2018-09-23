//
//  ViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 15/09/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // sudo nc -ul 80
    let ip: String = "192.168.1.100"
    let port: Int32 = 80

    private lazy var labelNetworkName = UILabel.newAutoLayout()
    private lazy var fieldIP = UITextField.newAutoLayout()

    // MARK: Comands buttons
    private lazy var btnConnect = UIButton.newAutoLayout()
    private lazy var btnStart = UIButton.newAutoLayout()

    // MARK: Labels values of the commands
    private lazy var labelThrottle = UILabel.newAutoLayout()
    private lazy var labelYaw = UILabel.newAutoLayout()
    private lazy var labelPitch = UILabel.newAutoLayout()
    private lazy var labelRoll = UILabel.newAutoLayout()

    // MARK: Joysticks
    private lazy var leftJoystick = CDJoystick()
    private lazy var rightJoystick = CDJoystick()
    private lazy var joystickManager = JoystickManager(self)

    // MARK: UDP Client
    private var client: UDPClient?

    // MARK: Axis values
    private var throttle: CGFloat = 0.0
    private var pitch: CGFloat = 0.0
    private var roll: CGFloat = 0.0
    private var yaw: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        addTopView()

        leftJoystick.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        leftJoystick.substrateColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        leftJoystick.substrateBorderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        leftJoystick.substrateBorderWidth = 1.0
        leftJoystick.stickColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        leftJoystick.stickBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        leftJoystick.stickBorderWidth = 2.0
        leftJoystick.fade = 0.5
        leftJoystick.trackingHandler = joystickManager.leftHandler
        view.addSubview(leftJoystick)
        leftJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoPinEdge(toSuperviewMargin: .left, withInset: 20)
        leftJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: 20)

        rightJoystick.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        rightJoystick.substrateColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        rightJoystick.substrateBorderColor = #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)
        rightJoystick.substrateBorderWidth = 1.0
        rightJoystick.stickColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        rightJoystick.stickBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rightJoystick.stickBorderWidth = 2.0
        rightJoystick.fade = 0.5
        rightJoystick.trackingHandler = joystickManager.rightHandler
        view.addSubview(rightJoystick)
        rightJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoPinEdge(toSuperviewMargin: .right, withInset: 20)
        rightJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: 20)

        labelYaw.text = "Yaw\n0"
        labelYaw.textColor = .white
        labelYaw.numberOfLines = 2
        labelYaw.textAlignment = .center
        labelYaw.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelYaw)
        labelYaw.autoPinEdge(.bottom, to: .top, of: leftJoystick, withOffset: -5)
        labelYaw.autoPinEdge(.left, to: .left, of: leftJoystick, withOffset: 15)

        labelThrottle.text = "Throttle\n0%"
        labelThrottle.textColor = .white
        labelThrottle.numberOfLines = 2
        labelThrottle.textAlignment = .center
        labelThrottle.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelThrottle)
        labelThrottle.autoPinEdge(.bottom, to: .top, of: leftJoystick, withOffset: -5)
        labelThrottle.autoPinEdge(.right, to: .right, of: leftJoystick, withOffset: -10)

        labelPitch.text = "Pitch\n0"
        labelPitch.textColor = .white
        labelPitch.numberOfLines = 2
        labelPitch.textAlignment = .center
        labelPitch.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelPitch)
        labelPitch.autoPinEdge(.bottom, to: .top, of: rightJoystick, withOffset: -5)
        labelPitch.autoPinEdge(.left, to: .left, of: rightJoystick, withOffset: 10)

        labelRoll.text = "Roll\n0"
        labelRoll.textColor = .white
        labelRoll.numberOfLines = 2
        labelRoll.textAlignment = .center
        labelRoll.font = UIFont.boldSystemFont(ofSize: 26)
        view.addSubview(labelRoll)
        labelRoll.autoPinEdge(.bottom, to: .top, of: rightJoystick, withOffset: -5)
        labelRoll.autoPinEdge(.right, to: .right, of: rightJoystick, withOffset: -15)

        addButtons()
    }

    var firstTime = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTime {
            let w = rightJoystick.frame.width/2.5
            rightJoystick.stickSize = CGSize(width: w, height: w)
            leftJoystick.stickSize = CGSize(width: w, height: w)
            btnConnect.layer.cornerRadius = btnConnect.frame.height/2
            btnStart.layer.cornerRadius = btnStart.frame.height/2
            firstTime = false
        }
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

    private func addButtons() {
        btnConnect.backgroundColor = .blue
        btnConnect.setTitle("Connect", for: .normal)
        btnConnect.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        btnConnect.layer.shadowRadius = 2
        btnConnect.layer.shadowColor = UIColor.black.cgColor
        btnConnect.layer.shadowOpacity = 0.2
        btnConnect.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnConnect.addTarget(self, action: #selector(connect), for: .touchUpInside)
        view.addSubview(btnConnect)
        btnConnect.autoAlignAxis(toSuperviewAxis: .vertical)
        btnConnect.autoMatch(.height, to: .height, of: leftJoystick, withMultiplier: 0.6)
        btnConnect.autoMatch(.width, to: .height, of: leftJoystick, withMultiplier: 0.6)
        btnConnect.autoPinEdge(.top, to: .bottom, of: fieldIP, withOffset: 15)

        btnStart.backgroundColor = .red
        btnStart.setTitle("Start", for: .normal)
        btnStart.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        btnStart.layer.shadowRadius = 2
        btnStart.layer.shadowColor = UIColor.black.cgColor
        btnStart.layer.shadowOpacity = 0.2
        btnStart.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnStart.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(btnStart)
        btnStart.autoAlignAxis(toSuperviewAxis: .vertical)
        btnStart.autoMatch(.height, to: .height, of: leftJoystick, withMultiplier: 0.6)
        btnStart.autoMatch(.width, to: .height, of: leftJoystick, withMultiplier: 0.6)
        btnStart.autoPinEdge(.top, to: .bottom, of: btnConnect, withOffset: 15)
    }

}

// MARK: JoystickManagerDelegate
extension ViewController: JoystickManagerDelegate {

    func didChangeThrottle(_ value: CGFloat) {
        self.labelThrottle.text = "Throttle\n\(Int(value))%"
        self.throttle = value
        self.sendComands()
    }

    func didChangePitch(_ value: CGFloat) {
        self.labelPitch.text = "Pitch\n\(Int(value))"
        self.pitch = value
        self.sendComands()
    }

    func didChangeRoll(_ value: CGFloat) {
        self.labelRoll.text = "Roll\n\(Int(value))"
        self.roll = value
        self.sendComands()
    }

    func didChangeYaw(_ value: CGFloat) {
        self.labelYaw.text = "Yaw\n\(Int(value))"
        self.yaw = value
        self.sendComands()
    }
}

// MARK: Actions and  UDP Connection
extension ViewController {
    @objc private func connect() {
        client = UDPClient.init(address: ip, port: port)
        client?.enableBroadcast()
    }

    @objc private func start() {
        let result = client?.send(data: "start engines".data(using: .utf8) ?? Data())
        print("Sended: \(result?.isSuccess ?? false)")
    }

    private func sendComands() {
        //let fullStr = "T=\(throttle);P=\(pitch);R=\(roll);Y=\(yaw)"
        let fullStr = "\(throttle);\(pitch);\(roll);\(yaw);"
        if let data = fullStr.data(using: .utf8) {
            let result = client?.send(data: data)
            print("Sended: \(result?.isSuccess ?? false)")
        }
    }

}

