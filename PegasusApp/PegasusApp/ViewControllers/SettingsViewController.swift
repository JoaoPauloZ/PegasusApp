//
//  SettingsViewController.swift
//  PegasusApp
//
//  Created by João Paulo Serodio on 12/10/18.
//  Copyright © 2018 PremierSoft. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private var collectionView: TPKeyboardAvoidingCollectionView!
    private lazy var flowLayout = UICollectionViewFlowLayout()

    var preferences: [MotorPreference] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let bgImage = UIImage(named: "spiration-dark") {
            view.backgroundColor = UIColor(patternImage: bgImage)
        } else {
            view.backgroundColor = .lightGray
        }

        setupNavigationBar()
        addCollectionView()
        loadLocalPreferences()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = self.view.bounds.width
        flowLayout.itemSize = CGSize(width: w * 0.88, height: w * 0.6)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Settings"
        let appearence = UINavigationBar.appearance()
        appearence.shadowImage = UIImage()
        appearence.tintColor = .white
        appearence.barTintColor = UIColor(patternImage: UIImage(named: "spiration-dark")!)
        appearence.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        appearence.prefersLargeTitles = true
        appearence.isTranslucent = false

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate),
                                                           style: .done, target: self, action: #selector(dismissVC))
    }

    private func addCollectionView() {
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 30
        collectionView = TPKeyboardAvoidingCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MotorSettingsCell.self, forCellWithReuseIdentifier: MotorSettingsCell.reuseId)
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 20, right: 10)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }

    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferences.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MotorSettingsCell.reuseId, for: indexPath) as? MotorSettingsCell

        return cell ?? MotorSettingsCell()
    }

}

extension SettingsViewController {

    private func loadLocalPreferences() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "motorsPreferences") {
            if let dicArray = data.jsonArray {
                preferences = dicArray.map { dic -> MotorPreference in
                    return MotorPreference(dic)
                }
            }
        } else {
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
            preferences.append(MotorPreference())
        }
    }

    private func saveLocalPreferences() {
        let dicArray = preferences.map { motorPref -> [String: Any] in
            return motorPref.json
        }
        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "motorsPreferences")
        }
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
