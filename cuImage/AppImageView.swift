//
//  AppImageView.swift
//  cuImage
//
//  Created by Lizhen Hu on 22/02/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

class AppImageView: NSImageView {
    override func mouseDown(with event: NSEvent) {
        if let url = URL(string: Constants.macAppStoreLink) {
            NSWorkspace.shared.open(url)
        }
    }
}
