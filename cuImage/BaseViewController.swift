//
//  BaseViewController.swift
//  cuImage
//
//  Created by Lizhen Hu on 08/02/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

class BaseViewController: NSViewController {
    override var nibName: String? {
        return className.components(separatedBy: ".").last
    }
}
