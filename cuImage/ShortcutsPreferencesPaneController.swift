//
//  ShortcutsPreferencesPaneController.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import MASShortcut

final class ShortcutsPreferencesPaneController: BasePreferencesPaneController {
    @IBOutlet weak var popUpStatusItemMenuShortcutView: MASShortcutView!
    @IBOutlet weak var uploadImageShortcutView: MASShortcutView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Join the key view loop, but without focus ring.
        uploadImageShortcutView.setAcceptsFirstResponder(true)
        uploadImageShortcutView.associatedUserDefaultsKey = PreferenceKeys.uploadImageShortcut.rawValue
        
        popUpStatusItemMenuShortcutView.setAcceptsFirstResponder(true)
        popUpStatusItemMenuShortcutView.associatedUserDefaultsKey = PreferenceKeys.popUpStatusItemMenuShortcut.rawValue
    }
}
