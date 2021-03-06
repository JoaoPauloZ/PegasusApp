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

    private var ip: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "ip")
        }
        get {
            return UserDefaults.standard.string(forKey: "ip")
        }
    }
    let port: Int32 = 80

    private lazy var fieldIP = FloatingTextField.newAutoLayout()

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

    private var minValue: Int = 20
    private var lastComands = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bgImage = UIImage(named: "spiration-dark") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            view.backgroundColor = .lightGray
        }

        addSettingsButton()
        addIpField()
        addJoysticks()
        addLabels()
        addButtons()

        toggleJoysticks(enabled: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showSettings()
    }

    var firstTime = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTime {
            let w = rightJoystick.frame.width/2.5
            rightJoystick.stickSize = CGSize(width: w, height: w)
            leftJoystick.stickSize = CGSize(width: w, height: w)
            btnConnect.layer.cornerRadius = btnConnect.frame.height/2
            firstTime = false
        }
    }

    private func toggleJoysticks(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3) {
            self.labelYaw.alpha = alpha
            self.labelThrottle.alpha = alpha
            self.labelPitch.alpha = alpha
            self.labelRoll.alpha = alpha

            self.leftJoystick.fade = enabled ? 0.5 : 0.2
            self.leftJoystick.isUserInteractionEnabled = enabled
            self.rightJoystick.fade = enabled ? 0.5 : 0.2
            self.rightJoystick.isUserInteractionEnabled = enabled
        }
    }

    @objc private func showSettings() {
        let vc = SettingsViewController.init(self.client)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }

    private func vibrete(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

// MARK: Layout
extension ViewController {

    private func addLabels() {
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
    }

    private func addJoysticks() {
        let margin: CGFloat = 20
        leftJoystick.isUserInteractionEnabled = false
        leftJoystick.backgroundColor = .clear
        leftJoystick.substrateColor = UIColor(white: 1, alpha: 0.5)
        leftJoystick.substrateBorderColor = .pegasusGreen
        leftJoystick.substrateBorderWidth = 2.0
        leftJoystick.stickColor = .pegasusDarkGray
        leftJoystick.stickBorderColor = .black
        leftJoystick.stickBorderWidth = 1.0
        leftJoystick.trackingHandler = joystickManager.leftHandler
        view.addSubview(leftJoystick)
        leftJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        leftJoystick.autoPinEdge(toSuperviewMargin: .left, withInset: margin)
        leftJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: margin)

        rightJoystick.backgroundColor = .clear
        rightJoystick.substrateColor = UIColor(white: 1, alpha: 0.5)
        rightJoystick.substrateBorderColor = .pegasusGreen
        rightJoystick.substrateBorderWidth = 2.0
        rightJoystick.stickColor = .pegasusDarkGray
        rightJoystick.stickBorderColor = .black
        rightJoystick.stickBorderWidth = 1.0
        rightJoystick.trackingHandler = joystickManager.rightHandler
        view.addSubview(rightJoystick)
        rightJoystick.autoMatch(.width, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoMatch(.height, to: .height, of: view, withMultiplier: 0.5)
        rightJoystick.autoPinEdge(toSuperviewMargin: .right, withInset: margin)
        rightJoystick.autoPinEdge(toSuperviewMargin: .bottom, withInset: margin)
    }

    private func addIpField() {
        fieldIP.placeholder = "Endereço IP"
        fieldIP.text = ip
        fieldIP.delegate = self
        fieldIP.textAlignment = .right
        fieldIP.returnKeyType = .done
        fieldIP.keyboardType = .numbersAndPunctuation
        fieldIP.addTarget(nil, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        view.addSubview(fieldIP)
        fieldIP.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        fieldIP.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
    }

    private func addButtons() {
        btnConnect.tintColor = UIColor.pegasusGreen
        btnConnect.setImage(UIImage(named: "ic_start")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnConnect.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btnConnect.layer.shadowRadius = 2
        btnConnect.layer.shadowColor = UIColor.black.cgColor
        btnConnect.layer.shadowOpacity = 0.2
        btnConnect.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnConnect.addTarget(self, action: #selector(connect), for: .touchUpInside)
        let degrees: Double = 180
        self.btnConnect.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
        view.addSubview(btnConnect)
        btnConnect.autoAlignAxis(toSuperviewAxis: .vertical)
        btnConnect.autoPinEdge(.top, to: .bottom, of: fieldIP, withOffset: 25)
    }

    private func addSettingsButton() {
        let btn = UIButton.newAutoLayout()
        btn.setImage(UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .pegasusGreen
        btn.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
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
        self.throttle = iValue
        self.labelThrottle.text = "Throttle\n\(self.throttle)%"
        self.sendComands()
    }

    func didChangePitch(_ value: CGFloat) {
        let iValue = Int(value)
        if (iValue > 0 && iValue > minValue) {
            self.pitch = iValue - minValue
            self.sendComands()
        } else if (iValue < 0 && iValue < -minValue) {
            self.pitch = iValue + minValue
            self.sendComands()
        } else {
            self.pitch = 0
        }
        self.labelPitch.text = "Pitch\n\(self.pitch)"
    }

    func didChangeRoll(_ value: CGFloat) {
        let iValue = Int(value)
        if (iValue > 0 && iValue > minValue) {
            self.roll = iValue - minValue
            self.sendComands()
        } else if (iValue < 0 && iValue < -minValue) {
            self.roll = iValue + minValue
            self.sendComands()
        } else {
            self.roll = 0
        }
        self.labelRoll.text = "Roll\n\(self.roll)"
    }

    func didChangeYaw(_ value: CGFloat) {
        let iValue = Int(value)
        if (iValue > 0 && iValue > minValue) {
            self.yaw = iValue - minValue
            self.sendComands()
        } else if (iValue < 0 && iValue < -minValue) {
            self.yaw = iValue + minValue
            self.sendComands()
        } else {
            self.yaw = 0
        }
        self.labelYaw.text = "Yaw\n\(self.yaw)"
    }

}

// MARK: Actions and UDP Connection
extension ViewController {

    @objc private func connect() {

        self.vibrete(style: .heavy)

        if btnConnect.tintColor == .pegasusGreen {
            guard let ip = self.ip else { return }
            client = UDPClient.init(address: ip, port: port)
            client?.enableBroadcast()

            if let data = "S".data(using: .utf8) {
                let result = client?.send(data: data)
                if result?.isFailure ?? false {
                    let alert = UIAlertController(title: "Pegasus", message: "Não foi possível se conectar ao Drone.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.btnConnect.tintColor = .red
                        let degrees: Double = -90
                        self.btnConnect.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
                    }
                }
            }
            self.toggleJoysticks(enabled: true)
        } else {
            client?.close()
            client = nil
            UIView.animate(withDuration: 0.5) {
                self.btnConnect.tintColor = .pegasusGreen
                let degrees: Double = 180
                self.btnConnect.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
            }
            self.toggleJoysticks(enabled: false)
        }
    }

    @objc private func start() {
        let test = "U30;66;100;&65;65;100;&10;66;110;&50;77;130;&"
        let result = client?.send(data: test.data(using: .utf8) ?? Data())
        print("Sended: \(result?.isSuccess ?? false)")
    }

    private func sendComands() {
        //let fullStr = "T=\(throttle);P=\(pitch);R=\(roll);Y=\(yaw)"
        let fullStr = "C\(throttle);\(pitch);\(roll);\(yaw);"
        if let data = fullStr.data(using: .utf8) {
            let result = client?.send(data: data)
            print("Sended: \(result?.isSuccess ?? false)")
        }

        if fullStr != lastComands {
            self.vibrete(style: .light)
        }
        lastComands = fullStr
    }

}

// MARK: UITextFliedDelegate
extension ViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.ip = textField.text
    }

}

// MARK: UI Interface Orientation
extension ViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
}
