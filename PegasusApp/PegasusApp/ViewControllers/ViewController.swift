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
    let ip: String = "192.168.1.101"
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
    private var throttle: Int = 0
    private var pitch: Int = 0
    private var roll: Int = 0
    private var yaw: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bgImage = UIImage(named: "spiration-dark") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            view.backgroundColor = .lightGray
        }

        addTopView()

        let margin: CGFloat = 20

        leftJoystick.backgroundColor = .clear
        leftJoystick.substrateColor = UIColor(white: 1, alpha: 0.5)
        leftJoystick.substrateBorderColor = UIColor(hex: "22ff36")
        leftJoystick.substrateBorderWidth = 2.0
        leftJoystick.stickColor = UIColor.init(hex: "686868")
        leftJoystick.stickBorderColor = .black
        leftJoystick.stickBorderWidth = 1.0
        leftJoystick.trackingHandler = joystickManager.leftHandler
        view.addSubview(leftJoystick)
        leftJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoPinEdge(toSuperviewMargin: .left, withInset: margin)
        leftJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: margin)

        rightJoystick.backgroundColor = .clear
        rightJoystick.substrateColor = UIColor.init(white: 1, alpha: 0.5)
        rightJoystick.substrateBorderColor = UIColor.init(hex: "0A8FFE")
        rightJoystick.substrateBorderWidth = 2.0
        rightJoystick.stickColor = UIColor.init(hex: "686868")
        rightJoystick.stickBorderColor = .black
        rightJoystick.stickBorderWidth = 1.0
        rightJoystick.trackingHandler = joystickManager.rightHandler
        view.addSubview(rightJoystick)
        rightJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoPinEdge(toSuperviewMargin: .right, withInset: margin)
        rightJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: margin)

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
        addSettingsButton()
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
        fieldIP.font = UIFont.boldSystemFont(ofSize: 22)
        fieldIP.text = ip
        fieldIP.placeholder = "192.168.0.0"
        fieldIP.keyboardType = .numberPad
        fieldIP.textAlignment = .center
        fieldIP.textColor = .white
        view.addSubview(fieldIP)
        fieldIP.autoSetDimension(.width, toSize: 200)
        fieldIP.autoAlignAxis(toSuperviewAxis: .vertical)
        fieldIP.autoPinEdge(toSuperviewEdge: .top, withInset: 25)

        let line = UIView.newAutoLayout()
        line.backgroundColor = .gray
        view.addSubview(line)
        line.autoSetDimension(.height, toSize: 1)
        line.autoPinEdge(.left, to: .left, of: fieldIP)
        line.autoPinEdge(.right, to: .right, of: fieldIP)
        line.autoPinEdge(.top, to: .bottom, of: fieldIP)
    }

    private func addButtons() {
        btnConnect.backgroundColor = .blue
        btnConnect.setTitle("Connect", for: .normal)
        btnConnect.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btnConnect.layer.shadowRadius = 2
        btnConnect.layer.shadowColor = UIColor.black.cgColor
        btnConnect.layer.shadowOpacity = 0.2
        btnConnect.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnConnect.addTarget(self, action: #selector(connect), for: .touchUpInside)
        view.addSubview(btnConnect)
        btnConnect.autoAlignAxis(toSuperviewAxis: .vertical)
        btnConnect.autoSetDimensions(to: CGSize(width: 100, height: 100))
        btnConnect.autoPinEdge(.top, to: .bottom, of: fieldIP, withOffset: 25)

        btnStart.backgroundColor = .red
        btnStart.setTitle("Start", for: .normal)
        btnStart.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btnStart.layer.shadowRadius = 2
        btnStart.layer.shadowColor = UIColor.black.cgColor
        btnStart.layer.shadowOpacity = 0.2
        btnStart.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnStart.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(btnStart)
        btnStart.autoAlignAxis(toSuperviewAxis: .vertical)
        btnStart.autoSetDimensions(to: CGSize(width: 100, height: 100))
        btnStart.autoPinEdge(.top, to: .bottom, of: btnConnect, withOffset: 15)
    }

    private func addSettingsButton() {
        let btn = UIButton.newAutoLayout()
        btn.backgroundColor = UIColor(hex: "22ff36")//.primaryColor
        view.addSubview(btn)
        btn.autoSetDimensions(to: CGSize(width: 45, height: 45))
        btn.autoPinEdge(toSuperviewMargin: .top, withInset: 10)
        btn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
    }

}

// MARK: JoystickManagerDelegate
extension ViewController: JoystickManagerDelegate {

    func didChangeThrottle(_ value: CGFloat) {
        let iValue = Int(value)
        if iValue != self.throttle {
            self.throttle = iValue
            self.labelThrottle.text = "Throttle\n\(self.throttle)%"
            self.sendComands()
        }
    }

    func didChangePitch(_ value: CGFloat) {
        let iValue = Int(value)
        if iValue != self.pitch {
            self.pitch = iValue
            self.labelPitch.text = "Pitch\n\(self.pitch)"
            self.sendComands()
        }
    }

    func didChangeRoll(_ value: CGFloat) {
        let iValue = Int(value)
        if iValue != self.roll {
            self.roll = iValue
            self.labelRoll.text = "Roll\n\(self.roll)"
            self.sendComands()
        }
    }

    func didChangeYaw(_ value: CGFloat) {
        let iValue = Int(value)
        if iValue != self.yaw {
            self.yaw = iValue
            self.labelYaw.text = "Yaw\n\(self.yaw)"
            self.sendComands()
        }
    }

}

// MARK: Actions and  UDP Connection
extension ViewController {

    @objc private func connect() {
        client = UDPClient.init(address: ip, port: port)
        client?.enableBroadcast()
        // enviar um comando e ver se deu success
    }

    @objc private func start() {
        let result = client?.send(data: "start engines".data(using: .utf8) ?? Data())
        print("Sended: \(result?.isSuccess ?? false)")
    }

    private func sendComands() {
        //let fullStr = "T=\(throttle);P=\(pitch);R=\(roll);Y=\(yaw)"
        let fullStr = "C\(throttle);\(pitch);\(roll);\(yaw);"
        print(fullStr)
        if let data = fullStr.data(using: .utf8) {
            let result = client?.send(data: data)
            print("Sended: \(result?.isSuccess ?? false)")
        }
    }

}

// MARK: UI Interface Orientation
extension ViewController {

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

