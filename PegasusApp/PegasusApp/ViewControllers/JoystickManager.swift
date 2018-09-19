//
//  JoystickManager.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 18/09/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

protocol JoystickManagerDelegate: class {
    func didChangeThrottle(_ value: CGFloat)
    func didChangePitch(_ value: CGFloat)
    func didChangeRoll(_ value: CGFloat)
    func didChangeYaw(_ value: CGFloat)
}

class JoystickManager {

    weak var delegate: JoystickManagerDelegate?

    init(_ delegate: JoystickManagerDelegate) {
        self.delegate = delegate
    }

    func leftHandler(data: CDJoystickData) {
        let angle = data.angle.radiansToDegrees
        let x = (data.velocity.x * 100).rounded()
        let y = (data.velocity.y * 100).rounded()

        if angle >= 220 || angle <=  90 {
            delegate?.didChangeThrottle(y * -1)
        }

        if angle > 90 && angle < 270 {
            delegate?.didChangeThrottle(0)
        }

        delegate?.didChangeYaw(x)
    }

    func rightHandler(data: CDJoystickData) {
        let x = (data.velocity.x * 100).rounded()
        let y = (data.velocity.y * 100).rounded()

        delegate?.didChangePitch(y * -1)
        delegate?.didChangeRoll(x)
    }

}
