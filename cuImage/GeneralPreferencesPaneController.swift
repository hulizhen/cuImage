//
//  GeneralPreferencesPaneController.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

final class GeneralPreferencesPaneController: BasePreferencesPaneController {
    @IBOutlet weak var notificationPreferencesButton: NSButton!
    @IBOutlet weak var qualitySlider: NSSlider!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        addObservers()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        removeObservers()
    }
    
    @IBAction func handleTappedButton(_ button: NSButton) {
        let notificationPreferencesPaneURL = URL(fileURLWithPath: Constants.notificationPreferencesPane)
        NSWorkspace.shared().open(notificationPreferencesPaneURL)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.useJPEGCompression:
            qualitySlider.isEnabled = preferences[.useJPEGCompression]
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    fileprivate func addObservers() {
        let defaults = UserDefaults.standard
        defaults.addObserver(self, forKeyPath: PreferenceKeys.useJPEGCompression.rawValue,
                             options: [.initial, .new], context: nil)
    }
    
    fileprivate func removeObservers() {
        let defaults = UserDefaults.standard
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.useJPEGCompression.rawValue)
    }
}
