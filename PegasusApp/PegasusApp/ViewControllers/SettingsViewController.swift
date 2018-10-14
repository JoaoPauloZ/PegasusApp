//
//  SettingsViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 12/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupNavigationBar()


    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Settings"
        let appearence = UINavigationBar.appearance()
        appearence.shadowImage = UIImage()
        appearence.tintColor = .white
        appearence.barTintColor = .clear
        appearence.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.prefersLargeTitles = true
        appearence.isTranslucent = false

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: nil)

    }

    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: UI Interface Orientation
extension UINavigationController {

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override open var prefersStatusBarHidden: Bool {
        return false
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override open var shouldAutorotate: Bool {
        return true
    }
}
