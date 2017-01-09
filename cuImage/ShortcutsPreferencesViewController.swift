//
//  ShortcutsPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import MASShortcut

class ShortcutsPreferencesViewController: BasePreferencesViewController {
    @IBOutlet weak var uploadImageShortcutView: MASShortcutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shortcuts"

        uploadImageShortcutView.associatedUserDefaultsKey = PreferenceKeys.uploadImageShortcut.rawValue
    }
}
