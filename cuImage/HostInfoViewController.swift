//
//  HostInfoViewController.swift
//  cuImage
//
//  Created by HuLizhen on 10/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

protocol HostInfoViewController: class {
    func validateHostInfo(completion: @escaping (Bool) -> ())
    func saveHostInfo()
}
